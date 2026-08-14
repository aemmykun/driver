import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'ledger_client.dart';
import 'ledger_models.dart';

// ---------------------------------------------------------------------------
// LedgerRepository – thin data-access layer over the secure HTTP client.
// ---------------------------------------------------------------------------

class LedgerRepository {
  LedgerRepository(this._dio);

  final Dio _dio;
  static const _uuid = Uuid();

  /// Submit a single [LocalEntry] for commitment.
  ///
  /// On success returns the [CommittedEntry] returned by the server.
  /// Throws [DioException] on network errors; the caller is responsible for
  /// state-machine transitions on failure.
  Future<CommittedEntry> commitEntry(LocalEntry entry) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/ledger/entries',
      data: entry.toJson(),
    );

    return CommittedEntry.fromJson(response.data!);
  }

  /// Fetch all committed entries for the tenant, optionally filtered by
  /// [since] (ISO-8601 timestamp).
  Future<List<CommittedEntry>> fetchCommittedEntries({
    DateTime? since,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/ledger/entries',
      queryParameters: since != null
          ? {'since': since.toUtc().toIso8601String()}
          : null,
    );

    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(CommittedEntry.fromJson)
        .toList();
  }

  /// Generate a v4 UUID suitable for use as a [LocalEntry.localEntryId].
  static String newLocalId() => _uuid.v4();
}

// ---------------------------------------------------------------------------
// ledgerRepositoryProvider
// ---------------------------------------------------------------------------

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  final dio = ref.watch(secureLedgerClientProvider);
  return LedgerRepository(dio);
});

// ---------------------------------------------------------------------------
// LedgerNotifier – Riverpod StateNotifier that drives the state machine.
//
// State machine per entry:
//   Pending ──► Syncing ──► Committed ──► Locked
//                  │
//                  └──(error)──► Pending  (transient failures are retried)
// ---------------------------------------------------------------------------

class LedgerNotifier extends StateNotifier<LedgerState> {
  LedgerNotifier(this._repo) : super(const LedgerState());

  final LedgerRepository _repo;

  // ── Entry creation ────────────────────────────────────────────────────────

  /// Stage a new local entry.  The entry is created with [LedgerEntryStatus.pending]
  /// and will be committed on the next [syncPendingEntries] call.
  void addPendingEntry({
    required String tenantId,
    required String receiptId,
    required String platform,
    required double grossAmount,
    required String currency,
    DateTime? timestamp,
  }) {
    final entry = LocalEntry(
      localEntryId: LedgerRepository.newLocalId(),
      tenantId: tenantId,
      receiptId: receiptId,
      platform: platform,
      grossAmount: grossAmount,
      currency: currency,
      timestamp: timestamp ?? DateTime.now().toUtc(),
    );

    state = state.copyWith(
      localEntries: [...state.localEntries, entry],
    );
  }

  // ── Sync orchestration ────────────────────────────────────────────────────

  /// Commit all pending entries to the server.
  ///
  /// Entries are processed sequentially so that each one can be individually
  /// retried without blocking the others.  On completion the local list is
  /// pruned of successfully committed entries and [state.committedEntries] is
  /// extended.
  Future<void> syncPendingEntries() async {
    final pending = state.localEntries
        .where((e) => e.status == LedgerEntryStatus.pending)
        .toList();

    if (pending.isEmpty) return;

    state = state.copyWith(isSyncing: true, lastError: null);

    final updatedLocal = List<LocalEntry>.from(state.localEntries);
    final newlyCommitted = <CommittedEntry>[];
    String? lastError;

    for (final entry in pending) {
      // Transition: Pending → Syncing
      final idx = updatedLocal.indexWhere(
        (e) => e.localEntryId == entry.localEntryId,
      );
      if (idx == -1) continue;
      updatedLocal[idx] = entry.copyWith(status: LedgerEntryStatus.syncing);
      state = state.copyWith(localEntries: List.unmodifiable(updatedLocal));

      try {
        final committed = await _repo.commitEntry(updatedLocal[idx]);

        // Transition: Syncing → Committed (remove from local, add to committed)
        updatedLocal.removeAt(idx);
        newlyCommitted.add(committed);
      } on DioException catch (e) {
        // Transition: Syncing → Pending (retryable)
        updatedLocal[idx] =
            updatedLocal[idx].copyWith(status: LedgerEntryStatus.pending);
        lastError = e.message ?? e.toString();
      }
    }

    state = state.copyWith(
      localEntries: List.unmodifiable(updatedLocal),
      committedEntries: [
        ...state.committedEntries,
        ...newlyCommitted,
      ],
      isSyncing: false,
      lastError: lastError,
    );
  }

  // ── Lock management ───────────────────────────────────────────────────────

  /// Mark a committed entry as locked (immutable end-of-period finalisation).
  void lockEntry(String committedEntryId) {
    final updated = state.committedEntries.map((e) {
      if (e.committedEntryId == committedEntryId) {
        return e.copyWith(isLocked: true);
      }
      return e;
    }).toList();

    state = state.copyWith(committedEntries: updated);
  }

  /// Lock all committed entries for the given [tenantId] at once (e.g.
  /// triggered by an end-of-period server event).
  void lockAllForTenant(String tenantId) {
    final updated = state.committedEntries.map((e) {
      if (e.tenantId == tenantId) return e.copyWith(isLocked: true);
      return e;
    }).toList();

    state = state.copyWith(committedEntries: updated);
  }

  // ── Remote fetch ──────────────────────────────────────────────────────────

  /// Pull committed entries from the server and merge into local state.
  Future<void> fetchCommittedEntries({DateTime? since}) async {
    state = state.copyWith(isSyncing: true, lastError: null);

    try {
      final remote = await _repo.fetchCommittedEntries(since: since);

      // Deduplicate by committedEntryId, preferring the remote version.
      final merged = {
        for (final e in state.committedEntries) e.committedEntryId: e,
        for (final e in remote) e.committedEntryId: e,
      }.values.toList();

      state = state.copyWith(
        committedEntries: merged,
        isSyncing: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isSyncing: false,
        lastError: e.message ?? e.toString(),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// ledgerProvider – the primary Riverpod provider for the module.
// ---------------------------------------------------------------------------

final ledgerProvider =
    StateNotifierProvider<LedgerNotifier, LedgerState>((ref) {
  final repo = ref.watch(ledgerRepositoryProvider);
  return LedgerNotifier(repo);
});

// ---------------------------------------------------------------------------
// Convenience derived providers
// ---------------------------------------------------------------------------

/// All local entries still waiting to be committed.
final pendingEntriesProvider = Provider<List<LocalEntry>>((ref) {
  return ref
      .watch(ledgerProvider)
      .localEntries
      .where((e) => e.status == LedgerEntryStatus.pending)
      .toList();
});

/// All committed, non-locked entries for display.
final activeCommittedEntriesProvider = Provider<List<CommittedEntry>>((ref) {
  return ref
      .watch(ledgerProvider)
      .committedEntries
      .where((e) => !e.isLocked)
      .toList();
});

/// All locked (finalised) entries.
final lockedEntriesProvider = Provider<List<CommittedEntry>>((ref) {
  return ref
      .watch(ledgerProvider)
      .committedEntries
      .where((e) => e.isLocked)
      .toList();
});

/// Whether a sync is currently in progress.
final isSyncingProvider = Provider<bool>((ref) {
  return ref.watch(ledgerProvider).isSyncing;
});

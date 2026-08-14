// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_models.freezed.dart';
part 'ledger_models.g.dart';

// ---------------------------------------------------------------------------
// LocalEntry – a pending earnings record created on-device before sync.
// ---------------------------------------------------------------------------

@freezed
class LocalEntry with _$LocalEntry {
  const factory LocalEntry({
    required String localEntryId,
    required String tenantId,
    required String receiptId,
    /// Transport platform identifier, e.g. "UBER", "DIDI", "GRAB".
    required String platform,
    required double grossAmount,
    required String currency,
    required DateTime timestamp,
    @Default(LedgerEntryStatus.pending) LedgerEntryStatus status,
  }) = _LocalEntry;

  factory LocalEntry.fromJson(Map<String, dynamic> json) =>
      _$LocalEntryFromJson(json);
}

// ---------------------------------------------------------------------------
// CommittedEntry – the server-confirmed record returned after a successful sync.
// ---------------------------------------------------------------------------

@freezed
class CommittedEntry with _$CommittedEntry {
  const factory CommittedEntry({
    required String committedEntryId,
    required String localEntryId,
    required String tenantId,
    required String receiptId,
    required String platform,
    required double grossAmount,
    required String currency,
    required DateTime timestamp,
    required DateTime committedAt,
    @Default(false) bool isLocked,
  }) = _CommittedEntry;

  factory CommittedEntry.fromJson(Map<String, dynamic> json) =>
      _$CommittedEntryFromJson(json);
}

// ---------------------------------------------------------------------------
// LedgerEntryStatus – the four-state machine for an entry's lifecycle.
//
//   Pending ──► Syncing ──► Committed ──► Locked
//                  │
//                  └──► Pending  (on transient error, retryable)
// ---------------------------------------------------------------------------

enum LedgerEntryStatus {
  /// Created locally; not yet submitted to the server.
  pending,

  /// In-flight: the sync request has been dispatched and we are awaiting
  /// the server response.
  syncing,

  /// The server accepted the entry and returned a [CommittedEntry].
  committed,

  /// The entry has been finalised (e.g. end-of-period lock) and is immutable.
  locked,
}

// ---------------------------------------------------------------------------
// LedgerState – the Riverpod UI-facing aggregate state.
// ---------------------------------------------------------------------------

@freezed
class LedgerState with _$LedgerState {
  const factory LedgerState({
    @Default([]) List<LocalEntry> localEntries,
    @Default([]) List<CommittedEntry> committedEntries,
    @Default(false) bool isSyncing,
    String? lastError,
  }) = _LedgerState;

  factory LedgerState.fromJson(Map<String, dynamic> json) =>
      _$LedgerStateFromJson(json);
}

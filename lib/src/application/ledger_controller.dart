import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import '../domain/ledger_models.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase.instance);

final ledgerControllerProvider =
    AsyncNotifierProvider<LedgerController, List<LedgerEntry>>(LedgerController.new);

class LedgerController extends AsyncNotifier<List<LedgerEntry>> {
  AppDatabase get _database => ref.read(databaseProvider);

  @override
  Future<List<LedgerEntry>> build() => _database.listEntries();

  Future<void> save(LedgerEntry entry) async {
    await _database.upsertEntry(entry);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(String id) async {
    await _database.deleteEntry(id);
    ref.invalidateSelf();
    await future;
  }

  Future<int> saveAll(Iterable<LedgerEntry> entries) async {
    var count = 0;
    for (final entry in entries) {
      await _database.upsertEntry(entry);
      count++;
    }
    ref.invalidateSelf();
    await future;
    return count;
  }
}

final profileProvider =
    AsyncNotifierProvider<ProfileController, DriverProfile>(ProfileController.new);

class ProfileController extends AsyncNotifier<DriverProfile> {
  AppDatabase get _database => ref.read(databaseProvider);

  @override
  Future<DriverProfile> build() async {
    final settings = await _database.settings();
    return DriverProfile(
      abn: settings['abn'] ?? '',
      gstRegistered: settings['gst_registered'] == 'true',
      accountingBasis: settings['accounting_basis'] ?? 'cash',
      displayName: settings['display_name'] ?? '',
    );
  }

  Future<void> save(DriverProfile profile) async {
    await _database.setSetting('abn', profile.abn);
    await _database.setSetting('gst_registered', '${profile.gstRegistered}');
    await _database.setSetting('accounting_basis', profile.accountingBasis);
    await _database.setSetting('display_name', profile.displayName);
    state = AsyncData(profile);
  }
}

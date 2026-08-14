import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../data/app_database.dart';
import '../domain/ledger_models.dart';
import '../domain/tax_engine.dart';

class EvidenceExportResult {
  const EvidenceExportResult({required this.path, required this.sha256Hash});
  final String path;
  final String sha256Hash;
}

class EvidenceExportService {
  const EvidenceExportService();
  static const _uuid = Uuid();
  static const declarationText =
      'I reviewed the source entries and confirm this draft reflects the records I supplied. I understand this software is not a registered tax or BAS agent.';

  Future<EvidenceExportResult> export({
    required BasDraft draft,
    required DriverProfile profile,
    required List<LedgerEntry> entries,
    required AppDatabase database,
  }) async {
    final periodEntries = entries.where((entry) =>
        !entry.occurredAt.isBefore(draft.periodStart) && entry.occurredAt.isBefore(draft.periodEnd));
    final payload = <String, Object?>{
      'schemaVersion': 'driver-ledger-bas-evidence/1',
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'period': {
        'start': draft.periodStart.toUtc().toIso8601String(),
        'endExclusive': draft.periodEnd.toUtc().toIso8601String(),
      },
      'taxpayerConfirmation': {
        'abn': profile.abn,
        'gstRegistered': profile.gstRegistered,
        'accountingBasis': profile.accountingBasis,
      },
      'basDraftCents': {
        'G1': draft.g1TotalSalesCents,
        '1A': draft.oneAGstOnSalesCents,
        '1B': draft.oneBGstCreditsCents,
        'netGstPayable': draft.netGstPayableCents,
      },
      'declaration': declarationText,
      'entries': periodEntries.map((entry) => entry.toMap()).toList(),
    };
    final canonical = const JsonEncoder.withIndent('  ').convert(payload);
    final hash = sha256.convert(utf8.encode(canonical)).toString();
    final directory = await getApplicationDocumentsDirectory();
    final exportDirectory = Directory(p.join(directory.path, 'exports'));
    await exportDirectory.create(recursive: true);
    final id = _uuid.v4();
    final target = p.join(exportDirectory.path, 'bas-evidence-${draft.periodStart.toIso8601String().substring(0, 10)}-$id.json');
    await File(target).writeAsString(canonical, flush: true);
    await database.recordDeclaration(
      id: id,
      periodStart: draft.periodStart,
      periodEnd: draft.periodEnd,
      payloadHash: hash,
      declarationText: declarationText,
      declaredAt: DateTime.now().toUtc(),
    );
    return EvidenceExportResult(path: target, sha256Hash: hash);
  }
}

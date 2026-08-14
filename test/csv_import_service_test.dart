import 'package:driver/src/domain/ledger_models.dart';
import 'package:driver/src/services/csv_import_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('imports common earnings columns using cents', () {
    const csv = 'date,amount,description,trip id\n14/08/2026,42.50,Fare,trip-1\n';
    final entries = const CsvImportService().parse(csv, source: EntrySource.uberCsv);
    expect(entries, hasLength(1));
    expect(entries.single.amountCents, 4250);
    expect(entries.single.sourceReference, 'trip-1');
    expect(entries.single.kind, EntryKind.income);
  });

  test('rejects a file without required columns', () {
    expect(
      () => const CsvImportService().parse('foo,bar\na,b\n', source: EntrySource.didiCsv),
      throwsA(isA<CsvImportException>()),
    );
  });
}

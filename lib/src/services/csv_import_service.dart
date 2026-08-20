import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../domain/ledger_models.dart';
import '../domain/tax_engine.dart';

class CsvImportException implements Exception {
  const CsvImportException(this.message);
  final String message;
  @override
  String toString() => message;
}

class CsvImportService {
  const CsvImportService();
  static const _uuid = Uuid();

  List<LedgerEntry> parse(String raw, {required EntrySource source}) {
    final rows = const CsvToListConverter(eol: '\n').convert(raw);
    if (rows.length < 2) throw const CsvImportException('CSV contains no data rows.');
    final headers = rows.first.map((value) => '$value'.trim().toLowerCase()).toList();
    final dateIndex = _index(headers, const ['date', 'transaction date', 'trip date']);
    final amountIndex = _index(headers, const ['amount', 'gross', 'gross amount', 'earnings']);
    final descriptionIndex = _indexOptional(headers, const ['description', 'type', 'category']);
    final referenceIndex = _indexOptional(headers, const ['id', 'trip id', 'payment id', 'reference']);

    final entries = <LedgerEntry>[];
    for (var rowNumber = 1; rowNumber < rows.length; rowNumber++) {
      final row = rows[rowNumber];
      if (row.every((value) => '$value'.trim().isEmpty)) continue;
      try {
        final occurredAt = _parseDate('${row[dateIndex]}');
        final amount = _parseAmount('${row[amountIndex]}');
        if (amount == 0) continue;
        final description = descriptionIndex == null
            ? '${source.name} import'
            : '${row[descriptionIndex]}'.trim();
        final suppliedReference = referenceIndex == null ? '' : '${row[referenceIndex]}'.trim();
        final canonical = '$source|${occurredAt.toUtc().toIso8601String()}|$amount|$description|$suppliedReference';
        final sourceReference = suppliedReference.isNotEmpty
            ? suppliedReference
            : sha256.convert(utf8.encode(canonical)).toString();
        final cents = (amount.abs() * 100).round();
        entries.add(LedgerEntry(
          id: _uuid.v4(),
          kind: amount >= 0 ? EntryKind.income : EntryKind.expense,
          occurredAt: occurredAt,
          description: description.isEmpty ? '${source.name} import' : description,
          amountCents: cents,
          gstCents: AustralianRideshareTaxEngine.gstIncludedInCents(cents),
          businessUseBasisPoints: 10000,
          source: source,
          sourceReference: sourceReference,
          category: amount >= 0 ? null : ExpenseCategory.platformFees,
          evidenceStatus: EvidenceStatus.attached,
        ));
      } on FormatException catch (error) {
        throw CsvImportException('Row ${rowNumber + 1}: ${error.message}');
      }
    }
    return entries;
  }

  int _index(List<String> headers, List<String> accepted) {
    final value = _indexOptional(headers, accepted);
    if (value == null) throw CsvImportException('Required column missing: ${accepted.join(' / ')}');
    return value;
  }

  int? _indexOptional(List<String> headers, List<String> accepted) {
    for (final name in accepted) {
      final index = headers.indexOf(name);
      if (index >= 0) return index;
    }
    return null;
  }

  DateTime _parseDate(String value) {
    final trimmed = value.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;
    for (final format in ['dd/MM/yyyy', 'd/M/yyyy', 'MM/dd/yyyy']) {
      try {
        return DateFormat(format).parseStrict(trimmed);
      } on FormatException {
        // Try the next declared format.
      }
    }
    throw FormatException('invalid date "$trimmed"');
  }

  double _parseAmount(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.parse(cleaned);
  }
}

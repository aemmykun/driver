enum EntryKind { income, expense }

enum EntrySource { manual, uberCsv, didiCsv, uberApi, didiApi }

enum EvidenceStatus { missing, attached, verified }

enum ExpenseCategory {
  fuel,
  cleaning,
  insurance,
  registration,
  repairs,
  tolls,
  parking,
  platformFees,
  phone,
  accounting,
  vehicleDepreciation,
  other,
}

class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.kind,
    required this.occurredAt,
    required this.description,
    required this.amountCents,
    required this.gstCents,
    required this.businessUseBasisPoints,
    required this.source,
    required this.sourceReference,
    required this.category,
    required this.evidenceStatus,
    this.receiptPath,
    this.createdAt,
  });

  final String id;
  final EntryKind kind;
  final DateTime occurredAt;
  final String description;
  final int amountCents;
  final int gstCents;
  final int businessUseBasisPoints;
  final EntrySource source;
  final String sourceReference;
  final ExpenseCategory? category;
  final EvidenceStatus evidenceStatus;
  final String? receiptPath;
  final DateTime? createdAt;

  int get deductibleCents =>
      kind == EntryKind.expense ? amountCents * businessUseBasisPoints ~/ 10000 : 0;

  Map<String, Object?> toMap() => {
        'id': id,
        'kind': kind.name,
        'occurred_at': occurredAt.toUtc().toIso8601String(),
        'description': description,
        'amount_cents': amountCents,
        'gst_cents': gstCents,
        'business_use_bps': businessUseBasisPoints,
        'source': source.name,
        'source_reference': sourceReference,
        'category': category?.name,
        'evidence_status': evidenceStatus.name,
        'receipt_path': receiptPath,
        'created_at': (createdAt ?? DateTime.now().toUtc()).toIso8601String(),
      };

  factory LedgerEntry.fromMap(Map<String, Object?> map) => LedgerEntry(
        id: map['id']! as String,
        kind: EntryKind.values.byName(map['kind']! as String),
        occurredAt: DateTime.parse(map['occurred_at']! as String),
        description: map['description']! as String,
        amountCents: map['amount_cents']! as int,
        gstCents: map['gst_cents']! as int,
        businessUseBasisPoints: map['business_use_bps']! as int,
        source: EntrySource.values.byName(map['source']! as String),
        sourceReference: map['source_reference']! as String,
        category: map['category'] == null
            ? null
            : ExpenseCategory.values.byName(map['category']! as String),
        evidenceStatus:
            EvidenceStatus.values.byName(map['evidence_status']! as String),
        receiptPath: map['receipt_path'] as String?,
        createdAt: DateTime.parse(map['created_at']! as String),
      );
}

class DriverProfile {
  const DriverProfile({
    this.abn = '',
    this.gstRegistered = false,
    this.accountingBasis = 'cash',
    this.displayName = '',
  });

  final String abn;
  final bool gstRegistered;
  final String accountingBasis;
  final String displayName;

  bool get hasValidAbnShape => RegExp(r'^\d{11}$').hasMatch(abn);
}

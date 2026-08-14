import 'ledger_models.dart';

class BasDraft {
  const BasDraft({
    required this.periodStart,
    required this.periodEnd,
    required this.g1TotalSalesCents,
    required this.oneAGstOnSalesCents,
    required this.oneBGstCreditsCents,
    required this.deductibleExpenseCents,
    required this.entriesWithoutEvidence,
  });

  final DateTime periodStart;
  final DateTime periodEnd;
  final int g1TotalSalesCents;
  final int oneAGstOnSalesCents;
  final int oneBGstCreditsCents;
  final int deductibleExpenseCents;
  final int entriesWithoutEvidence;

  int get netGstPayableCents => oneAGstOnSalesCents - oneBGstCreditsCents;
}

class AustralianRideshareTaxEngine {
  const AustralianRideshareTaxEngine();

  BasDraft calculate({
    required Iterable<LedgerEntry> entries,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) {
    final periodEntries = entries.where((entry) {
      final date = entry.occurredAt.toUtc();
      return !date.isBefore(periodStart.toUtc()) && date.isBefore(periodEnd.toUtc());
    }).toList(growable: false);

    var sales = 0;
    var gstOnSales = 0;
    var gstCredits = 0;
    var deductibleExpenses = 0;
    var missingEvidence = 0;

    for (final entry in periodEntries) {
      if (entry.kind == EntryKind.income) {
        sales += entry.amountCents;
        gstOnSales += entry.gstCents;
      } else {
        final businessGst = entry.gstCents * entry.businessUseBasisPoints ~/ 10000;
        gstCredits += businessGst;
        deductibleExpenses +=
            (entry.amountCents - entry.gstCents) * entry.businessUseBasisPoints ~/ 10000;
        if (entry.evidenceStatus == EvidenceStatus.missing) missingEvidence++;
      }
    }

    return BasDraft(
      periodStart: periodStart,
      periodEnd: periodEnd,
      g1TotalSalesCents: sales,
      oneAGstOnSalesCents: gstOnSales,
      oneBGstCreditsCents: gstCredits,
      deductibleExpenseCents: deductibleExpenses,
      entriesWithoutEvidence: missingEvidence,
    );
  }

  static int gstIncludedInCents(int gstInclusiveCents) =>
      (gstInclusiveCents / 11).round();
}

enum LodgementBlockCode {
  invalidAbn,
  gstRegistrationUnconfirmed,
  evidenceMissing,
  userDeclarationMissing,
  sbrAccreditationMissing,
}

class LodgementReadiness {
  const LodgementReadiness(this.blockers);
  final List<LodgementBlockCode> blockers;
  bool get canTransmit => blockers.isEmpty;
}

class LodgementGate {
  const LodgementGate({this.sbrAccredited = false});
  final bool sbrAccredited;

  LodgementReadiness evaluate({
    required DriverProfile profile,
    required BasDraft draft,
    required bool userDeclared,
  }) {
    final blockers = <LodgementBlockCode>[];
    if (!profile.hasValidAbnShape) blockers.add(LodgementBlockCode.invalidAbn);
    if (!profile.gstRegistered) {
      blockers.add(LodgementBlockCode.gstRegistrationUnconfirmed);
    }
    if (draft.entriesWithoutEvidence > 0) {
      blockers.add(LodgementBlockCode.evidenceMissing);
    }
    if (!userDeclared) blockers.add(LodgementBlockCode.userDeclarationMissing);
    if (!sbrAccredited) blockers.add(LodgementBlockCode.sbrAccreditationMissing);
    return LodgementReadiness(List.unmodifiable(blockers));
  }
}

class PotentialDeduction {
  const PotentialDeduction(this.category, this.title, this.evidence);
  final ExpenseCategory category;
  final String title;
  final String evidence;
}

const potentialDeductions = <PotentialDeduction>[
  PotentialDeduction(ExpenseCategory.fuel, 'Fuel and charging', 'Receipt plus business-use allocation'),
  PotentialDeduction(ExpenseCategory.cleaning, 'Vehicle cleaning', 'Receipt and rideshare purpose'),
  PotentialDeduction(ExpenseCategory.insurance, 'Insurance', 'Policy invoice and business-use percentage'),
  PotentialDeduction(ExpenseCategory.registration, 'Registration', 'Registration statement and business-use percentage'),
  PotentialDeduction(ExpenseCategory.repairs, 'Repairs and servicing', 'Tax invoice and business-use percentage'),
  PotentialDeduction(ExpenseCategory.tolls, 'Tolls', 'Statement linked to rideshare activity'),
  PotentialDeduction(ExpenseCategory.platformFees, 'Platform service fees', 'Platform payment statement'),
  PotentialDeduction(ExpenseCategory.phone, 'Phone and data', 'Bills and reasonable business-use basis'),
  PotentialDeduction(ExpenseCategory.accounting, 'Accounting costs', 'Invoice and service description'),
];

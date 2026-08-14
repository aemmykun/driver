import 'package:driver/src/domain/ledger_models.dart';
import 'package:driver/src/domain/tax_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = AustralianRideshareTaxEngine();
  final start = DateTime.utc(2026, 7);
  final end = DateTime.utc(2026, 10);

  test('calculates BAS cents and applies business use to credits', () {
    final draft = engine.calculate(
      entries: [
        LedgerEntry(
          id: 'income',
          kind: EntryKind.income,
          occurredAt: DateTime.utc(2026, 8, 1),
          description: 'Fare',
          amountCents: 11000,
          gstCents: 1000,
          businessUseBasisPoints: 10000,
          source: EntrySource.manual,
          sourceReference: 'income',
          category: null,
          evidenceStatus: EvidenceStatus.attached,
        ),
        LedgerEntry(
          id: 'fuel',
          kind: EntryKind.expense,
          occurredAt: DateTime.utc(2026, 8, 2),
          description: 'Fuel',
          amountCents: 1100,
          gstCents: 100,
          businessUseBasisPoints: 7500,
          source: EntrySource.manual,
          sourceReference: 'fuel',
          category: ExpenseCategory.fuel,
          evidenceStatus: EvidenceStatus.attached,
        ),
      ],
      periodStart: start,
      periodEnd: end,
    );

    expect(draft.g1TotalSalesCents, 11000);
    expect(draft.oneAGstOnSalesCents, 1000);
    expect(draft.oneBGstCreditsCents, 75);
    expect(draft.netGstPayableCents, 925);
    expect(draft.deductibleExpenseCents, 750);
  });

  test('uses a half-open reporting period', () {
    final draft = engine.calculate(
      entries: [
        LedgerEntry(
          id: 'boundary',
          kind: EntryKind.income,
          occurredAt: end,
          description: 'Next quarter',
          amountCents: 1100,
          gstCents: 100,
          businessUseBasisPoints: 10000,
          source: EntrySource.manual,
          sourceReference: 'boundary',
          category: null,
          evidenceStatus: EvidenceStatus.attached,
        ),
      ],
      periodStart: start,
      periodEnd: end,
    );
    expect(draft.g1TotalSalesCents, 0);
  });

  test('lodgement fails closed without accreditation', () {
    final readiness = const LodgementGate().evaluate(
      profile: const DriverProfile(abn: '12345678901', gstRegistered: true),
      draft: BasDraft(
        periodStart: start,
        periodEnd: end,
        g1TotalSalesCents: 0,
        oneAGstOnSalesCents: 0,
        oneBGstCreditsCents: 0,
        deductibleExpenseCents: 0,
        entriesWithoutEvidence: 0,
      ),
      userDeclared: true,
    );
    expect(readiness.canTransmit, isFalse);
    expect(readiness.blockers, contains(LodgementBlockCode.sbrAccreditationMissing));
  });
}

# Australian tax and BAS boundary

## Implemented control model

The tax engine is deterministic and evidence-oriented. It calculates only from
stored ledger fields and does not infer missing facts.

- amounts are stored as integer cents
- periods are half-open: `periodStart <= occurredAt < periodEnd`
- `G1` is recorded gross rideshare sales in the selected period
- `1A` is recorded GST on those sales
- `1B` is recorded eligible GST amount multiplied by confirmed business use
- expenses without evidence create a lodgement blocker
- the exported payload is hashed and the user's declaration is retained

## Not a deductibility decision

Expense categories are prompts for records that may be relevant. Eligibility
depends on the driver's facts, private use, documentation and current law. The
app must use wording such as “possible deduction record”, not “you are entitled”.

## Lodgement governance

The TPB guidance for digital service providers requires a review/verification
mechanism and retention of evidence before transmission where the provider is
not acting as a registered agent. The MVP implements the review declaration and
hash evidence but deliberately lacks a production transmitter.

## Rule maintenance

Every released rule set should carry:

- effective start/end dates
- authoritative source URL and retrieval date
- calculation version
- tests for boundary dates, GST rounding and private-use allocation
- approval by an accountable tax-domain reviewer

This MVP uses `driver-ledger-bas-evidence/1` as the export schema version.

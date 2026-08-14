# CSV import contract

CSV must contain one column from each required group:

| Field | Accepted headings |
|---|---|
| Date | `date`, `transaction date`, `trip date` |
| Amount | `amount`, `gross`, `gross amount`, `earnings` |

Optional columns:

| Field | Accepted headings |
|---|---|
| Description | `description`, `type`, `category` |
| Provider reference | `id`, `trip id`, `payment id`, `reference` |

Positive amounts import as income and negative amounts as expenses. If the
provider reference is absent, the app generates a SHA-256 reference from the
source, date, amount and description. Re-importing the same row is ignored by
the database uniqueness constraint.

The importer does not certify that the provider's amount is GST-inclusive.
Users must review imported GST treatment against the statement.

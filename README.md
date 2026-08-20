# Driver Ledger AU

Local-first Flutter MVP for Australian rideshare drivers to record income,
expenses, receipts and GST evidence.

## Product boundary

The app:

- records manual income and expenses using integer cents
- captures receipt images into the application documents directory
- imports Uber and DiDi-style CSV statements
- deduplicates imported rows by provider reference or canonical row hash
- calculates a reviewable quarterly GST/BAS draft (`G1`, `1A`, `1B`)
- records business-use percentages and missing-evidence blockers
- exports a JSON evidence pack with a SHA-256 payload hash
- fails closed on ATO transmission until SBR/DSP conformance and credentials

The app does **not**:

- decide that an expense is legally deductible
- verify ABN or GST registration with the ATO
- provide personalised tax or BAS advice
- transmit a BAS to the ATO in this MVP
- claim that an Uber or DiDi connection is active without provider approval

## Run locally

```bash
flutter --version
bash tool/bootstrap_platforms.sh
flutter pub get
flutter analyze
flutter test
flutter run
```

The bootstrap command creates standard Android and iOS runner projects with
the bundle namespace `org.tenantsage.driver`. Run it once and commit the
generated runner projects when preparing a signed store release.

## Architecture

```text
Flutter UI
  -> Riverpod controllers
    -> SQLite local ledger
      -> tax/evidence engine
        -> review + declaration + evidence export
          -X-> ATO transmission (blocked without accreditation)

CSV files -> deterministic parser -> unique source reference -> SQLite
Uber API  -> adapter boundary (limited access; backend OAuth required)
DiDi API  -> unavailable boundary -> CSV fallback
```

## Deployment status

The repository includes:

- Flutter analysis and unit-test CI
- Android debug compilation
- iOS simulator compilation without distribution signing
- a manually triggered Android release-candidate AAB artifact

Publishing still requires operator-owned credentials:

- Google Play application and production signing key
- Apple Developer team, App Store Connect application and distribution signing
- final privacy-policy URL, support URL, screenshots and store declarations
- Uber Drivers API approval and a backend OAuth/token service for direct sync
- SBR/DSP onboarding, conformance and production credentials for ATO transmission

See [Deployment](docs/DEPLOYMENT.md), [Tax boundary](docs/TAX_BOUNDARY.md),
[CSV format](docs/CSV_FORMAT.md) and [Privacy](PRIVACY.md).

## Authoritative references

- [ATO ride-sourcing](https://www.ato.gov.au/businesses-and-organisations/income-deductions-and-concessions/sharing-economy-and-tax/ride-sourcing)
- [ATO income and deductions for ride-sourcing](https://www.ato.gov.au/businesses-and-organisations/income-deductions-and-concessions/sharing-economy-and-tax/ride-sourcing/income-and-deductions-for-ride-sourcing)
- [ATO record keeping](https://www.ato.gov.au/businesses-and-organisations/income-deductions-and-concessions/sharing-economy-and-tax/ride-sourcing/record-keeping)
- [TPB guidance for digital service providers](https://www.tpb.gov.au/tpb-gs-14-2011-digital-service-providers-and-tax-agent-services-act-2009)
- [Uber Drivers API](https://developer.uber.com/docs/drivers/introduction)

Rules and rates must be reviewed before every production tax-rule release.

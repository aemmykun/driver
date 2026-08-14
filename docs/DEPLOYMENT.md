# Deployment runbook

## 1. Validate source

```bash
bash tool/bootstrap_platforms.sh
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
flutter build ios --simulator --debug
```

CI performs the same analysis, tests and Android/iOS simulator compilation.

## 2. Android production release

1. Create the Google Play application and reserve the final application ID.
2. Generate an upload keystore outside the repository.
3. Configure Android signing through `android/key.properties`; never commit the
   keystore or passwords.
4. Review `version` in `pubspec.yaml` and increment the build number.
5. Build with `flutter build appbundle --release`.
6. Upload first to an internal testing track and verify database upgrades,
   receipt capture, CSV import and evidence export on physical devices.

The included workflow produces a release candidate only. It is not a
store-authorised release until operator signing and Play Console checks pass.

## 3. iOS production release

1. Create the App ID and App Store Connect record.
2. Select the operator's Apple Developer Team in Xcode.
3. Add camera usage text to `ios/Runner/Info.plist` before archive review.
4. Configure distribution certificates/profiles using operator-controlled
   secrets or App Store Connect managed signing.
5. Archive and distribute to TestFlight first.

## 4. Store/compliance inputs still required

- final product name and legal entity
- support and privacy-policy public URLs
- data safety/privacy nutrition declarations
- account deletion flow if cloud accounts are later added
- Australian tax/BAS legal review
- provider agreements for Uber and DiDi data
- incident response and vulnerability reporting contacts

## 5. Direct provider sync

Do not embed OAuth client secrets in Flutter. Direct sync requires a backend
that holds provider credentials, exchanges OAuth codes, encrypts refresh tokens
and returns only the authorised driver's data. Uber Drivers API access is
limited and must be approved. DiDi remains CSV-only until an official supported
Australian driver API and agreement are verified.

## 6. ATO transmission

Keep `LodgementGate.sbrAccredited` false until all of the following are proven:

- DSP/SBR onboarding completed
- applicable conformance suite passed
- EVTE testing completed
- machine credentials and production endpoints provisioned
- user review, declaration and payload evidence retained
- privacy, security and incident controls approved

Changing the boolean alone is not authority to transmit.

# driver

Production-grade Riverpod ledger sync module for driver earnings.

## Module overview

```
lib/
├── ledger.dart                  ← public barrel export
└── src/ledger/
    ├── ledger_models.dart       ← DTOs (LocalEntry, CommittedEntry, LedgerState)
    ├── ledger_models.freezed.dart
    ├── ledger_models.g.dart
    ├── ledger_client.dart       ← secureLedgerClientProvider + TenantIsolationInterceptor
    └── ledger_sync.dart         ← LedgerNotifier + Riverpod providers
```

## State machine

```
Pending ──► Syncing ──► Committed ──► Locked
               │
               └──(transient error)──► Pending
```

| Status      | Meaning                                                      |
|-------------|--------------------------------------------------------------|
| `pending`   | Created on-device, not yet submitted to the server           |
| `syncing`   | HTTP request dispatched, awaiting server response            |
| `committed` | Server accepted the entry and returned a `CommittedEntry`    |
| `locked`    | End-of-period finalisation; entry is immutable               |

## Quick start

### 1. Override `ledgerClientConfigProvider`

```dart
runApp(
  ProviderScope(
    overrides: [
      ledgerClientConfigProvider.overrideWithValue(
        LedgerClientConfig(
          baseUrl: 'https://api.example.com/v1',
          tenantId: currentTenantId,
          tokenProvider: () => authService.currentToken,
          onTenantMismatch: () => authService.signOut(),
        ),
      ),
    ],
    child: const MyApp(),
  ),
);
```

### 2. Stage a new entry

```dart
ref.read(ledgerProvider.notifier).addPendingEntry(
  tenantId: 'tenant-abc',
  receiptId: 'receipt-123',
  platform: 'UBER',
  grossAmount: 42.50,
  currency: 'USD',
);
```

### 3. Sync pending entries

```dart
await ref.read(ledgerProvider.notifier).syncPendingEntries();
```

### 4. Watch derived state

```dart
final pending   = ref.watch(pendingEntriesProvider);
final active    = ref.watch(activeCommittedEntriesProvider);
final locked    = ref.watch(lockedEntriesProvider);
final isSyncing = ref.watch(isSyncingProvider);
```

## Dependencies

| Package              | Role                             |
|----------------------|----------------------------------|
| `flutter_riverpod`   | State management                 |
| `freezed_annotation` | Immutable data classes           |
| `json_annotation`    | JSON serialisation               |
| `dio`                | HTTP transport + interceptors    |
| `uuid`               | Local entry ID generation        |
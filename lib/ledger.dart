/// Ledger sync module – public surface area.
///
/// Import this single file to access:
///   - [LocalEntry] / [CommittedEntry] DTOs
///   - [LedgerEntryStatus] state machine enum
///   - [LedgerState] aggregate state
///   - [ledgerProvider] (StateNotifierProvider)
///   - [pendingEntriesProvider], [activeCommittedEntriesProvider],
///     [lockedEntriesProvider], [isSyncingProvider]
///   - [secureLedgerClientProvider], [TenantIsolationInterceptor]
///   - [ledgerClientConfigProvider] / [LedgerClientConfig]
library ledger;

export 'src/ledger/ledger_client.dart'
    show
        LedgerClientConfig,
        TenantIsolationInterceptor,
        ledgerClientConfigProvider,
        secureLedgerClientProvider;
export 'src/ledger/ledger_models.dart'
    show
        CommittedEntry,
        LedgerEntryStatus,
        LedgerState,
        LocalEntry;
export 'src/ledger/ledger_sync.dart'
    show
        LedgerNotifier,
        LedgerRepository,
        activeCommittedEntriesProvider,
        isSyncingProvider,
        ledgerProvider,
        ledgerRepositoryProvider,
        lockedEntriesProvider,
        pendingEntriesProvider;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ledger_controller.dart';
import '../../domain/ledger_models.dart';
import '../../ui/formatters.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ledgerControllerProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _Error(message: '$error', onRetry: () => ref.invalidate(ledgerControllerProvider)),
      data: (entries) {
        final income = entries
            .where((entry) => entry.kind == EntryKind.income)
            .fold<int>(0, (total, entry) => total + entry.amountCents);
        final expenses = entries
            .where((entry) => entry.kind == EntryKind.expense)
            .fold<int>(0, (total, entry) => total + entry.amountCents);
        final missing = entries
            .where((entry) => entry.kind == EntryKind.expense && entry.evidenceStatus == EvidenceStatus.missing)
            .length;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Your rideshare position', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            const Text('Recorded amounts only. Review GST and tax treatment before relying on a report.'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Metric(label: 'Gross income', value: aud(income), icon: Icons.trending_up),
                _Metric(label: 'Expenses', value: aud(expenses), icon: Icons.trending_down),
                _Metric(label: 'Cash position', value: aud(income - expenses), icon: Icons.account_balance_wallet_outlined),
                _Metric(label: 'Missing evidence', value: '$missing', icon: Icons.warning_amber_outlined),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Operational checks', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    _Check(ok: entries.isNotEmpty, text: 'At least one ledger entry recorded'),
                    _Check(ok: missing == 0, text: 'Expense evidence complete'),
                    _Check(ok: false, text: 'ATO transmission accreditation configured'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 170,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 14),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              Text(label),
            ]),
          ),
        ),
      );
}

class _Check extends StatelessWidget {
  const _Check({required this.ok, required this.text});
  final bool ok;
  final String text;
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(ok ? Icons.check_circle : Icons.cancel_outlined,
            color: ok ? Colors.green : Colors.orange),
        title: Text(text),
      );
}

class _Error extends StatelessWidget {
  const _Error({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ]),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../application/ledger_controller.dart';
import '../../domain/ledger_models.dart';
import '../../domain/tax_engine.dart';
import '../../services/receipt_service.dart';
import '../../ui/formatters.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(ledgerControllerProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => const _EntryForm(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add entry'),
      ),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No entries yet. Add one or import a statement.'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final entry = items[index];
                  final income = entry.kind == EntryKind.income;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: income ? Colors.green.shade50 : Colors.orange.shade50,
                        child: Icon(income ? Icons.south_west : Icons.north_east,
                            color: income ? Colors.green : Colors.orange),
                      ),
                      title: Text(entry.description),
                      subtitle: Text('${shortDate(entry.occurredAt)} • ${entry.source.name} • ${entry.evidenceStatus.name}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${income ? '+' : '-'}${aud(entry.amountCents)}',
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text('GST ${aud(entry.gstCents)}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      onLongPress: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete entry?'),
                            content: const Text('This removes the local record. Export evidence before deletion.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await ref.read(ledgerControllerProvider.notifier).remove(entry.id);
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _EntryForm extends ConsumerStatefulWidget {
  const _EntryForm();
  @override
  ConsumerState<_EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends ConsumerState<_EntryForm> {
  static const _uuid = Uuid();
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _businessUse = TextEditingController(text: '100');
  var _kind = EntryKind.income;
  var _category = ExpenseCategory.fuel;
  var _gstIncluded = true;
  String? _receiptPath;
  var _saving = false;

  @override
  void dispose() {
    _description.dispose();
    _amount.dispose();
    _businessUse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.viewInsetsOf(context).bottom + 16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text('New ledger entry', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            SegmentedButton<EntryKind>(
              segments: const [
                ButtonSegment(value: EntryKind.income, label: Text('Income'), icon: Icon(Icons.add_card)),
                ButtonSegment(value: EntryKind.expense, label: Text('Expense'), icon: Icon(Icons.receipt)),
              ],
              selected: {_kind},
              onSelectionChanged: (value) => setState(() => _kind = value.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Description is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'GST-inclusive amount (AUD)', prefixText: r'$ '),
              validator: (value) {
                final amount = double.tryParse(value ?? '');
                return amount == null || amount <= 0 ? 'Enter an amount greater than zero' : null;
              },
            ),
            if (_kind == EntryKind.expense) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<ExpenseCategory>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Expense category'),
                items: ExpenseCategory.values
                    .map((value) => DropdownMenuItem(value: value, child: Text(value.name)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _businessUse,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Business use', suffixText: '%'),
                validator: (value) {
                  final percent = int.tryParse(value ?? '');
                  return percent == null || percent < 0 || percent > 100 ? 'Use a value from 0 to 100' : null;
                },
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Amount includes GST'),
              subtitle: const Text('Confirm against the source statement or tax invoice.'),
              value: _gstIncluded,
              onChanged: (value) => setState(() => _gstIncluded = value),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                final path = await ReceiptService().capture();
                if (mounted && path != null) setState(() => _receiptPath = path);
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(_receiptPath == null ? 'Capture receipt' : 'Receipt attached'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving…' : 'Save entry'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Categories indicate possible treatment only. They do not determine legal deductibility.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final id = _uuid.v4();
    final cents = (double.parse(_amount.text) * 100).round();
    final businessUse = _kind == EntryKind.income ? 100 : int.parse(_businessUse.text);
    final entry = LedgerEntry(
      id: id,
      kind: _kind,
      occurredAt: DateTime.now().toUtc(),
      description: _description.text.trim(),
      amountCents: cents,
      gstCents: _gstIncluded ? AustralianRideshareTaxEngine.gstIncludedInCents(cents) : 0,
      businessUseBasisPoints: businessUse * 100,
      source: EntrySource.manual,
      sourceReference: id,
      category: _kind == EntryKind.expense ? _category : null,
      evidenceStatus: _receiptPath == null ? EvidenceStatus.missing : EvidenceStatus.attached,
      receiptPath: _receiptPath,
    );
    await ref.read(ledgerControllerProvider.notifier).save(entry);
    if (mounted) Navigator.pop(context);
  }
}

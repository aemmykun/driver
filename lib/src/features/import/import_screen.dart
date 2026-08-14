import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ledger_controller.dart';
import '../../domain/ledger_models.dart';
import '../../services/csv_import_service.dart';
import '../../services/provider_connectors.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});
  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  var _source = EntrySource.uberCsv;
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    const connectors = <EarningsConnector>[
      UberEarningsConnector(),
      DidiEarningsConnector(),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Import earnings statements', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Imports are deduplicated using provider references or a canonical row hash.'),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              DropdownButtonFormField<EntrySource>(
                initialValue: _source,
                decoration: const InputDecoration(labelText: 'Statement provider'),
                items: const [
                  DropdownMenuItem(value: EntrySource.uberCsv, child: Text('Uber CSV')), 
                  DropdownMenuItem(value: EntrySource.didiCsv, child: Text('DiDi CSV')),
                ],
                onChanged: (value) => setState(() => _source = value ?? _source),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _busy ? null : _pickAndImport,
                icon: const Icon(Icons.file_open_outlined),
                label: Text(_busy ? 'Importing…' : 'Choose CSV statement'),
              ),
              const SizedBox(height: 12),
              const Text('Required columns: date and amount. Optional: description and trip/payment/reference ID.'),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        Text('Direct connections', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final connector in connectors)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.link_off),
                title: Text(connector.providerName),
                subtitle: Text(connector.status.message),
                trailing: Chip(label: Text(connector.status.availability.name)),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _pickAndImport() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      withData: true,
    );
    if (result == null) return;
    setState(() => _busy = true);
    try {
      final file = result.files.single;
      final bytes = file.bytes ?? await File(file.path!).readAsBytes();
      final raw = utf8.decode(bytes, allowMalformed: false);
      final entries = const CsvImportService().parse(raw, source: _source);
      await ref.read(ledgerControllerProvider.notifier).saveAll(entries);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Processed ${entries.length} rows. Existing source references were ignored.')),
        );
      }
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import blocked: $error')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

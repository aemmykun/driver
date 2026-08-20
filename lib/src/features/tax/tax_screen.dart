import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ledger_controller.dart';
import '../../domain/ledger_models.dart';
import '../../domain/tax_engine.dart';
import '../../services/evidence_export_service.dart';
import '../../ui/formatters.dart';

class TaxScreen extends ConsumerStatefulWidget {
  const TaxScreen({super.key});
  @override
  ConsumerState<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends ConsumerState<TaxScreen> {
  var _declared = false;
  var _exporting = false;

  @override
  Widget build(BuildContext context) {
    final ledger = ref.watch(ledgerControllerProvider);
    final profile = ref.watch(profileProvider);
    if (ledger.isLoading || profile.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (ledger.hasError || profile.hasError) {
      return Center(child: Text('${ledger.error ?? profile.error}'));
    }
    final entries = ledger.value!;
    final driverProfile = profile.value!;
    final period = _currentQuarter(DateTime.now().toUtc());
    final draft = const AustralianRideshareTaxEngine().calculate(
      entries: entries,
      periodStart: period.$1,
      periodEnd: period.$2,
    );
    final readiness = const LodgementGate().evaluate(
      profile: driverProfile,
      draft: draft,
      userDeclared: _declared,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('GST / BAS draft', style: Theme.of(context).textTheme.headlineSmall),
        Text('${shortDate(draft.periodStart)} – ${shortDate(draft.periodEnd.subtract(const Duration(days: 1)))}'),
        const SizedBox(height: 6),
        const Text('Calculated from recorded GST-inclusive amounts and confirmed business-use percentages.'),
        const SizedBox(height: 20),
        _BasRow(code: 'G1', label: 'Total sales', value: aud(draft.g1TotalSalesCents)),
        _BasRow(code: '1A', label: 'GST on sales', value: aud(draft.oneAGstOnSalesCents)),
        _BasRow(code: '1B', label: 'GST credits', value: aud(draft.oneBGstCreditsCents)),
        _BasRow(code: 'NET', label: 'Indicative GST payable', value: aud(draft.netGstPayableCents)),
        const SizedBox(height: 20),
        Text('Possible deduction records', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final item in potentialDeductions)
          Card(
            child: ListTile(
              leading: const Icon(Icons.fact_check_outlined),
              title: Text(item.title),
              subtitle: Text(item.evidence),
            ),
          ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Lodgement readiness', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final blocker in readiness.blockers)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.block, color: Colors.orange),
                  title: Text(_blockerText(blocker)),
                ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _declared,
                onChanged: (value) => setState(() => _declared = value ?? false),
                title: const Text('I reviewed the entries and confirm the draft reflects my records.'),
                subtitle: const Text('This confirmation and the exported payload hash are retained as evidence.'),
              ),
              FilledButton.icon(
                onPressed: !_declared || _exporting ? null : () => _export(draft, driverProfile, entries),
                icon: const Icon(Icons.inventory_2_outlined),
                label: Text(_exporting ? 'Preparing…' : 'Create evidence pack'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: readiness.canTransmit ? () {} : null,
                icon: const Icon(Icons.send_outlined),
                label: const Text('Transmit to ATO'),
              ),
              const Text('Transmission remains fail-closed until SBR conformance and production credentials are configured.'),
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> _export(BasDraft draft, DriverProfile profile, List<LedgerEntry> entries) async {
    setState(() => _exporting = true);
    try {
      final result = await const EvidenceExportService().export(
        draft: draft,
        profile: profile,
        entries: entries,
        database: ref.read(databaseProvider),
      );
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Evidence pack created'),
            content: SelectableText('File: ${result.path}\n\nSHA-256: ${result.sha256Hash}'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  (DateTime, DateTime) _currentQuarter(DateTime now) {
    final startMonth = ((now.month - 1) ~/ 3) * 3 + 1;
    final start = DateTime.utc(now.year, startMonth);
    final end = startMonth == 10 ? DateTime.utc(now.year + 1) : DateTime.utc(now.year, startMonth + 3);
    return (start, end);
  }

  String _blockerText(LodgementBlockCode code) => switch (code) {
        LodgementBlockCode.invalidAbn => 'Enter an 11-digit ABN confirmation.',
        LodgementBlockCode.gstRegistrationUnconfirmed => 'Confirm GST registration.',
        LodgementBlockCode.evidenceMissing => 'Attach or verify missing expense evidence.',
        LodgementBlockCode.userDeclarationMissing => 'Review and accept the user declaration.',
        LodgementBlockCode.sbrAccreditationMissing => 'SBR/DSP accreditation and credentials are not configured.',
      };
}

class _BasRow extends StatelessWidget {
  const _BasRow({required this.code, required this.label, required this.value});
  final String code;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(code)),
          title: Text(label),
          trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      );
}

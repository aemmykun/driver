import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/ledger_controller.dart';
import '../../domain/ledger_models.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('$error')),
      data: (value) => _ProfileForm(initial: value),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.initial});
  final DriverProfile initial;
  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  late final TextEditingController _name;
  late final TextEditingController _abn;
  late bool _gstRegistered;
  late String _basis;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.displayName);
    _abn = TextEditingController(text: widget.initial.abn);
    _gstRegistered = widget.initial.gstRegistered;
    _basis = widget.initial.accountingBasis;
  }

  @override
  void dispose() {
    _name.dispose();
    _abn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Driver tax profile', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('The app records your confirmations; it does not verify registration with the ATO.'),
        const SizedBox(height: 20),
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Display name')),
        const SizedBox(height: 12),
        TextField(
          controller: _abn,
          keyboardType: TextInputType.number,
          maxLength: 11,
          decoration: const InputDecoration(labelText: 'ABN (11 digits)'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('I confirm I am GST registered'),
          subtitle: const Text('Ride-sourcing drivers generally need GST registration from commencement.'),
          value: _gstRegistered,
          onChanged: (value) => setState(() => _gstRegistered = value),
        ),
        DropdownButtonFormField<String>(
          value: _basis,
          decoration: const InputDecoration(labelText: 'GST accounting basis'),
          items: const [
            DropdownMenuItem(value: 'cash', child: Text('Cash basis')),
            DropdownMenuItem(value: 'non_cash', child: Text('Non-cash basis')),
          ],
          onChanged: (value) => setState(() => _basis = value ?? _basis),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () async {
            final profile = DriverProfile(
              abn: _abn.text.replaceAll(' ', ''),
              gstRegistered: _gstRegistered,
              accountingBasis: _basis,
              displayName: _name.text.trim(),
            );
            await ref.read(profileProvider.notifier).save(profile);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved locally.')));
            }
          },
          child: const Text('Save profile'),
        ),
        const SizedBox(height: 24),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Privacy boundary: this MVP stores ledger data and receipt files on this device. Device backup and OS security settings remain the user’s responsibility.',
            ),
          ),
        ),
      ],
    );
  }
}

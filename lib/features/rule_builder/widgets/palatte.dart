import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/rule_builder_controller.dart';
import '../models/rule_node.dart';

class RulePalette extends ConsumerWidget {
  const RulePalette({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(ruleBuilderProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Blocks', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(
              'Click a block to add it to the canvas (Windows-stable).',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black.withOpacity(0.60),
              ),
            ),
            const SizedBox(height: 14),

            _PaletteButton(
              icon: Icons.tune,
              label: 'Condition',
              onPressed: () => controller.addNode(RuleNode.condition()),
            ),
            const SizedBox(height: 10),
            _PaletteButton(
              icon: Icons.account_tree,
              label: 'AND Group',
              onPressed: () => controller.addNode(RuleNode.andGroup()),
            ),
            const SizedBox(height: 10),
            _PaletteButton(
              icon: Icons.call_split,
              label: 'OR Group',
              onPressed: () => controller.addNode(RuleNode.orGroup()),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteButton extends StatelessWidget {
  const _PaletteButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 46,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: theme.colorScheme.primary),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: Colors.black.withOpacity(0.10)),
          backgroundColor: Colors.black.withOpacity(0.02),
        ),
      ),
    );
  }
}

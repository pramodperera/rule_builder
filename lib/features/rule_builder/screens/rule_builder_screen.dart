import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rule_builder/features/rule_builder/widgets/canvas.dart';
import 'package:rule_builder/features/rule_builder/widgets/palatte.dart';

import '../controllers/rule_builder_controller.dart';

class RuleBuilderScreen extends ConsumerWidget {
  const RuleBuilderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final controller = ref.read(ruleBuilderProvider.notifier);
    final nodes = ref.watch(ruleBuilderProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => context.goNamed('campaignList'),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rule Builder',
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Drag blocks, drop into canvas, then we generate vcondition.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black.withOpacity(0.60),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  OutlinedButton.icon(
                    onPressed: nodes.isEmpty
                        ? null
                        : () {
                            controller.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Canvas cleared')),
                            );
                          },
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: const Text('Clear'),
                  ),
                  const SizedBox(width: 10),

                  FilledButton.icon(
                    onPressed: nodes.isEmpty
                        ? null
                        : () {
                            final exported = controller.exportRules();
                            // For now we just show a summary count.
                            // Next step we’ll show a JSON preview panel.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Saved ${exported.length} blocks (next: JSON preview)',
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.save),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ),

            // Body (responsive layout)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;

                  if (!isWide) {
                    // Mobile / narrow: palette on top, canvas below
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: const [
                          SizedBox(height: 260, child: RulePalette()),
                          SizedBox(height: 12),
                          Expanded(child: RuleCanvas()),
                        ],
                      ),
                    );
                  }

                  // Desktop / wide: palette left, canvas right
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: const [
                        SizedBox(width: 360, child: RulePalette()),
                        SizedBox(width: 12),
                        Expanded(child: RuleCanvas()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

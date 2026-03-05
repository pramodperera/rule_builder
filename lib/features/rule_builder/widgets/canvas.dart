import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/rule_builder_controller.dart';
import '../models/rule_node.dart';
import 'edit_rule_sheet.dart';

class RuleCanvas extends ConsumerWidget {
  const RuleCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final nodes = ref.watch(ruleBuilderProvider);
    final controller = ref.read(ruleBuilderProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: nodes.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.layers_outlined,
                        size: 46,
                        color: Colors.black.withOpacity(0.35),
                      ),
                      const SizedBox(height: 10),
                      Text('Canvas', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(
                        'Add blocks from the left, then click to edit.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black.withOpacity(0.60),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                itemCount: nodes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final node = nodes[index];
                  return _RuleCard(
                    node: node,
                    onDelete: () => controller.removeNode(node.id),
                    onTap: () {
                      if (node.type == RuleNodeType.condition) {
                        showEditRuleSheet(context: context, node: node);
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.node,
    required this.onDelete,
    required this.onTap,
  });

  final RuleNode node;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = switch (node.type) {
      RuleNodeType.condition => 'Condition',
      RuleNodeType.andGroup => 'AND Group',
      RuleNodeType.orGroup => 'OR Group',
    };

    final subtitle = node.type == RuleNodeType.condition
        ? '${node.field ?? "(field)"}  •  ${node.operator?.name ?? "(op)"}  •  ${node.value ?? "(value)"}'
        : 'Container block (nesting next step)';

    final icon = switch (node.type) {
      RuleNodeType.condition => Icons.tune,
      RuleNodeType.andGroup => Icons.account_tree,
      RuleNodeType.orGroup => Icons.call_split,
    };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withOpacity(0.60),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

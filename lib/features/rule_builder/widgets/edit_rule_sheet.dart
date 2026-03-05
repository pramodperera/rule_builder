import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/rule_builder_controller.dart';
import '../models/rule_node.dart';

Future<void> showEditRuleSheet({
  required BuildContext context,
  required RuleNode node,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _EditRuleSheet(node: node),
  );
}

class _EditRuleSheet extends ConsumerStatefulWidget {
  const _EditRuleSheet({required this.node});

  final RuleNode node;

  @override
  ConsumerState<_EditRuleSheet> createState() => _EditRuleSheetState();
}

class _EditRuleSheetState extends ConsumerState<_EditRuleSheet> {
  late String? _field;
  late RuleOperator? _operator;
  final TextEditingController _valueCtrl = TextEditingController();

  final _fields = const [
    'iparental_status',
    'igrand_parental_status',
    'idpd',
    'ic121_status',
    'pr_account_flag',
  ];

  @override
  void initState() {
    super.initState();
    _field = widget.node.field;
    _operator = widget.node.operator;
    _valueCtrl.text = widget.node.value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(ruleBuilderProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Edit Condition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Field
            DropdownButtonFormField<String>(
              value: _field,
              hint: const Text('Select field'),
              items: _fields
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (v) => setState(() => _field = v),
            ),

            const SizedBox(height: 12),

            // Operator
            DropdownButtonFormField<RuleOperator>(
              value: _operator,
              hint: const Text('Operator'),
              items: RuleOperator.values
                  .map(
                    (op) => DropdownMenuItem(value: op, child: Text(op.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _operator = v),
            ),

            const SizedBox(height: 12),

            // Value
            TextField(
              controller: _valueCtrl,
              decoration: const InputDecoration(labelText: 'Value'),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_field != null) {
                        controller.updateField(widget.node.id, _field!);
                      }
                      if (_operator != null) {
                        controller.updateOperator(widget.node.id, _operator!);
                      }
                      controller.updateValue(widget.node.id, _valueCtrl.text);

                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rule_node.dart';

final ruleBuilderProvider =
    NotifierProvider<RuleBuilderController, List<RuleNode>>(
      RuleBuilderController.new,
    );

class RuleBuilderController extends Notifier<List<RuleNode>> {
  @override
  List<RuleNode> build() => [];

  void addNode(RuleNode node) {
    state = [...state, node];
  }

  void removeNode(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void clear() {
    state = [];
  }

  void updateField(String id, String field) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(field: field) else n,
    ];
  }

  void updateOperator(String id, RuleOperator op) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(operator: op) else n,
    ];
  }

  void updateValue(String id, dynamic value) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(value: value) else n,
    ];
  }

  /// ✅ This is what RuleBuilderScreen is calling
  List<Map<String, dynamic>> exportRules() {
    return state.map((n) => n.toMap()).toList();
  }
}

import 'package:uuid/uuid.dart';

const _uuid = Uuid();

enum RuleNodeType { condition, andGroup, orGroup }

enum RuleOperator { equals, notEquals, greaterThan, lessThan, inList, isNull }

class RuleNode {
  final String id;
  final RuleNodeType type;

  // For condition nodes
  final String? field;
  final RuleOperator? operator;
  final dynamic value;

  // For group nodes (later nesting)
  final List<RuleNode> children;

  RuleNode({
    String? id,
    required this.type,
    this.field,
    this.operator,
    this.value,
    List<RuleNode>? children,
  }) : id = id ?? _uuid.v4(),
       children = children ?? const [];

  factory RuleNode.condition() => RuleNode(type: RuleNodeType.condition);
  factory RuleNode.andGroup() => RuleNode(type: RuleNodeType.andGroup);
  factory RuleNode.orGroup() => RuleNode(type: RuleNodeType.orGroup);

  RuleNode copyWith({
    String? field,
    RuleOperator? operator,
    dynamic value,
    List<RuleNode>? children,
  }) {
    return RuleNode(
      id: id,
      type: type,
      field: field ?? this.field,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "type": type.name,
    "field": field,
    "operator": operator?.name,
    "value": value,
    "children": children.map((c) => c.toMap()).toList(),
  };
}

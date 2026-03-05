import 'package:uuid/uuid.dart';

class IdGen {
  IdGen._();

  static const Uuid _uuid = Uuid();

  static String id() => _uuid.v4();
}

import 'package:uuid/uuid.dart';

class Group {
  Group({
    String? groupId,
    required this.groupName,
    required this.userId,
  }) : groupId = groupId ?? const Uuid().v4();

  final String groupId;
  final String groupName;
  List<String> userId;
}

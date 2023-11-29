import 'package:uuid/uuid.dart';

class Group {
  Group({
    String? groupId,
    required this.groupName,
    required this.users,
  }) : groupId = groupId ?? const Uuid().v4();

  final String groupId;
  final String groupName;
  List<Map<String, String>> users; //[{'userId' = '', 'nickname'= ''}]
}

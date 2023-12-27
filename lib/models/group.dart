import 'package:uuid/uuid.dart';

class Group {
  Group({
    String? groupId,
    required this.groupName,
    required this.users,
    DateTime? timestamp, //For sorting based on activity
  })  : groupId = groupId ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  final String groupId;
  final String groupName;
  List<Map<String, String>> users; //[{'id' = '', 'nickname'= ''}]
  final DateTime timestamp;

  String getUserNicknameById(String userId) {
    final user = users.firstWhere((user) => user['id'] == userId,
        orElse: () => {'nickname': 'Unknown'});
    return user['nickname'] ?? 'Unknown';
  }
}

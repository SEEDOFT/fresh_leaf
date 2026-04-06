import 'package:fresh_leaf/shared/helpers/helper.dart';

class AiChatSession {
  const AiChatSession({
    required this.sessionId,
    required this.userId,
    required this.channelName,
  });

  factory AiChatSession.fromMap(Map<String, dynamic> map) {
    final sessionId = formatToString(map['session_id']);
    final userId = formatToString(map['user_id']);
    final channelName = formatToString(map['channel_name']);
    return AiChatSession(
      sessionId: sessionId,
      userId: userId,
      channelName: channelName,
    );
  }

  final String sessionId;
  final String userId;
  final String channelName;
}

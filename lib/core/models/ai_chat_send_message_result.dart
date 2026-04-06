import 'package:fresh_leaf/shared/helpers/helper.dart';

class AiChatSendMessageResult {
  const AiChatSendMessageResult({
    required this.sessionId,
    required this.userMessageId,
    required this.assistantMessageId,
    required this.status,
  });

  factory AiChatSendMessageResult.fromMap(Map<String, dynamic> map) {
    return AiChatSendMessageResult(
      sessionId: formatToString(map['session_id']),
      userMessageId: formatToString(map['user_message_id']),
      assistantMessageId: formatToString(map['ai_message_id']),
      status: formatToString(map['status']),
    );
  }

  final String sessionId;
  final String userMessageId;
  final String assistantMessageId;
  final String status;
}

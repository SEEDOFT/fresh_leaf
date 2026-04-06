import 'package:fresh_leaf/shared/helpers/helper.dart';

class AiChatMessage {
  const AiChatMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
    this.sessionId,
    this.messageId,
    this.sequence,
    this.status = 'done',
  });

  factory AiChatMessage.fromMap(Map<String, dynamic> map) {
    return AiChatMessage(
      text: formatToString(map['text']),
      isUser: toBool(map['isUser']),
      isStreaming: toBool(map['isStreaming']),
      sessionId: formatToString(map['sessionId']),
      messageId: formatToString(map['messageId']),
      sequence: map['sequence'] == null ? null : toInt(map['sequence']),
      status: formatToString(map['status'], defaultValue: 'done'),
    );
  }

  final String text;
  final bool isUser;
  final bool isStreaming;
  final String? sessionId;
  final String? messageId;
  final int? sequence;
  final String status;

  Map<String, dynamic> toMap() => {
    'text': text,
    'isUser': isUser,
    'isStreaming': isStreaming,
    'sessionId': sessionId,
    'messageId': messageId,
    'sequence': sequence,
    'status': status,
  };

  AiChatMessage copyWith({
    String? text,
    bool? isUser,
    bool? isStreaming,
    String? sessionId,
    String? messageId,
    int? sequence,
    String? status,
  }) {
    return AiChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      isStreaming: isStreaming ?? this.isStreaming,
      sessionId: sessionId ?? this.sessionId,
      messageId: messageId ?? this.messageId,
      sequence: sequence ?? this.sequence,
      status: status ?? this.status,
    );
  }
}

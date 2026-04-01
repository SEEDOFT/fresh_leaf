import 'package:fresh_leaf/shared/helpers/helper.dart';

class AiChatMessage {
  const AiChatMessage({
    required this.text,
    required this.isUser,
    this.isStreaming = false,
  });

  factory AiChatMessage.fromMap(Map<String, dynamic> map) {
    return AiChatMessage(
      text: formatToString(map['text']),
      isUser: toBool(map['isUser']),
      isStreaming: toBool(map['isStreaming']),
    );
  }

  final String text;
  final bool isUser;
  final bool isStreaming;

  AiChatMessage copyWith({String? text, bool? isUser, bool? isStreaming}) {
    return AiChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  Map<String, dynamic> toMap() => {
    'text': text,
    'isUser': isUser,
    'isStreaming': isStreaming,
  };
}

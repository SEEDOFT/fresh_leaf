import 'package:fresh_leaf/shared/helpers/helper.dart';

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.type,
    required this.status,
    this.otherParticipant,
    this.latestMessage,
    this.unreadCount = 0,
    this.deepLink,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatConversation.fromMap(Map<String, dynamic> map) {
    final source = _toStringKeyMap(map['data']) ?? map;
    final otherParticipantMap = _toStringKeyMap(source['other_participant']);
    final latestMessageMap = _toStringKeyMap(source['latest_message']);

    return ChatConversation(
      id: toInt(source['id']),
      type: _parseType(source),
      status: _parseStatus(source),
      otherParticipant: otherParticipantMap == null
          ? null
          : ChatParticipant.fromMap(otherParticipantMap),
      latestMessage: latestMessageMap == null
          ? null
          : ChatLatestMessage.fromMap(latestMessageMap),
      unreadCount: toInt(source['unread_count']),
      deepLink: formatToString(source['deep_link']),
      createdAt: toNullableDateTime(source['created_at']),
      updatedAt: toNullableDateTime(source['updated_at']),
    );
  }

  final int id;
  final String type;
  final String status;
  final ChatParticipant? otherParticipant;
  final ChatLatestMessage? latestMessage;
  final int unreadCount;
  final String? deepLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isOpen => status == 'open';

  bool get isSupport => type == 'support';

  bool get isDirect => type == 'direct';

  String get displayTitle {
    final participant = otherParticipant;
    if (participant == null) {
      return isSupport ? 'Customer Support' : 'Chat';
    }
    if (participant.businessName.isNotEmpty) {
      return participant.businessName;
    }
    if (participant.fullName.isNotEmpty) {
      return participant.fullName;
    }
    return isSupport ? 'Customer Support' : 'Chat';
  }

  String get previewText {
    final message = latestMessage;
    if (message == null) return '';
    if (message.content.isNotEmpty) return message.content;
    if (message.hasAttachment) return 'Attachment';
    return '';
  }
}

class ChatParticipant {
  const ChatParticipant({
    required this.id,
    required this.type,
    required this.fullName,
    this.firstName = '',
    this.lastName = '',
    this.image,
    this.businessName = '',
    this.storeFrontImage,
    this.isVerified = false,
  });

  factory ChatParticipant.fromMap(Map<String, dynamic> map) {
    return ChatParticipant(
      id: toInt(map['id']),
      type: formatToString(map['type']),
      fullName: formatToString(map['full_name']),
      firstName: formatToString(map['first_name']),
      lastName: formatToString(map['last_name']),
      image: _nonEmptyString(map['image']),
      businessName: formatToString(map['business_name']),
      storeFrontImage: _nonEmptyString(map['store_front_image']),
      isVerified: toBool(map['is_verified']),
    );
  }

  final int id;
  final String type;
  final String fullName;
  final String firstName;
  final String lastName;
  final String? image;
  final String businessName;
  final String? storeFrontImage;
  final bool isVerified;

  String? get displayImage => storeFrontImage ?? image;
}

class ChatLatestMessage {
  const ChatLatestMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.hasAttachment,
    this.createdAt,
  });

  factory ChatLatestMessage.fromMap(Map<String, dynamic> map) {
    return ChatLatestMessage(
      id: toInt(map['id']),
      senderId: toInt(map['sender_id']),
      content: formatToString(map['content']),
      hasAttachment: toBool(map['has_attachment']),
      createdAt: toNullableDateTime(map['created_at']),
    );
  }

  final int id;
  final int senderId;
  final String content;
  final bool hasAttachment;
  final DateTime? createdAt;
}

Map<String, dynamic>? _toStringKeyMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map<String, dynamic>(
      (dynamic key, dynamic item) =>
          MapEntry<String, dynamic>(key.toString(), item),
    );
  }
  return null;
}

String _parseType(Map<String, dynamic> source) {
  final rawType = source['type'];
  final typeMap = _toStringKeyMap(rawType);
  if (typeMap != null) {
    return formatToString(typeMap['name'] ?? typeMap['name_en']);
  }
  return formatToString(rawType);
}

String _parseStatus(Map<String, dynamic> source) {
  final rawStatus = source['status'];
  final statusMap = _toStringKeyMap(rawStatus);
  if (statusMap != null) {
    return formatToString(statusMap['name'] ?? statusMap['name_en']);
  }
  return formatToString(rawStatus);
}

String? _nonEmptyString(dynamic value) {
  final text = formatToString(value);
  return text.isEmpty ? null : text;
}

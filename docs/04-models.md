# Models

## Overview

FreshLeaf uses data models for API responses, local storage, and business logic. Models follow a consistent pattern with `fromMap()` factory constructors.

## Model Pattern

```dart
class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final String? image;
  final bool setPin;
  
  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    this.image,
    this.setPin = false,
  });
  
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? 0,
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'],
      email: map['email'],
      image: map['image'],
      setPin: map['set_pin'] ?? false,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'image': image,
      'set_pin': setPin,
    };
  }
}
```

## User & Authentication Models

### UserProfile

```dart
// lib/core/models/user_profile.dart
class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final String? image;
  final bool setPin;
  final String? locale;
  final DateTime? dateOfBirth;
  final String? gender;
  
  String get fullName => '$firstName $lastName';
  
  factory UserProfile.fromMap(Map<String, dynamic> map) => ...
  Map<String, dynamic> toMap() => ...
}
```

### UserAddress

```dart
// lib/core/models/user_address.dart
class UserAddress {
  final int id;
  final String name;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  
  factory UserAddress.fromMap(Map<String, dynamic> map) => ...
  Map<String, dynamic> toMap() => ...
}
```

## Product Models

### HomeProduct

```dart
// lib/core/models/home_product.dart
class HomeProduct {
  final int id;
  final String name;
  final String? imageUrl;
  final double priceKhr;
  final double priceUsd;
  final String? vendorName;
  final double? discountPercentage;
  
  factory HomeProduct.fromMap(Map<String, dynamic> map) => ...
}
```

### OrganicProduct

```dart
// lib/core/models/organic_product.dart
class OrganicProduct {
  final int id;
  final String nameEn;
  final String nameKm;
  final String? description;
  final String? imageUrl;
  final List<String> images;
  final double priceKhr;
  final double priceUsd;
  final bool isOrganic;
  final String? farmLocation;
  final String? farmingMethod;
  final DateTime? harvestDate;
  final int stockQuantity;
  final String unit;
  final int vendorId;
  final String vendorName;
  final int categoryId;
  
  factory OrganicProduct.fromMap(Map<String, dynamic> map) => ...
}
```

### HomeCategory

```dart
// lib/core/models/home_category.dart
class HomeCategory {
  final int id;
  final String name;
  final String? imageUrl;
  final String slug;
  
  factory HomeCategory.fromMap(Map<String, dynamic> map) => ...
}
```

## Order Models

### Order

```dart
// lib/core/models/order.dart
class Order {
  final int id;
  final String orderNumber;
  final int userId;
  final int? addressId;
  final String status;
  final String paymentStatus;
  final double subtotal;
  final double commissionAmount;
  final double total;
  final String? deliveryDate;
  final String? deliverySlot;
  final String? notes;
  final DateTime createdAt;
  final List<OrderItem> items;
  
  factory Order.fromMap(Map<String, dynamic> map) => ...
}
```

### OrderItem

```dart
class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double commissionAmount;
  final String? imageUrl;
  
  factory OrderItem.fromMap(Map<String, dynamic> map) => ...
}
```

## Wallet Models

### Wallet

```dart
// lib/core/models/wallet.dart
class Wallet {
  final int id;
  final int userId;
  final String currency; // 'KHR' or 'USD'
  final double balance;
  final bool isActive;
  
  String get formattedBalance {
    if (currency == 'KHR') {
      return '${balance.toStringAsFixed(0)} ៛';
    }
    return '\$${balance.toStringAsFixed(2)}';
  }
  
  factory Wallet.fromMap(Map<String, dynamic> map) => ...
}
```

## Payment Models

### PaymentMethod

```dart
// lib/core/models/payment_method.dart
class PaymentMethod {
  final int id;
  final int userId;
  final int typeId;
  final String typeName; // 'credit_debit', 'ABA', 'ACLEDA', etc.
  final String? cardLast4;
  final String? cardBrand;
  final String? bankName;
  final bool isDefault;
  final String status;
  
  factory PaymentMethod.fromMap(Map<String, dynamic> map) => ...
}
```

### PaymentSession

```dart
// lib/core/models/payment_session.dart
class PaymentSession {
  final String sessionId;
  final int? orderId;
  final double amount;
  final String currency;
  final String status;
  final String? paymentMethod;
  
  factory PaymentSession.fromMap(Map<String, dynamic> map) => ...
}
```

## AI Chat Models

### AiChatMessage

```dart
// lib/core/models/ai_chat_message.dart
class AiChatMessage {
  final String messageId;
  final String sessionId;
  final String role; // 'user' or 'assistant'
  final String content;
  final String status; // 'pending', 'streaming', 'completed', 'failed'
  final DateTime createdAt;
  
  final bool isUser => role == 'user';
  final bool isStreaming => status == 'streaming';
  final bool isCompleted => status == 'completed';
  final bool isFailed => status == 'failed';
  
  factory AiChatMessage.fromMap(Map<String, dynamic> map) => ...
}
```

### AiChatSession

```dart
// lib/core/models/ai_chat_session.dart
class AiChatSession {
  final String sessionId;
  final int userId;
  final String? title;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  
  factory AiChatSession.fromMap(Map<String, dynamic> map) => ...
}
```

### AiChatRealtimeEvent

```dart
// lib/core/models/ai_chat_realtime_event.dart
abstract class AiChatRealtimeEvent {
  final String messageId;
}

class AiMessageStarted extends AiChatRealtimeEvent {
  factory AiMessageStarted.fromMap(Map<String, dynamic> map) => ...
}

class AiMessageChunk extends AiChatRealtimeEvent {
  final String textChunk;
  
  factory AiMessageChunk.fromMap(Map<String, dynamic> map) => ...
}

class AiMessageCompleted extends AiChatRealtimeEvent {
  final String fullText;
  
  factory AiMessageCompleted.fromMap(Map<String, dynamic> map) => ...
}

class AiMessageFailed extends AiChatRealtimeEvent {
  final String error;
  
  factory AiMessageFailed.fromMap(Map<String, dynamic> map) => ...
}
```

## Support Chat Models

### SupportTicket

```dart
// lib/core/models/support_ticket.dart
class SupportTicket {
  final int id;
  final int userId;
  final String status; // 'open', 'resolved'
  final SupportMessage? latestMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  factory SupportTicket.fromMap(Map<String, dynamic> map) => ...
}
```

### SupportMessage

```dart
// lib/core/models/support_message.dart
class SupportMessage {
  final int id;
  final int supportTicketId;
  final String senderType; // 'user' or 'admin'
  final int senderId;
  final String message;
  final String? filePath;
  final bool isRead;
  final DateTime createdAt;
  
  final bool isFromUser => senderType == 'user';
  final bool isFromAdmin => senderType == 'admin';
  
  factory SupportMessage.fromMap(Map<String, dynamic> map) => ...
}
```

## API Response Model

### ApiResponse

```dart
// lib/core/models/api_response.dart
class ApiResponse {
  final bool isSuccess;
  final String message;
  final dynamic data;
  
  // Parse helpers
  static ApiResponse parseMap(dynamic json) => ...
  static List<T> parseList<T>(dynamic json, T Function(Map) fromMap) => ...
  static String parseString(dynamic json) => ...
  static bool parseBool(dynamic json) => ...
}
```

---

## Related Files

- `lib/core/constants/api_endpoints.dart` - API endpoints
- `lib/core/services/api_client.dart` - HTTP client
- `lib/core/services/storage_service.dart` - Local storage
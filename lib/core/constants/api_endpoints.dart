final class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/user/auth/login';
  static const String register = '/user/auth/register';
  static const String logout = '/user/auth/logout';
  static const String updatePassword = '/user/auth/password/update';
  static const String verifyPassword = '/user/auth/password/verify';
  static const String setPin = '/user/auth/pin/set';
  static const String updatePin = '/user/auth/pin/update';
  static const String verifyPin = '/user/auth/pin/verify';
  static const String resetPin = '/user/auth/pin/reset';

  // User
  static const String userProfile = '/user/profile';
  static const String userUpdateProfile = '/user/profile';
  static const String userAddresses = '/user/addresses';
  static const String userAddress = '/user/addresses/{id}';
  // Payment Methods
  static const String userPaymentMethods = '/user/payment-methods';
  static const String userPaymentMethod = '/user/payment-methods/{id}';

  // Products
  static const String products = '/user/products';
  static const String productById = '/user/products/{id}';
  static const String productCategories = '/user/products/categories';
  static const String productSearch = '/user/products/search';

  // Cart
  static const String cart = '/user/cart';
  static const String cartItem = '/user/cart/items/{itemId}';
  static const String cartApplyCoupon = '/user/cart/apply-coupon';
  static const String cartRemoveCoupon = '/user/cart/remove-coupon';

  // Orders
  static const String orders = '/user/orders';
  static const String orderById = '/user/orders/{id}';
  static const String orderCancel = '/user/orders/{id}/cancel';

  // AI Assistant
  static const String aiSuggestions = '/ai/suggestions';
  static const String aiChat = '/ai/chat';
  static const String aiChatSessions = '/ai/chat/sessions';
  static const String aiChatMessages = '/ai/chat/messages';
  static const String aiChatHistory = '/ai/chat/history';

  // Favorites/Wishlist
  static const String wishlist = '/user/wishlist';
  static const String wishlistItem = '/user/wishlist/items/{itemId}';
}

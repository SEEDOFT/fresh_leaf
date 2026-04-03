final class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String updatePassword = '/auth/password/update';
  static const String verifyPassword = '/auth/password/verify';
  static const String setPin = '/auth/pin/set';
  static const String updatePin = '/auth/pin/update';
  static const String verifyPin = '/auth/pin/verify';
  static const String resetPin = '/auth/pin/reset';

  // User
  static const String userProfile = '/users/profile';
  static const String userUpdateProfile = '/users/profile';
  static const String userAddresses = '/users/addresses';
  static const String userAddress = '/users/addresses/{id}';
  // Payment Methods
  static const String userPaymentMethods = '/users/payment-methods';
  static const String userPaymentMethod = '/users/payment-methods/{id}';

  // Products
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String productCategories = '/products/categories';
  static const String productSearch = '/products/search';

  // Cart
  static const String cart = '/cart';
  static const String cartItem = '/cart/items/{itemId}';
  static const String cartApplyCoupon = '/cart/apply-coupon';
  static const String cartRemoveCoupon = '/cart/remove-coupon';

  // Orders
  static const String orders = '/orders';
  static const String orderById = '/orders/{id}';
  static const String orderCancel = '/orders/{id}/cancel';

  // AI Assistant
  static const String aiSuggestions = '/ai/suggestions';
  static const String aiChat = '/ai/chat';
  static const String aiChatHistory = '/ai/chat/history';

  // Favorites/Wishlist
  static const String wishlist = '/wishlist';
  static const String wishlistItem = '/wishlist/items/{itemId}';
}

class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // User
  static const String userProfile = '/users/profile';
  static const String userUpdateProfile = '/users/update-profile';
  static const String userAddresses = '/users/addresses';
  static const String userAddress = '/users/addresses/{id}';

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

  // Payments
  static const String paymentMethods = '/payment/methods';
  static const String paymentProcess = '/payment/process';
  static const String paymentWebhook = '/payment/webhook';

  // Favorites/Wishlist
  static const String wishlist = '/wishlist';
  static const String wishlistItem = '/wishlist/items/{itemId}';
}

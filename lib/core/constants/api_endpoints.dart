final class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/user/auth/login';
  static const String register = '/user/auth/register';
  static const String logout = '/user/auth/logout';
  static const String updatePassword = '/user/auth/password/update';
  static const String verifyPassword = '/user/auth/password/verify';
  static const String setPin = '/user/pin/set';
  static const String updatePin = '/user/pin/update';
  static const String verifyPin = '/user/pin/verify';
  static const String resetPin = '/user/pin/reset';

  // User
  static const String userProfile = '/user/profile';
  static const String userUpdateProfile = '/user/profile';
  static const String userAddresses = '/user/addresses';
  static const String userAddress = '/user/addresses/{id}';
  static const String userWallets = '/user/wallets';
  // Categories
  static const String categories = '/categories';
  static const String categoryBySlug = '/categories/{slug}';

  // Payment Methods
  static const String userPaymentMethods = '/user/payment-methods';
  static const String userPaymentMethod = '/user/payment-methods/{id}';
  static const String userPaymentMethodTypes = '/user/payment-method-types';
  static const String userWalletTopUpSessions = '/user/wallets/top-up/sessions';
  static const String userCheckoutSessions = '/user/checkout/sessions';
  static const String userPaymentSession = '/user/payments/sessions/{id}';
  static const String userDevices = '/user/devices';
  static const String userDeviceByToken = '/user/devices/{token}';

  // Products
  static const String products = '/user/products';
  static const String productById = '/user/products/{id}';
  static const String vendorProducts = '/vendor/products';
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
  static const String wishlistItem = '/user/wishlist/items/{id}';
}

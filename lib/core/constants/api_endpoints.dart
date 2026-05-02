final class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/user/auth/login';
  static const String register = '/user/auth/register';
  static const String logout = '/auth/logout';
  static const String updatePassword = '/auth/password/update';
  static const String verifyPassword = '/auth/password/verify';
  static const String setPin = '/user/pin/set';
  static const String updatePin = '/user/pin/update';
  static const String verifyPin = '/user/pin/verify';
  static const String resetPin = '/user/pin/reset';

  // User
  static const String userProfile = '/profile';
  static const String userUpdateProfile = '/profile';
  static const String userAddresses = '/addresses';
  static const String userAddress = '/addresses/{id}';
  static const String userWallets = '/wallets';
  // Categories
  static const String categories = '/categories';
  static const String categoryBySlug = '/categories/{slug}';

  // Payment Methods
  static const String userPaymentMethods = '/payment-methods';
  static const String userPaymentMethod = '/payment-methods/{id}';
  static const String userPaymentMethodTypes = '/payment-method-types';
  static const String userWalletTopUpSessions = '/wallets/top-up/sessions';
  static const String userCheckoutSessions = '/user/checkout/sessions';
  static const String userPaymentSession = '/user/payments/sessions/{id}';
  static const String userDevices = '/devices';
  static const String userDeviceByToken = '/devices/{token}';

  // Products
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String vendorProducts = '/products';
  static const String productCategories = '/products/categories';
  static const String productSearch = '/products/search';

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

  // Support Chat
  static const String supportTicket = '/user/support/ticket';
  static const String supportUnreadCount = '/user/support/unread-count';
  static const String supportMessages = '/user/support/messages';

  // Favorites/Wishlist
  static const String wishlist = '/user/wishlist';
  static const String wishlistItem = '/user/wishlist/items/{id}';
  static const String addToWishlist = '/user/wishlist/add';
  static const String removeFromWishlist = '/user/wishlist/remove';

  // Home
  static const String homeProducts = '/home/products';
  static const String homeCategories = '/home/categories';

  // Organic Products
  static const String organicProducts = '/organic-products';
  static const String organicProductDetail = '/organic-products/{id}';

  // Search
  static const String search = '/products/search';
  static const String searchSuggestions = '/products/search/suggestions';
}

final class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String updatePassword = '/auth/password/update';
  static const String verifyPassword = '/auth/password/verify';
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
  static const String aiSuggestions = '/user/ai/suggestions';
  static const String aiChat = '/user/ai/chat';
  static const String aiChatSessions = '/user/ai/chat/sessions';
  static const String aiChatMessages = '/user/ai/chat/messages';
  static const String aiChatHistory = '/user/ai/chat/history';

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

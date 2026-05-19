final class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String updatePassword = '/auth/password/update';
  static const String verifyPassword = '/auth/password/verify';
  static const String setPin = '/pin/set';
  static const String updatePin = '/pin/update';
  static const String verifyPin = '/pin/verify';
  static const String resetPin = '/pin/reset';

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
  static const String userCheckoutSessions = '/checkout/sessions';
  static const String userPaymentSession = '/payments/sessions/{id}';
  static const String userDevices = '/devices';

  // Products
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String vendorProducts = '/products';
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
  static const String aiChatSessions = '/ai/chat/sessions';
  static const String aiChatMessages = '/ai/chat/messages';
  static const String aiChatHistory = '/ai/chat/history';
  static const String aiStatus = '/ai/status';

  // Support Chat
  static const String supportTickets = '/support/tickets';
  static const String supportTicket = '/support/ticket';
  static const String supportMessages = '/support/messages';
  static const String supportUnreadCount = '/support/unread-count';

  // Favorites/Wishlist
  static const String wishlist = '/wishlist';
  static const String wishlistToggle = '/wishlist/toggle';

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

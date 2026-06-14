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
  static const String profile = '/profile';
  static const String updateProfile = '/profile';
  static const String addresses = '/addresses';
  static const String address = '/addresses/{id}';
  static const String wallets = '/wallets';
  static const String walletTransactions = '/wallet-transactions';
  // Categories
  static const String categories = '/categories';
  static const String categoryBySlug = '/categories/{slug}';

  // Payment Methods
  static const String paymentMethods = '/payment-methods';
  static const String paymentMethod = '/payment-methods/{id}';
  static const String paymentMethodTypes = '/payment-method-types';
  static const String walletTopUpSessions = '/wallets/top-up/sessions';
  static const String checkoutSessions = '/checkout/sessions';
  static const String paymentSession = '/payments/sessions/{id}';
  static const String devices = '/devices';

  // Products
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String productBySlug = '/products/by-slug/{slug}';
  static const String vendorProducts = '/products';
  static const String productCategories = '/products/categories';
  static const String productSearch = '/products/search';

  // Cart
  static const String cart = '/cart';
  static const String cartById = '/cart/{id}';
  static const String cartCheckout = '/cart/checkout';
  static const String cartApplyCoupon = '/cart/apply-coupon';
  static const String cartRemoveCoupon = '/cart/remove-coupon';

  // Orders
  static const String orders = '/orders';
  static const String orderCounts = '/orders/counts';
  static const String orderById = '/orders/{id}';
  static const String orderCancel = '/orders/{id}/cancel';
  static const String orderConfirmReceipt = '/orders/{id}/confirm-receipt';
  static const String orderInvoiceUrl = '/orders/{id}/invoice/url';

  // AI Assistant
  static const String aiSuggestions = '/ai/suggestions';
  static const String aiChat = '/ai/chat';
  static const String aiChatSessions = '/ai/chat/sessions';
  static const String aiChatMessages = '/ai/chat/messages';
  static const String aiChatHistory = '/ai/chat/history';
  static const String aiStatus = '/ai/status';

  // Chat
  static const String chatConversations = '/conversations';
  static const String chatConversation = '/conversations/{id}';
  static const String chatTyping = '/conversations/typing';
  static const String chatMessages = '/conversations/{id}/messages';
  static const String chatUnreadCount = '/conversations/unread-count';

  // Favorites/Wishlist
  static const String wishlist = '/wishlist';
  static const String wishlistToggle = '/wishlist/toggle';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsMarkRead = '/notifications/{id}/mark-read';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';

  // Organic Products
  static const String organicProducts = '/organic-products';
  static const String organicProductDetail = '/organic-products/{id}';

  // Search
  static const String search = '/products/search';
  static const String searchSuggestions = '/products/search/suggestions';

  // Ratings
  static const String ratingStore = '/ratings';
  static const String ratingByVendorInventory =
      '/ratings/vendor-inventory/{id}';
  static const String userRatings = '/ratings/user';
}

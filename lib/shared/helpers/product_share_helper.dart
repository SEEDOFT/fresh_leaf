class ProductShareHelper {
  const ProductShareHelper._();

  static String resolveSlug({
    required String title,
    String? shareSlug,
  }) {
    final provided = (shareSlug ?? '').trim();
    if (provided.isNotEmpty) {
      return _sanitizeSlug(provided);
    }
    return _sanitizeSlug(title);
  }

  static String resolveDeepLink({
    required String title,
    String? shareSlug,
    String? shareDeepLink,
  }) {
    final providedLink = (shareDeepLink ?? '').trim();
    if (providedLink.isNotEmpty) {
      return providedLink;
    }
    final slug = resolveSlug(title: title, shareSlug: shareSlug);
    return 'freshleaf://product/$slug';
  }

  static String trimDescription(String value, {int maxLength = 120}) {
    final normalized = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (normalized.length <= maxLength) {
      return normalized;
    }
    return '${normalized.substring(0, maxLength).trimRight()}...';
  }

  static String _sanitizeSlug(String input) {
    var slug = input.toLowerCase().trim();
    slug = slug.replaceAll(RegExp('[^a-z0-9]+'), '-');
    slug = slug.replaceAll(RegExp('-{2,}'), '-');
    slug = slug.replaceAll(RegExp(r'^-+|-+$'), '');
    if (slug.isEmpty) {
      return 'product';
    }
    return slug;
  }
}

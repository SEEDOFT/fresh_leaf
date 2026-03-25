import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/home/controllers/home_controller.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class HomeWidget {
  HomeWidget._();

  // Build App Bar
  static Widget buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.textDark,
                size: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Organic Farm,',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CA',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDark.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Column(
            children: [
              Text(
                'FreshLeaf',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'Organic',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.cardLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 20,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 240,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              buildNetworkImage(
                url:
                    'https://images.unsplash.com/photo-1595841696677-6489ff3f8cd1?q=80&w=1000',
                height: 240,
                width: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black12,
                      AppColors.primaryGreen.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentLime,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'LIMITED EDITION',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Seasonal\nOrganic\nHarvest',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Explore Selection',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildCategories(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Browse Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = controller.categories[index];
              return Container(
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      cat['icon'] == 'leaf'
                          ? Icons.eco
                          : (cat['icon'] == 'apple'
                                ? Icons.apple
                                : Icons.grass), // Replace with SVGs if needed
                      color: AppColors.textDark,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cat['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget buildAIBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentLime,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Smart\nSuggestions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Curating your basket based on\ncooking habits',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  static Widget buildSectionHeader(String title, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: AppColors.textLight),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildHorizontalProducts(HomeController controller) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: controller.pickedThisMorning.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = controller.pickedThisMorning[index];
          return Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    buildNetworkImage(
                      url: item['image']!,
                      height: 140,
                      width: 200,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentLime,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['badge']!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            item['price']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['subtitle']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.cardLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.textDark,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget buildStaplesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Tall Card
          Expanded(
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Background color fallback
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=600',
                  ), // Replace with Eggs image
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black38,
                      Colors.transparent,
                      Colors.black38,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pasture Raised\nEggs',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Dozen, Large',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Re-order',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '\$6.50',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Right Column (Two smaller cards)
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentPeach,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Whole Milk',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Text(
                        'Glass Bottle, 1L',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Add \$4.20',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentLime,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sourdough\nLoaf',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textDark,
                        ),
                      ),
                      const Text(
                        'Artisan Baked',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Add \$7.50',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFarmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1506976785307-8732e854ad03?q=80&w=600',
              ), // Replace with farmer image
            ),
            const SizedBox(height: 16),
            const Text(
              'FEATURED FARMER',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Meet Miller\'s Organic',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Supplying our community with pesticide-free heirloom produce since 1994. Every bunch of kale helps support local biodiversity.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildChip(Icons.check_circle, 'Carbon Neutral'),
                const SizedBox(width: 8),
                buildChip(Icons.local_shipping, '12 Miles Away'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textDark),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildNetworkImage({
    required String url,
    double? height,
    double? width,
    BorderRadius? borderRadius,
    BoxFit fit = BoxFit.cover,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        url,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return skeletonBox(
            height: height,
            width: width,
            borderRadius: borderRadius,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return skeletonBox(
            height: height,
            width: width,
            borderRadius: borderRadius,
            child: const Icon(
              Icons.broken_image,
              color: AppColors.textLight,
            ),
          );
        },
      ),
    );
  }

  static Widget skeletonBox({
    double? height,
    double? width,
    BorderRadius? borderRadius,
    Widget? child,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: child == null ? null : Center(child: child),
    );
  }
}

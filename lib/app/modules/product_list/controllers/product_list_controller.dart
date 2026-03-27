import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/product_detail/models/product_info.dart';

class ProductListController extends GetxController {
  final isLoading = false.obs;
  final products = <ProductInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    isLoading.value = true;
    // Simulate network delay
    Future.delayed(
      const Duration(seconds: 1),
      () => {
        isLoading.value = false,
        products.value = [
          ProductInfo(
            title: 'Heritage Carrots',
            subtitle: 'Rainbow blend',
            description:
                'Naturally sweet, vibrant heirloom carrots harvested at peak freshness',
            imageUrl:
                'https://images.unsplash.com/photo-1593642532403-3050295488a5?q=80&w=1000',
            tags: ['Organic', 'Root Vegetable'],
            price: 4.50,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Refrigerate',
          ),
          ProductInfo(
            title: 'Golden Oysters',
            subtitle: 'Gourmet mushrooms',
            description:
                'Delicate, buttery-flavored mushrooms grown in sustainable conditions',
            imageUrl:
                'https://images.unsplash.com/photo-1556911892-bbe3ff16d8ee?q=80&w=1000',
            tags: ['Organic', 'Mushrooms'],
            price: 8.00,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Paper bag',
          ),
          ProductInfo(
            title: 'Leafy Greens',
            subtitle: 'Mixed organic greens',
            description: 'Nutrient-rich blend of kale, spinach, and arugula',
            imageUrl:
                'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=1000',
            tags: ['Organic', 'Greens'],
            price: 3.25,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Refrigerate',
          ),
          ProductInfo(
            title: 'Citrus Bundle',
            subtitle: 'Seasonal citrus fruits',
            description: 'Sun-ripened oranges, lemons, and grapefruits',
            imageUrl:
                'https://images.unsplash.com/photo-1582719478250-5cd631d3338c?q=80&w=1000',
            tags: ['Organic', 'Fruit'],
            price: 12.00,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Cool dry place',
          ),
          ProductInfo(
            title: 'Rainbow Chard',
            subtitle: 'Colorful stalks',
            description:
                'Vibrant stems with tender leaves, packed with nutrients',
            imageUrl:
                'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=1000',
            tags: ['Organic', 'Vegetable'],
            price: 5.90,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Refrigerate',
          ),
          ProductInfo(
            title: 'Wild Mushrooms',
            subtitle: 'Foraged selection',
            description: 'Earthy, aromatic mushrooms from sustainable foraging',
            imageUrl:
                'https://images.unsplash.com/photo-1470747801570-32410980427?q=80&w=1000',
            tags: ['Organic', 'Mushrooms'],
            price: 15.00,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Paper bag',
          ),
          ProductInfo(
            title: 'Artisan Bread',
            subtitle: 'Sourdough loaf',
            description:
                'Handcrafted bread with organic grains and natural fermentation',
            imageUrl:
                'https://images.unsplash.com/photo-1509440159596-02490887734?q=80&w=1000',
            tags: ['Organic', 'Bakery'],
            price: 8.00,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Bread box',
          ),
          ProductInfo(
            title: 'Pasture Raised Eggs',
            subtitle: 'Free-range, organic',
            description:
                'Nutrient-dense eggs from hens raised on organic pasture',
            imageUrl:
                'https://images.unsplash.com/photo-1582722872472-55e44e8a061d?q=80&w=1000',
            tags: ['Organic', 'Protein'],
            price: 6.50,
            origin: 'Local Farm',
            harvest: 'Spring 2026',
            storage: 'Refrigerate',
          ),
        ],
      },
    );
  }
}

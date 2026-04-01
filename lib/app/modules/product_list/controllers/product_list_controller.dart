import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:get/get.dart';

class ProductListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<ProductInfo> products = <ProductInfo>[].obs;

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
        products.value = const [
          ProductInfo(
            title: 'product_heritage_carrots_title',
            subtitle: 'product_heritage_carrots_subtitle',
            description: 'product_heritage_carrots_description',
            imageUrl:
                'https://images.unsplash.com/photo-1593642532403-3050295488a5?q=80&w=1000',
            tags: ['organic', 'tag_root_vegetable'],
            price: 4.50,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'refrigerate',
          ),
          ProductInfo(
            title: 'product_golden_oysters_title',
            subtitle: 'product_golden_oysters_subtitle',
            description: 'product_golden_oysters_description',
            imageUrl:
                'https://images.unsplash.com/photo-1556911892-bbe3ff16d8ee?q=80&w=1000',
            tags: ['organic', 'tag_mushrooms'],
            price: 8,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'paper_bag',
          ),
          ProductInfo(
            title: 'product_leafy_greens_title',
            subtitle: 'product_leafy_greens_subtitle',
            description: 'product_leafy_greens_description',
            imageUrl:
                'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=1000',
            tags: ['organic', 'tag_greens'],
            price: 3.25,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'refrigerate',
          ),
          ProductInfo(
            title: 'product_citrus_bundle_title',
            subtitle: 'product_citrus_bundle_subtitle',
            description: 'product_citrus_bundle_description',
            imageUrl:
                'https://images.unsplash.com/photo-1582719478250-5cd631d3338c?q=80&w=1000',
            tags: ['organic', 'tag_fruit'],
            price: 12,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'cool_dry_place',
          ),
          ProductInfo(
            title: 'product_rainbow_chard_title',
            subtitle: 'product_rainbow_chard_subtitle',
            description: 'product_rainbow_chard_description',
            imageUrl:
                'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=1000',
            tags: ['organic', 'tag_vegetable'],
            price: 5.90,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'refrigerate',
          ),
          ProductInfo(
            title: 'product_wild_mushrooms_title',
            subtitle: 'product_wild_mushrooms_subtitle',
            description: 'product_wild_mushrooms_description',
            imageUrl:
                'https://images.unsplash.com/photo-1470747801570-32410980427?q=80&w=1000',
            tags: ['organic', 'tag_mushrooms'],
            price: 15,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'paper_bag',
          ),
          ProductInfo(
            title: 'product_artisan_bread_title',
            subtitle: 'product_artisan_bread_subtitle',
            description: 'product_artisan_bread_description',
            imageUrl:
                'https://images.unsplash.com/photo-1509440159596-02490887734?q=80&w=1000',
            tags: ['organic', 'tag_bakery'],
            price: 8,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'bread_box',
          ),
          ProductInfo(
            title: 'product_pasture_eggs_title',
            subtitle: 'product_pasture_eggs_subtitle',
            description: 'product_pasture_eggs_description',
            imageUrl:
                'https://images.unsplash.com/photo-1582722872472-55e44e8a061d?q=80&w=1000',
            tags: ['organic', 'tag_protein'],
            price: 6.50,
            origin: 'local_farm',
            harvest: 'harvest_spring_2026',
            storage: 'refrigerate',
          ),
        ],
      },
    );
  }
}

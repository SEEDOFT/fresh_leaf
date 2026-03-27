import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

class HeroImageWidget extends StatelessWidget {
  const HeroImageWidget({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentLime.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'ORGANIC',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleRowWidget extends StatelessWidget {
  const TitleRowWidget({
    super.key,
    required this.title,
    required this.origin,
    required this.total,
  });

  final String title;
  final String origin;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                origin,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class TagsWidget extends StatelessWidget {
  const TagsWidget({
    super.key,
    required this.tags,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class InfoTilesWidget extends StatelessWidget {
  const InfoTilesWidget({
    super.key,
    required this.harvest,
    required this.origin,
    required this.storage,
  });

  final String harvest;
  final String origin;
  final String storage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoTileWidget(
            title: 'Harvest',
            value: harvest,
            icon: Icons.eco_outlined,
          ),
        ),
        Expanded(
          child: InfoTileWidget(
            title: 'Origin',
            value: origin,
            icon: Icons.place_outlined,
          ),
        ),
        Expanded(
          child: InfoTileWidget(
            title: 'Storage',
            value: storage,
            icon: Icons.kitchen_outlined,
          ),
        ),
      ],
    );
  }
}

class QuantityRowWidget extends StatelessWidget {
  const QuantityRowWidget({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
              ),
              Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onIncrement,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({
    super.key,
    required this.total,
    required this.onPressed,
  });

  final double total;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add to cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTileWidget extends StatelessWidget {
  const InfoTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textDark),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

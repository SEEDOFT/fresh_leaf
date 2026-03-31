import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/product_detail/widgets/info_tile_widget.dart';
import 'package:get/get.dart';

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
            title: 'harvest'.tr,
            value: harvest,
            icon: Icons.eco_outlined,
          ),
        ),
        Expanded(
          child: InfoTileWidget(
            title: 'origin'.tr,
            value: origin,
            icon: Icons.place_outlined,
          ),
        ),
        Expanded(
          child: InfoTileWidget(
            title: 'storage'.tr,
            value: storage,
            icon: Icons.kitchen_outlined,
          ),
        ),
      ],
    );
  }
}

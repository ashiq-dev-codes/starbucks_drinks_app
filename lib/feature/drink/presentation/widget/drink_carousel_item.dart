import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starbucks_drinks_app/feature/drink/model/drink.dart';

class DrinkCarouselItem extends StatelessWidget {
  const DrinkCarouselItem({super.key, required this.drink, required this.scale});

  final Drink drink;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Stack(
        children: [
          // Blurred black silhouette of the same image, offset behind it,
          // stands in for the native shape-hugging shadow the RN source gets for free.
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, 10),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.7),
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(drink.imageAsset, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(drink.imageAsset, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

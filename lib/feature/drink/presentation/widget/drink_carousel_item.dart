import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starbucks_drinks_app/feature/drink/model/drink.dart';
import 'package:starbucks_drinks_app/feature/drink/presentation/drink_colors.dart';

class DrinkCarouselItem extends StatelessWidget {
  const DrinkCarouselItem({
    super.key,
    required this.drink,
    required this.index,
    required this.pageController,
  });

  final Drink drink;
  final int index;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // Only this small AnimatedBuilder reruns every scroll frame; the
      // blurred-shadow + image subtree below is built once and reused via
      // the `child` param, instead of rebuilding the whole PageView per frame.
      child: AnimatedBuilder(
        animation: pageController,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(0, 10),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      DrinkColors.black.withValues(alpha: 0.7),
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
        builder: (context, child) {
          double page;
          if (!pageController.hasClients) {
            page = pageController.initialPage.toDouble();
          } else {
            page = pageController.page ?? pageController.initialPage.toDouble();
          }
          final diff = (page - index).abs();
          final scale = (1 - 0.5 * diff).clamp(0.0, 1.0);
          return Transform.scale(scale: scale, child: child);
        },
      ),
    );
  }
}

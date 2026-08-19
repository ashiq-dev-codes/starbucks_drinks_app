import 'package:flutter/material.dart';
import 'package:starbucks_drinks_app/feature/drink/model/drink.dart';
import 'package:starbucks_drinks_app/feature/drink/presentation/drink_colors.dart';
import 'package:starbucks_drinks_app/shared/constant/app_spacing.dart';
import 'package:starbucks_drinks_app/shared/theme/app_font.dart';
import 'package:starbucks_drinks_app/shared/theme/app_font_size.dart';

class DrinkInfoCard extends StatelessWidget {
  const DrinkInfoCard({super.key, required this.drink, required this.height});

  final Drink drink;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.unit * 2,
          vertical: AppSpacing.unit * 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              drink.price,
              style: const TextStyle(
                fontFamily: AppFont.poppins,
                fontSize: AppFontSize.xLarge,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.unit),
              child: Text(
                drink.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppFont.poppins,
                  fontSize: AppFontSize.large,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                drink.description,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppFont.poppins,
                  fontSize: AppFontSize.small,
                  fontWeight: FontWeight.w400,
                  color: DrinkColors.lightText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

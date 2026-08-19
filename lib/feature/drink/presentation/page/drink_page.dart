import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:starbucks_drinks_app/feature/drink/model/drink.dart';
import 'package:starbucks_drinks_app/feature/drink/presentation/drink_colors.dart';
import 'package:starbucks_drinks_app/feature/drink/presentation/widget/drink_carousel_item.dart';
import 'package:starbucks_drinks_app/feature/drink/presentation/widget/drink_info_card.dart';
import 'package:starbucks_drinks_app/shared/constant/app_spacing.dart';
import 'package:starbucks_drinks_app/shared/theme/app_colors.dart';
import 'package:starbucks_drinks_app/shared/theme/app_font_size.dart';

const double _kItemHeight = 350;
const double _kInfoItemHeight = 385;
const double _kInfoVisibleHeight = _kInfoItemHeight - AppSpacing.unit * 7;
const double _kOverlap = AppSpacing.unit * 3;

const List<Drink> _drinks = [
  Drink(
    id: 1,
    title: 'Chocolate Cream Chip Frappuccino',
    price: r'$14',
    type: 'Blended Beverage',
    description: 'Rich mocha-flavored sauce blended with milk, chocolaty chips and ice. Topped with sweetened whipped cream and chocolate-flavored drizzle. This creation is the non-coffee alternative to our famous Java Chip Frappuccino. It is a decadent beverage for those who love the taste of chocolate – and lots of it. Rich, chocolaty chips punctuate a cool, refreshing blend of milk and mocha flavors. And in case that isn\'t enough chocolaty goodness for you, we finish our sweetened whipped cream topping with a deliciously sweet chocolate-flavored drizzle.',
    imageAsset: 'assets/images/drinks/chocolate_cream_chip_frappuccino.png',
  ),
  Drink(
    id: 2,
    title: 'Dark Mocha Frappuccino',
    price: r'$14',
    type: 'Blended Beverage',
    description: 'For serious chocolate lovers: We blend dark cocoa with milk, ice and coffee for an extraordinarily chocolatey experience that\'s then topped with a swirl of whipped cream.',
    imageAsset: 'assets/images/drinks/dark_mocha_frappuccino.png',
  ),
  Drink(
    id: 5,
    title: 'Java Chip Frappuccino',
    price: r'$14',
    type: 'Blended Beverage',
    description: 'Coffee with rich mocha-flavored sauce blended with milk, chocolaty chips and ice. Topped with sweetened whipped cream and chocolate-flavored drizzle. We created this wondrously decadent beverage for those who love the taste of chocolate – and lots of it – with their iced coffee. Rich, chocolaty chips punctuate a cool, refreshing blend of coffee and mocha flavors. And in case that isn\'t enough chocolaty goodness for you, we finish our sweetened whipped cream topping with a deliciously sweet chocolate-flavored drizzle.',
    imageAsset: 'assets/images/drinks/java_chip_frappuccino.png',
  ),
  Drink(
    id: 6,
    title: 'Green Tea Cream Frappuccino',
    price: r'$14',
    type: 'Blended Beverage',
    description: 'A refreshing blend of sweetened matcha green tea, milk and ice. Topped with sweetened whipped cream. Although matcha tea is best known for its central role in the serene ritual known as the Japanese tea ceremony, tea drinkers all over the world have come to enjoy the gentle, uplifting taste of this finely-powdered green tea in their own way. We particularly like the way it blends with milk and ice in this refreshing Frappuccino® blended beverage. And we think you will too.',
    imageAsset: 'assets/images/drinks/green_tea_cream_frappuccino.png',
  ),
  Drink(
    id: 7,
    title: 'Vanilla Sweet Cream Cold Brew',
    price: r'$14',
    type: 'Coffee & Espresso',
    description: 'Cold Brew topped with a delicate float of house-made vanilla sweet cream that cascades throughout the cup. We use a unique craft-brewing process to create a super smooth tasting coffee. While making our Cold Brew, the coffee never comes into contact with hot water. Instead, the coffee is slow-steeped in cool water for more than 10 hours and is handcrafted in small batches each day. To create our signature recipe, our team spent months experimenting with different brew times and coffee varietals. We specifically developed the Starbucks® Cold Brew Blend to heighten the rich, naturally sweet flavor created during the cold brewing process. The blend incorporates African and Latin American coffees.',
    imageAsset: 'assets/images/drinks/vanilla_sweet_cream_cold_brew.png',
  ),
  Drink(
    id: 8,
    title: 'Cold Brew',
    price: r'$14',
    type: 'Coffee & Espresso',
    description: 'Slow-steeped, small-batch and super smooth. We use a unique craft-brewing process to create a super smooth tasting coffee. While making our Cold Brew, the coffee never comes into contact with hot water. Instead, the coffee is slow-steeped in cool water for 20 hours, no more no less and is handcrafted in small batches each day. To create our signature recipe, our team spent months experimenting with different brew times and coffee varietals. We specifically developed the Starbucks® Cold Brew Blend to heighten the rich, naturally sweet flavor created during the cold brewing process. The blend incorporates African and Latin American coffees.',
    imageAsset: 'assets/images/drinks/cold_brew.png',
  ),
];

class DrinkPage extends StatefulWidget {
  const DrinkPage({super.key});

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.5);
  final ScrollController _infoScrollController = ScrollController();
  late final AnimationController _springController;
  double _springTarget = 0;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController.unbounded(vsync: this)
      ..addListener(_followSpring);
    _pageController.addListener(_handlePageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChanged);
    _pageController.dispose();
    _infoScrollController.dispose();
    _springController.dispose();
    super.dispose();
  }

  // Mirrors the RN source's `scrollYOffset.value = withSpring(scrollY)`:
  // every scroll frame nudges the vertical panel's spring target.
  void _handlePageChanged() {
    if (!_pageController.hasClients) return;
    final page = _pageController.page;
    if (page == null) return;
    final target = page * _kInfoVisibleHeight;
    if ((target - _springTarget).abs() < 0.01) return;
    _springTarget = target;
    _springController.animateWith(
      // Critically damped (damping = 2*sqrt(mass*stiffness)): catches up to
      // the new target quickly with no bounce/overshoot, for a snappier feel
      // than Reanimated's underdamped default.
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 400, damping: 40),
        _springController.value,
        target,
        0,
      ),
    );
  }

  void _followSpring() {
    if (_infoScrollController.hasClients) {
      _infoScrollController.jumpTo(_springController.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The RN screen itself sets no background — this green comes from
      // _layout.tsx's ThemeProvider, which spreads Colors (background: "#006241")
      // over React Navigation's theme, so the native-stack screen container
      // paints Starbucks green behind everything.
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.unit * 4),
          child: SizedBox(
            height: _kItemHeight + _kInfoItemHeight - _kOverlap,
            child: Stack(
              children: [
                Positioned(
                  top: _kItemHeight - _kOverlap,
                  left: AppSpacing.unit * 2,
                  right: AppSpacing.unit * 2,
                  height: _kInfoItemHeight,
                  child: _InfoCard(infoScrollController: _infoScrollController),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: _kItemHeight,
                  child: PageView.builder(
                    controller: _pageController,
                    // RN's Image sets `overflow: "visible"` so its native shadow
                    // can bleed past the image's own box — PageView's viewport
                    // clips by default, which is what was hard-cutting our
                    // blurred shadow at each item's bottom edge.
                    clipBehavior: Clip.none,
                    physics: const _SnapPageScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    itemCount: _drinks.length,
                    itemBuilder: (context, index) {
                      return DrinkCarouselItem(
                        drink: _drinks[index],
                        index: index,
                        pageController: _pageController,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// A stiffer, critically-damped settle spring than PageScrollPhysics' default,
// so a page snaps into place quickly instead of drifting/bouncing into it.
class _SnapPageScrollPhysics extends PageScrollPhysics {
  const _SnapPageScrollPhysics({super.parent});

  @override
  _SnapPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring =>
      SpringDescription.withDampingRatio(mass: 0.5, stiffness: 400, ratio: 1);
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.infoScrollController});

  final ScrollController infoScrollController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppSpacing.unit * 3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.unit * 3),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: infoScrollController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _drinks.length,
                itemBuilder: (context, index) => DrinkInfoCard(
                  drink: _drinks[index],
                  height: _kInfoVisibleHeight,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.unit * 2,
                right: AppSpacing.unit * 2,
                bottom: AppSpacing.unit * 2,
              ),
              child: _GetItButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _GetItButton extends StatelessWidget {
  const _GetItButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.unit * 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DrinkColors.black,
          borderRadius: BorderRadius.circular(AppSpacing.unit * 3),
          boxShadow: [
            BoxShadow(
              color: DrinkColors.black.withValues(alpha: 0.3),
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Get it',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: AppFontSize.large,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

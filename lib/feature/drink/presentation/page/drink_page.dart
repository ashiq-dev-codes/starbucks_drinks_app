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
  final PageController _infoPageController = PageController();
  late final AnimationController _springController;
  // The shared coordinate both controllers sync through: a fractional page
  // index (0..itemCount-1), independent of either controller's own pixel
  // geometry (viewportDimension/viewportFraction differ between the two).
  double _springTarget = 0;
  // Whichever controller the user is actually dragging right now owns the
  // spring; the other one is the follower for that spring run. This is set
  // ONLY by a genuine drag-start gesture (see the NotificationListeners in
  // build()) — never by a controller's own page-changed listener — so that
  // a controller's residual settle/snap animation (from ITS OWN earlier
  // partial drag) can't steal control away from whichever side the user is
  // actively touching right now. Without that guard, two independently
  // physics-driven PageViews fight over which one drives the other.
  _SyncSource _activeSyncSource = _SyncSource.page;
  // Guards against feedback loops: set while we're programmatically moving a
  // controller so its own listener doesn't treat that as a new user scroll.
  bool _isProgrammaticPageChange = false;
  bool _isProgrammaticInfoChange = false;
  // Recomputed each build from the available screen height so the info card
  // always reaches the bottom of the screen instead of using a fixed height.
  double _infoVisibleHeight = 0;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController.unbounded(vsync: this)
      ..addListener(_followSpring);
    _pageController.addListener(_handlePageChanged);
    _infoPageController.addListener(_handleInfoPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChanged);
    _pageController.dispose();
    _infoPageController.removeListener(_handleInfoPageChanged);
    _infoPageController.dispose();
    _springController.dispose();
    super.dispose();
  }

  void _handlePageChanged() {
    if (_isProgrammaticPageChange || !_pageController.hasClients) return;
    final page = _pageController.page;
    if (page == null) return;
    _driveSpring(_SyncSource.page, page);
  }

  void _handleInfoPageChanged() {
    if (_isProgrammaticInfoChange || !_infoPageController.hasClients) return;
    final page = _infoPageController.page;
    if (page == null) return;
    _driveSpring(_SyncSource.info, page);
  }

  // Mirrors the RN source's `scrollYOffset.value = withSpring(scrollY)`:
  // every scroll frame nudges the follower's spring target, in both
  // directions, so dragging either the carousel or the info card keeps them
  // in sync. Only trusted from whichever controller currently owns
  // _activeSyncSource (see its doc comment) — a page-changed event from the
  // other one is residual motion, not a new drive command, so it's ignored.
  void _driveSpring(_SyncSource source, double page) {
    if (_activeSyncSource != source) return;
    if ((page - _springTarget).abs() < 0.0001) return;
    _springTarget = page;
    _springController.animateWith(
      // Critically damped (damping = 2*sqrt(mass*stiffness)) so it never
      // overshoots, tuned softer than a snap so the follower glides into
      // place instead of visibly teleporting frame-to-frame. A live drag
      // re-targets this simulation on nearly every frame — carrying over
      // the current velocity (instead of resetting to 0 each time) is what
      // keeps that a single continuous glide rather than a stutter that
      // brakes to a stop and re-accelerates on every retarget.
      SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 180, damping: 26.8),
        _springController.value,
        page,
        _springController.velocity,
      ),
    );
  }

  void _followSpring() {
    final isInfoDriven = _activeSyncSource == _SyncSource.info;
    final follower = isInfoDriven ? _pageController : _infoPageController;
    if (!follower.hasClients) return;
    final position = follower.position;
    final dimension = position.viewportDimension * follower.viewportFraction;
    final pixels = (_springController.value * dimension).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (isInfoDriven) {
      _isProgrammaticPageChange = true;
    } else {
      _isProgrammaticInfoChange = true;
    }
    follower.jumpTo(pixels);
    _isProgrammaticPageChange = false;
    _isProgrammaticInfoChange = false;
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Fill exactly down to the bottom of the screen instead of a
            // fixed height, so the card's bottom edge always meets the
            // safe area rather than leaving a gap.
            _infoVisibleHeight =
                constraints.maxHeight -
                (_kItemHeight - _kOverlap) -
                AppSpacing.unit * 7;
            return Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Stack(
                children: [
                  Positioned(
                    top: _kItemHeight - _kOverlap,
                    left: AppSpacing.unit * 2,
                    right: AppSpacing.unit * 2,
                    bottom: 0,
                    child: _InfoCard(
                      itemHeight: _infoVisibleHeight,
                      infoPageController: _infoPageController,
                      onUserDragStart: () => _activeSyncSource = _SyncSource.info,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: _kItemHeight,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollStartNotification &&
                            notification.dragDetails != null) {
                          _activeSyncSource = _SyncSource.page;
                        }
                        return false;
                      },
                      child: PageView.builder(
                        controller: _pageController,
                        // RN's Image sets `overflow: "visible"` so its native shadow
                        // can bleed past the image's own box — PageView's viewport
                        // clips by default, which is what was hard-cutting our
                        // blurred shadow at each item's bottom edge.
                        clipBehavior: Clip.none,
                        physics: const _SnapPageScrollPhysics(
                          parent: BouncingScrollPhysics(),
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Which controller most recently moved for a real (non-programmatic) reason,
// i.e. which one the spring should treat as the source of truth right now.
enum _SyncSource { page, info }

// A softer, still critically-damped settle spring than PageScrollPhysics'
// default, so a released page glides into place rather than drifting slowly
// or snapping abruptly.
class _SnapPageScrollPhysics extends PageScrollPhysics {
  const _SnapPageScrollPhysics({super.parent});

  @override
  _SnapPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring =>
      SpringDescription.withDampingRatio(mass: 0.5, stiffness: 220, ratio: 1);
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.infoPageController,
    required this.itemHeight,
    required this.onUserDragStart,
  });

  final PageController infoPageController;
  final double itemHeight;
  final VoidCallback onUserDragStart;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppSpacing.unit * 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.unit * 3),
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification &&
                      notification.dragDetails != null) {
                    onUserDragStart();
                  }
                  return false;
                },
                child: PageView.builder(
                  controller: infoPageController,
                  scrollDirection: Axis.vertical,
                  physics: const _SnapPageScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: _drinks.length,
                  itemBuilder: (context, index) =>
                      DrinkInfoCard(drink: _drinks[index], height: itemHeight),
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
              blurRadius: 5,
              spreadRadius: 0,
              offset: const Offset(5, 5),
              color: DrinkColors.black.withValues(alpha: 0.3),
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

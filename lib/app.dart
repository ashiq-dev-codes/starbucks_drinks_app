import 'package:flutter/material.dart';
import 'package:starbucks_drinks_app/feature/drink/presentation/page/drink_page.dart';

import 'shared/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starbucks Drinks App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const DrinkPage(),
    );
  }
}

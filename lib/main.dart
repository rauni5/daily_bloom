import 'package:daily_bloom/product/presentation/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),

      child: const DailyBloom(),
    ),
  );
}

class DailyBloom extends StatelessWidget {
  const DailyBloom({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, app, _) {
        return ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,

          builder: (_, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,

              title: "Daily Bloom",

              theme: AppTheme.light,

              darkTheme: AppTheme.dark,

              themeMode: app.isDarkMode ? ThemeMode.dark : ThemeMode.light,

              home: const ProductScreen(),
            );
          },
        );
      },
    );
  }
}

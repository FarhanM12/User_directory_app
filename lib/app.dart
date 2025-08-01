import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'screens/splash_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_detail_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Directory',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        textTheme: AppTextStyles.textTheme,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        UserListScreen.routeName: (_) => const UserListScreen(),
        UserDetailScreen.routeName: (_) => const UserDetailScreen(),
      },
    );
  }
}
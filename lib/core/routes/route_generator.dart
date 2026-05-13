import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/features/auth/presentation/views/create_your_account/create_your_account_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/login/login_view.dart';
import 'package:chirp_up_app/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.createYourAccount:
        return MaterialPageRoute(builder: (_) => const CreateYourAccountView());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: CustomText(text: 'No Route Found')),
          ),
        );
    }
  }
}

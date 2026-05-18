import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/features/auth/presentation/views/add_another_child/add_another_child_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/create_your_account/create_your_account_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/create_your_child_profile/create_your_child_profile_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/kingdom_ready/kingdon_is_ready_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/login/login_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/setup_your_pin/setup_your_pin_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/tap_on_castle/tap_on_castle_view.dart';
import 'package:chirp_up_app/features/auth/presentation/views/who_are_you/who_are_you_view.dart';
import 'package:chirp_up_app/features/parent/dashboard/presentation/views/parent_dashboard_view.dart';
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
      case AppRoutes.createYourChildProfile:
        return MaterialPageRoute(builder: (_) => CreateYourChildProfileView());
      case AppRoutes.kingdomIsReady:
        return MaterialPageRoute(builder: (_) => KingdonIsReadyView());
      case AppRoutes.addAnotherChild:
        return MaterialPageRoute(builder: (_) => AddAnotherChildView());
      case AppRoutes.setupYourPin:
        final isConfirmMode = (settings.arguments as bool?) ?? false;
        return MaterialPageRoute(
          builder: (_) => SetupYourPinView(isConfirmMode: isConfirmMode),
        );
      case AppRoutes.tapOnCastle:
        return MaterialPageRoute(builder: (_) => TapOnCastleView());
      case AppRoutes.whoAreYou:
        return MaterialPageRoute(builder: (_) => WhoAreYouView());
      case AppRoutes.parentDashboard:
        return MaterialPageRoute(builder: (_) => ParentDashboardView());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: CustomText(text: 'No Route Found')),
          ),
        );
    }
  }
}

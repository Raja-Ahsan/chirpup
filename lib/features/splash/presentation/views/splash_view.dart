import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/splash_characters.png",
              fit: BoxFit.fill,
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Center(
                  child: Image.asset("assets/png/app_logo.png", height: 180),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    left: AppSizes.horizontalPadding,
                    right: AppSizes.horizontalPadding,
                    bottom: AppSizes.verticalPadding,
                  ),
                  child: CommonButton(
                    title: 'Step Into the Kingdom',
                    onPressed: () {
                      final token = StorageService.getToken();
                      if (token.isNotEmpty) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.whoAreYou,
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

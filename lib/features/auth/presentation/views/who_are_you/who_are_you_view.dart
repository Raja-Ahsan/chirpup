import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class WhoAreYouView extends StatelessWidget {
  const WhoAreYouView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/png/whoareyou_bg.png",
                fit: BoxFit.fill,
                width: screenWidth,
                height: screenHeight,
              ),
            ),

            Positioned(
              bottom: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context,AppRoutes.parentDashboard, (route)=> false);
                    },
                    child: Image.asset(
                      "assets/png/parent_boy.png",
                      height: screenHeight * 0.58,
                      width: screenWidth * 0.65,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      "assets/png/boy_character_1.png",
                      height: screenHeight * 0.48,
                      width: screenWidth * 0.45,
                    ),
                  )
                ],
              ),
            ),

            // ✅ Text content — top
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.verticalPadding,
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    HeadingText(
                      text: "Who are You Today?",
                      fontSize: 28,
                      color: AppColors.textYellow,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      text: "Choose how you want to start your adventure!",
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

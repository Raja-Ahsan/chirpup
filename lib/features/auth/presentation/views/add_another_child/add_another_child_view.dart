import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:flutter/material.dart';

class AddAnotherChildView extends StatelessWidget {
  const AddAnotherChildView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/auth_background_blur.png",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: AppSizes.verticalPadding,
                      right: AppSizes.horizontalPadding,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.setupYourPin);
                      },
                      child: CustomText(
                        text: 'continue',
                        fontSize: 18,
                        fontFamily: 'LuckiestGuy',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HeadingText(
                        text: "ADD ANOTHER CHILD?",
                        fontSize: 28,
                        color: AppColors.textYellow,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 5),
                      CustomText(
                        text:
                            'You can create profiles for more children\nnow or add them later anytime',
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        color: AppColors.whiteColor,
                      ),
                      SizedBox(height: 25),
                      CommonButton(
                        title: 'ADD CHILD',
                        bgColor: AppColors.blueColor,
                        shadowColor: AppColors.textShadowBlue,
                        horizontalPadding: 40,
                        onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.pickYourMagicalFriend, (route)=> false);
                        },
                      ),
                    ],
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

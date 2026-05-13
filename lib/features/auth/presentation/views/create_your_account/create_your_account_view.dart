import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/utils/show_common_dialog.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/custom_textfield.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/presentation/widgets/otp_dialog.dart';
import 'package:flutter/material.dart';

class CreateYourAccountView extends StatelessWidget {
  const CreateYourAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/create_account_background.png",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding,
                        vertical: AppSizes.verticalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Center(
                            child: HeadingText(
                              text: 'CREATE YOUR ACCOUNT',
                              fontSize: 32,
                              color: AppColors.textYellow,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: CustomText(
                              fontSize: 14,
                              textAlign: TextAlign.center,
                              text:
                                  'Set up your account to begin your child’s journey\nin a safe and magical world',
                            ),
                          ),
                          SizedBox(height: 40),
                          CustomTextField(hintText: 'full name'),
                          SizedBox(height: 10),
                          CustomTextField(hintText: 'email'),
                          SizedBox(height: 10),
                          CustomTextField(hintText: 'password'),
                          SizedBox(height: 10),
                          CustomTextField(hintText: 'confirm password'),

                          SizedBox(height: 30),
                          CommonButton(
                            title: 'Create Account',
                            bgColor: AppColors.blueColor,
                            shadowColor: AppColors.textShadowBlue,
                            onPressed: () {
                              showCommonDialog(
                                context: context,
                                child: otpDialog(context),
                                barrierDismissible: true,
                              );
                            },
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: CustomText(
                              text: 'Already have an account?',
                              weight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),

                          Center(
                            child: CommonButton(
                              title: "Sign in",
                              horizontalPadding: 40,
                              fontSize: 16,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

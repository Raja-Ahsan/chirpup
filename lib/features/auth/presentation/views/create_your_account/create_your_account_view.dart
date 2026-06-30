import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/custom_textfield.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_events.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateYourAccountView extends StatelessWidget {
  CreateYourAccountView({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
                          CustomTextField(
                            hintText: 'full name',
                            controller: fullNameController,
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: 'email',
                            controller: emailController,
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: 'password',
                            controller: passwordController,
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: 'confirm password',
                            controller: confirmPasswordController,
                          ),

                          SizedBox(height: 30),
                          BlocBuilder<AuthBloc, AuthStates>(
                            buildWhen: (prev, curr) =>
                                prev.isLoading != curr.isLoading,
                            builder: (context, state) {
                              return CommonButton(
                                title: 'Create Account',
                                isLoading: state.isLoading,
                                bgColor: AppColors.blueColor,
                                shadowColor: AppColors.textShadowBlue,
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    RegisterEvent(
                                      context: context,
                                      fullName: fullNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      confirmPassword:
                                          confirmPasswordController.text,
                                    ),
                                  );
                                },
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

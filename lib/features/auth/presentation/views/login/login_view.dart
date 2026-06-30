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

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/login_background.png",
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
                              text: 'WELCOME BACK',
                              fontSize: 32,
                              color: AppColors.textYellow,
                            ),
                          ),
                          Center(
                            child: CustomText(
                              textAlign: TextAlign.center,
                              fontSize: 14,
                              text:
                                  'Continue your child’s journey in a\nsafe and magical world',
                            ),
                          ),
                          SizedBox(height: 40),
                          CustomTextField(
                            hintText: 'email',
                            controller: _emailController,
                          ),
                          SizedBox(height: 10),
                          CustomTextField(
                            hintText: 'password',
                            controller: _passwordController,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: CustomText(
                                  text: 'Forgot Password?',
                                  fontSize: 12,
                                  weight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          BlocBuilder<AuthBloc, AuthStates>(
                            buildWhen: (prev, curr) =>
                                prev.isLoading != curr.isLoading,
                            builder: (context, state) {
                              return CommonButton(
                                title: 'Enter',
                                isLoading: state.isLoading,
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    LoginEvent(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: CustomText(
                              text: 'New here?',
                              weight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),

                          Center(
                            child: CommonButton(
                              title: "Create Account",
                              bgColor: AppColors.blueColor,
                              shadowColor: AppColors.textShadowBlue,
                              horizontalPadding: 40,
                              fontSize: 16,
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.createYourAccount,
                              ),
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

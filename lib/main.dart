import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/routes/route_generator.dart';
import 'package:chirp_up_app/core/services/storage_service.dart';
import 'package:chirp_up_app/features/auth/bloc/auth_bloc.dart';
import 'package:chirp_up_app/features/child/breath_of_kingdom/bloc/breath_of_kingdom_bloc.dart';
import 'package:chirp_up_app/features/parent/child_profile_selection/bloc/child_profile_selection_bloc.dart';
import 'package:chirp_up_app/features/parent/dashboard/bloc/parent_dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<ParentDashboardBloc>(create: (_) => ParentDashboardBloc()),
        BlocProvider<ChildProfileSelectionBloc>(
          create: (_) => ChildProfileSelectionBloc(),
        ),
        BlocProvider<BreathOfKingdomBloc>(
          create: (_) => BreathOfKingdomBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'ChirpUp',
        debugShowCheckedModeBanner: false,

        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generate,

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.whiteColor,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.whiteColor,
            elevation: 0,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }
}

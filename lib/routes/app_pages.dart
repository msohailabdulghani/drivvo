import 'package:drivvo/modules/authentication/forgot_password/forgot_password_bindings.dart';
import 'package:drivvo/modules/authentication/forgot_password/forgot_password_view.dart';
import 'package:drivvo/modules/authentication/login/login_bindings.dart';
import 'package:drivvo/modules/authentication/login/login_view.dart';
import 'package:drivvo/modules/authentication/signup/signup_bindings.dart';
import 'package:drivvo/modules/authentication/signup/signup_view.dart';
import 'package:drivvo/modules/common/onboarding/onboarding_bindings.dart';
import 'package:drivvo/modules/common/onboarding/onboarding_view.dart';
import 'package:drivvo/modules/root/root_bindings.dart';
import 'package:drivvo/modules/root/root_view.dart';
import 'package:drivvo/modules/common/update-profile/update_profile_bindings.dart';
import 'package:drivvo/modules/common/update-profile/update_profile_view.dart';
import 'package:drivvo/modules/splash_screen.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AppPages {
  static const initialRoute = AppRoutes.SPLASH_SCREEN;

  static final routes = [
    GetPage(name: AppRoutes.SPLASH_SCREEN, page: () => const SplashScreen()),

    GetPage(
      name: AppRoutes.ON_BOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBindings(),
    ),

    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
      binding: LoginBindings(),
    ),

     GetPage(
      name: AppRoutes.SIGNUP,
      page: () => SignupView(),
      binding: SignupBindings(),
    ),

    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBindings(),
    ),
    
    GetPage(
      name: AppRoutes.ROOT_VIEW,
      page: () => const RootView(),
      binding: RootBindings(),
      opaque: true,
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 0),
    ),

    GetPage(
      name: AppRoutes.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBindings(),
    ),
  ];
}

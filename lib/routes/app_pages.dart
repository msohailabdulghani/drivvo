import 'package:drivvo/modules/authentication/forgot_password/forgot_password_bindings.dart';
import 'package:drivvo/modules/authentication/forgot_password/forgot_password_view.dart';
import 'package:drivvo/modules/authentication/import-data/import_data_bindings.dart';
import 'package:drivvo/modules/authentication/import-data/import_data_view.dart';
import 'package:drivvo/modules/authentication/login/login_bindings.dart';
import 'package:drivvo/modules/authentication/login/login_view.dart';
import 'package:drivvo/modules/authentication/signup/signup_bindings.dart';
import 'package:drivvo/modules/authentication/signup/signup_view.dart';
import 'package:drivvo/modules/common/date-range/date_range_bindings.dart';
import 'package:drivvo/modules/common/date-range/date_range_view.dart';
import 'package:drivvo/modules/common/map/map_bindings.dart';
import 'package:drivvo/modules/common/map/map_view.dart';
import 'package:drivvo/modules/common/onboarding/onboarding_bindings.dart';
import 'package:drivvo/modules/common/onboarding/onboarding_view.dart';
import 'package:drivvo/modules/common/update-profile/update_profile_bindings.dart';
import 'package:drivvo/modules/common/update-profile/update_profile_view.dart';
import 'package:drivvo/modules/home/expense/create_expense_binding.dart';
import 'package:drivvo/modules/home/expense/create_expense_view.dart';
import 'package:drivvo/modules/home/expense/type/expense_type_binding.dart';
import 'package:drivvo/modules/home/expense/type/expense_type_view.dart';
import 'package:drivvo/modules/home/filter/home_filter_binding.dart';
import 'package:drivvo/modules/home/filter/home_filter_view.dart';
import 'package:drivvo/modules/home/income/create_income_binding.dart';
import 'package:drivvo/modules/home/income/create_income_view.dart';
import 'package:drivvo/modules/home/refueling/create_refueling_binding.dart';
import 'package:drivvo/modules/home/refueling/create_refueling_view.dart';
import 'package:drivvo/modules/home/route/create_route_binding.dart';
import 'package:drivvo/modules/home/route/create_route_view.dart';
import 'package:drivvo/modules/home/service/create_service_binding.dart';
import 'package:drivvo/modules/home/service/create_service_view.dart';
import 'package:drivvo/modules/home/service/type/service_type_binding.dart';
import 'package:drivvo/modules/home/service/type/service_type_view.dart';
import 'package:drivvo/modules/more/general/create/create_general_bindings.dart';
import 'package:drivvo/modules/more/general/create/create_general_view.dart';
import 'package:drivvo/modules/more/general/general_bindings.dart';
import 'package:drivvo/modules/more/general/general_view.dart';
import 'package:drivvo/modules/more/vehicles/create/create_vehicles_bindings.dart';
import 'package:drivvo/modules/more/vehicles/create/create_vehicles_view.dart';
import 'package:drivvo/modules/more/vehicles/vehicles_bindings.dart';
import 'package:drivvo/modules/more/vehicles/vehicles_view.dart';
import 'package:drivvo/modules/reminder/create/create_reminder_binding.dart';
import 'package:drivvo/modules/reminder/create/create_reminder_view.dart';
import 'package:drivvo/modules/root/root_bindings.dart';
import 'package:drivvo/modules/root/root_view.dart';
import 'package:drivvo/modules/setting/setting_bindings.dart';
import 'package:drivvo/modules/setting/setting_view.dart';
import 'package:drivvo/modules/splash_screen.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AppPages {
  static const initialRoute = AppRoutes.SPLASH_SCREEN;

  static final routes = [
    GetPage(name: AppRoutes.SPLASH_SCREEN, page: () => const SplashScreen()),

    GetPage(
      name: AppRoutes.ON_BOARDING_VIEW,
      page: () => OnboardingView(),
      binding: OnboardingBindings(),
    ),

    GetPage(
      name: AppRoutes.LOGIN_VIEW,
      page: () => LoginView(),
      binding: LoginBindings(),
    ),

    GetPage(
      name: AppRoutes.SIGNUP_VIEW,
      page: () => SignupView(),
      binding: SignupBindings(),
    ),

    GetPage(
      name: AppRoutes.FORGOT_PASSWORD_VIEW,
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
      name: AppRoutes.UPDATE_PROFILE_VIEW,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBindings(),
    ),

    GetPage(
      name: AppRoutes.IMPORT_DATA_VIEW,
      page: () => ImportDataView(),
      binding: ImportDataBindings(),
    ),

    GetPage(
      name: AppRoutes.VEHICLES_VIEW,
      page: () => VehiclesView(),
      binding: VehiclesBindings(),
    ),

    GetPage(
      name: AppRoutes.CREATE_VEHICLES_VIEW,
      page: () => CreateVehiclesView(),
      binding: CreateVehiclesBindings(),
    ),

    GetPage(
      name: AppRoutes.GENERAL_VIEW,
      page: () => GeneralView(),
      binding: GeneralBindings(),
    ),

    GetPage(
      name: AppRoutes.CREATE_GENERAL_VIEW,
      page: () => CreateGeneralView(),
      binding: CreateGeneralBindings(),
    ),

    GetPage(
      name: AppRoutes.SETTING_VIEW,
      page: () => SettingView(),
      binding: SettingBindings(),
    ),

    GetPage(
      name: AppRoutes.HOME_FILTER_VIEW,
      page: () => HomeFilterView(),
      binding: HomeFilterBinding(),
    ),

    GetPage(
      name: AppRoutes.DATE_RANGE,
      page: () => DateRangeView(),
      binding: DateRangeBindings(),
    ),

    GetPage(
      name: AppRoutes.CREATE_REFUELING_VIEW,
      page: () => CreateRefuelingView(),
      binding: CreateRefuelingBinding(),
    ),

    GetPage(
      name: AppRoutes.CREATE_EXPENSE_VIEW,
      page: () => CreateExpenseView(),
      binding: CreateExpenseBinding(),
    ),

    GetPage(
      name: AppRoutes.EXPENSE_TYPE_VIEW,
      page: () => ExpenseTypeView(),
      binding: ExpenseTypeBinding(),
    ),

    GetPage(
      name: AppRoutes.CRAETE_INCOME_VIEW,
      page: () => CreateIncomeView(),
      binding: CreateIncomeBinding(),
    ),

    GetPage(
      name: AppRoutes.CRAETE_SERVICE_VIEW,
      page: () => CreateServiceView(),
      binding: CreateServiceBinding(),
    ),

    GetPage(
      name: AppRoutes.SERVICE_TYPE_VIEW,
      page: () => ServiceTypeView(),
      binding: ServiceTypeBinding(),
    ),

    GetPage(
      name: AppRoutes.CRAETE_ROUTE_VIEW,
      page: () => CreateRouteView(),
      binding: CreateRouteBinding(),
    ),

    GetPage(
      name: AppRoutes.CREATE_REMINDER_VIEW,
      page: () => CreateReminderView(),
      binding: CreateReminderBinding(),
    ),

    GetPage(
      name: AppRoutes.MAP_VIEW,
      page: () => MapView(),
      binding: MapBindings(),
    ),
  ];
}

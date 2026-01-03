import 'package:drivvo/modules/admin/home/expense/create/create_expense_binding.dart';
import 'package:drivvo/modules/admin/home/expense/create/create_expense_view.dart';
import 'package:drivvo/modules/admin/home/expense/type/expense_type_binding.dart';
import 'package:drivvo/modules/admin/home/expense/type/expense_type_view.dart';
import 'package:drivvo/modules/admin/home/expense/update/update_expense_binding.dart';
import 'package:drivvo/modules/admin/home/expense/update/update_expense_view.dart';
import 'package:drivvo/modules/admin/home/filter/home_filter_binding.dart';
import 'package:drivvo/modules/admin/home/filter/home_filter_view.dart';
import 'package:drivvo/modules/admin/home/income/create/create_income_binding.dart';
import 'package:drivvo/modules/admin/home/income/create/create_income_view.dart';
import 'package:drivvo/modules/admin/home/income/update/update_income_binding.dart';
import 'package:drivvo/modules/admin/home/income/update/update_income_view.dart';
import 'package:drivvo/modules/admin/home/refueling/create/create_refueling_binding.dart';
import 'package:drivvo/modules/admin/home/refueling/create/create_refueling_view.dart';
import 'package:drivvo/modules/admin/home/refueling/update/update_refueling_binding.dart';
import 'package:drivvo/modules/admin/home/refueling/update/update_refueling_view.dart';
import 'package:drivvo/modules/admin/home/route/create/create_route_binding.dart';
import 'package:drivvo/modules/admin/home/route/create/create_route_view.dart';
import 'package:drivvo/modules/admin/home/route/update/update_route_binding.dart';
import 'package:drivvo/modules/admin/home/route/update/update_route_view.dart';
import 'package:drivvo/modules/admin/home/service/create/create_service_binding.dart';
import 'package:drivvo/modules/admin/home/service/create/create_service_view.dart';
import 'package:drivvo/modules/admin/home/service/type/service_type_binding.dart';
import 'package:drivvo/modules/admin/home/service/type/service_type_view.dart';
import 'package:drivvo/modules/admin/home/service/update/update_service_binding.dart';
import 'package:drivvo/modules/admin/home/service/update/update_service_view.dart';
import 'package:drivvo/modules/admin/more/about_us/about_us_bindings.dart';
import 'package:drivvo/modules/admin/more/about_us/about_us_view.dart';
import 'package:drivvo/modules/admin/more/general/create/create_general_bindings.dart';
import 'package:drivvo/modules/admin/more/general/create/create_general_view.dart';
import 'package:drivvo/modules/admin/more/general/general_bindings.dart';
import 'package:drivvo/modules/admin/more/general/general_view.dart';
import 'package:drivvo/modules/admin/more/plan/plan_bindings.dart';
import 'package:drivvo/modules/admin/more/plan/plan_view.dart';
import 'package:drivvo/modules/admin/more/user-vehicle/create/create_user_vehicle_bindings.dart';
import 'package:drivvo/modules/admin/more/user-vehicle/create/create_user_vehicle_view.dart';
import 'package:drivvo/modules/admin/more/user-vehicle/update/update_user_vehicle_bindings.dart';
import 'package:drivvo/modules/admin/more/user-vehicle/update/update_user_vehicle_view.dart';
import 'package:drivvo/modules/admin/more/user-vehicle/user_vehicle_bindings.dart';
import 'package:drivvo/modules/admin/more/user-vehicle/user_vehicle_view.dart';
import 'package:drivvo/modules/admin/more/user/create/create_user_bindings.dart';
import 'package:drivvo/modules/admin/more/user/create/create_user_view.dart';
import 'package:drivvo/modules/admin/more/user/update/update_user_bindings.dart';
import 'package:drivvo/modules/admin/more/user/update/update_user_view.dart';
import 'package:drivvo/modules/admin/more/user/user_bindings.dart';
import 'package:drivvo/modules/admin/more/user/user_view.dart';
import 'package:drivvo/modules/admin/more/vehicles/create/create_vehicles_bindings.dart';
import 'package:drivvo/modules/admin/more/vehicles/create/create_vehicles_view.dart';
import 'package:drivvo/modules/admin/more/vehicles/update/update_vehicles_bindings.dart';
import 'package:drivvo/modules/admin/more/vehicles/update/update_vehicles_view.dart';
import 'package:drivvo/modules/admin/more/vehicles/vehicles_bindings.dart';
import 'package:drivvo/modules/admin/more/vehicles/vehicles_view.dart';
import 'package:drivvo/modules/admin/reminder/create/create_reminder_binding.dart';
import 'package:drivvo/modules/admin/reminder/create/create_reminder_view.dart';
import 'package:drivvo/modules/admin/reminder/update/update_reminder_binding.dart';
import 'package:drivvo/modules/admin/reminder/update/update_reminder_view.dart';
import 'package:drivvo/modules/admin/root/admin_root_bindings.dart';
import 'package:drivvo/modules/admin/root/admin_root_view.dart';
import 'package:drivvo/modules/admin/setting/setting_bindings.dart';
import 'package:drivvo/modules/admin/setting/setting_view.dart';
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
import 'package:drivvo/modules/driver/root/driver_root_bindings.dart';
import 'package:drivvo/modules/driver/root/driver_root_view.dart';
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
      name: AppRoutes.ADMIN_ROOT_VIEW,
      page: () => const AdminRootView(),
      binding: AdminRootBindings(),
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
      name: AppRoutes.UPDATE_REFUELING_VIEW,
      page: () => const UpdateRefuelingView(),
      binding: UpdateRefuelingBinding(),
    ),

    GetPage(
      name: AppRoutes.CREATE_EXPENSE_VIEW,
      page: () => const CreateExpenseView(),
      binding: CreateExpenseBinding(),
    ),
    GetPage(
      name: AppRoutes.UPDATE_EXPENSE_VIEW,
      page: () => const UpdateExpenseView(),
      binding: UpdateExpenseBinding(),
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
      name: AppRoutes.UPDATE_INCOME_VIEW,
      page: () => const UpdateIncomeView(),
      binding: UpdateIncomeBinding(),
    ),

    GetPage(
      name: AppRoutes.CRAETE_SERVICE_VIEW,
      page: () => CreateServiceView(),
      binding: CreateServiceBinding(),
    ),
    GetPage(
      name: AppRoutes.UPDATE_SERVICE_VIEW,
      page: () => const UpdateServiceView(),
      binding: UpdateServiceBinding(),
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
      name: AppRoutes.UPDATE_ROUTE_VIEW,
      page: () => const UpdateRouteView(),
      binding: UpdateRouteBinding(),
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

    GetPage(
      name: AppRoutes.PLAN_VIEW,
      page: () => PlanView(),
      binding: PlanBindings(),
    ),

    GetPage(
      name: AppRoutes.UPDATE_VEHICLE_VIEW,
      page: () => UpdateVehiclesView(),
      binding: UpdateVehiclesBindings(),
    ),

    GetPage(
      name: AppRoutes.UPDATE_REMINDER_VIEW,
      page: () => UpdateReminderView(),
      binding: UpdateReminderBinding(),
    ),

    GetPage(
      name: AppRoutes.ABOUT_US_VIEW,
      page: () => AboutUsView(),
      binding: AboutUsBindings(),
    ),

    GetPage(
      name: AppRoutes.USER_VIEW,
      page: () => UserView(),
      binding: UserBindings(),
    ),

    GetPage(
      name: AppRoutes.CREATE_USER_VIEW,
      page: () => CreateUserView(),
      binding: CreateUserBindings(),
    ),

    GetPage(
      name: AppRoutes.UPDATE_USER_VIEW,
      page: () => const UpdateUserView(),
      binding: UpdateUserBindings(),
    ),

    GetPage(
      name: AppRoutes.USER_VEHICLE_VIEW,
      page: () => const UserVehicleView(),
      binding: UserVehicleBindings(),
    ),

    GetPage(
      name: AppRoutes.CREATE_USER_VEHICLE_VIEW,
      page: () => const CreateUserVehicleView(),
      binding: CreateUserVehicleBindings(),
    ),

    GetPage(
      name: AppRoutes.UPDATE_USER_VEHICLE_VIEW,
      page: () => const UpdateUserVehicleView(),
      binding: UpdateUserVehicleBindings(),
    ),

    GetPage(
      name: AppRoutes.DRIVER_ROOT_VIEW,
      page: () => const DriverRootView(),
      binding: DriverRootBindings(),
    ),
  ];
}

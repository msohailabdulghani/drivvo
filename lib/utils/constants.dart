class Constants {
  // ignore: constant_identifier_names
  static const String EXPENSE_TYPES = "expense_types";
  // ignore: constant_identifier_names
  static const String INCOME_TYPES = "income_types";
  // ignore: constant_identifier_names
  static const String SERVICE_TYPES = "service_types";
  // ignore: constant_identifier_names
  static const String PAYMENT_METHOD = "payment_methods";
  // ignore: constant_identifier_names
  static const String REASONS = "reasons";
  // ignore: constant_identifier_names
  static const String FUEL = "fuel";
  // ignore: constant_identifier_names
  static const String GAS_STATIONS = "gas_stations";
  // ignore: constant_identifier_names
  static const String PLACES = "places";

  // ignore: constant_identifier_names
  static const String CURRENT_VEHICLE_ID = "currentVehicleId";
  // ignore: constant_identifier_names
  static const String CURRENT_VEHICLE = "currentVehicle";
  // ignore: constant_identifier_names
  static const String DATE_FORMAT = "SelectedDateFormat";
  // ignore: constant_identifier_names
  static const String FUEL_UNIT = "FuelUnit";
  // ignore: constant_identifier_names
  static const String GAS_UNIT = "GasUnit";
  // ignore: constant_identifier_names
  static const String ONBOARDING = "Onboarding";
  // ignore: constant_identifier_names
  static const String ALL_VEHICLES_COUNT = "AllVehicleCount";
  // ignore: constant_identifier_names
  static const String USER_PROFILE = "UserProfile";
  // ignore: constant_identifier_names
  static const String Vehicle = "Vehicle";
  // ignore: constant_identifier_names
  static const String URDU_LANGUAGE_CODE = "ur";
  // ignore: constant_identifier_names
  static const String DEFAULT_LANGUAGE_CODE = "en";
  // ignore: constant_identifier_names
  static const String DEFAULT_COUNTRY_CODE = "US";
  // ignore: constant_identifier_names
  static const String LANGUAGE_CODE = "language_code";
  // ignore: constant_identifier_names
  static const String COUNTRY_CODE = "country_code";
  // ignore: constant_identifier_names
  static const String GOOGLE = "google";
  // ignore: constant_identifier_names
  static const String APPLE = "apple";
  // ignore: constant_identifier_names
  static const String EMAIL = "email";
  // ignore: constant_identifier_names
  static const String PASSWORD = "password";
  // ignore: constant_identifier_names
  static const String SELECTED_DATE_FORMAT = "SelectedDateFormat";
  // ignore: constant_identifier_names
  static const String REFUELING_FILTER = "RefuelingFilter";
  // ignore: constant_identifier_names
  static const String EXPENSE_FILTER = "ExpenseFilter";
  // ignore: constant_identifier_names
  static const String INCOME_FILTER = "IncomeFilter";
  // ignore: constant_identifier_names
  static const String SERVICE_FILTER = "ServiceFilter";
  // ignore: constant_identifier_names
  static const String ROUTE_FILTER = "RouteFilter";
  // ignore: constant_identifier_names
  static const String NOTIFICATION_TIME = "NotificationTime";

  // Currency Format Settings
  // ignore: constant_identifier_names
  static const String CURRENCY_SYMBOL = "CurrencySymbol";
  // ignore: constant_identifier_names
  static const String CURRENCY_CODE = "CurrencyCode";
  // ignore: constant_identifier_names
  static const String CURRENCY_FORMAT = "CurrencyFormat";
  // ignore: constant_identifier_names
  static const String CURRENCY_NAME = "CurrencyName";
  // ignore: constant_identifier_names
  static const String DRIVER = "driver";
  // ignore: constant_identifier_names
  static const String ADMIN = "admin";
  // ignore: constant_identifier_names
  static const String DRIVER_CURRENT_VEHICLE_ID = "driverCurrentVehicleId";
  // ignore: constant_identifier_names
  static const String DRIVER_CURRENT_VEHICLE = "driverCurrentVehicle";
  // ignore: constant_identifier_names
  static const String DRIVER_VEHICLE = "driverVehicle";

  /// Google Maps API Key - Used for Places API requests
  // ignore: constant_identifier_names
  // static const String GOOGLE_MAPS_API_KEY = "AIzaSyAexiJAGg7C3VbIr3QFtypZNVoQ4yFT8ug";
  // ignore: constant_identifier_names
  static const String GOOGLE_MAPS_API_KEY = String.fromEnvironment(
    'DRIVVO_GOOGLE_MAPS_API_KEY',
  );
}

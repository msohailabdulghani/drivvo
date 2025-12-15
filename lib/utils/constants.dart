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
  static const String ONBOARDING = "Onboarding";
  // ignore: constant_identifier_names
  static const String IMPORT_DATA = "ImportData";
  // ignore: constant_identifier_names
  static const String USER_PROFILE = "UserProfile";
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
  static const String SELECTED_DATE_FORMAT = "SelectedDateFormat";

  /// Google Maps API Key - Used for Places API requests
  // ignore: constant_identifier_names
  // static const String GOOGLE_MAPS_API_KEY = "AIzaSyAexiJAGg7C3VbIr3QFtypZNVoQ4yFT8ug";
  // ignore: constant_identifier_names
  static const String GOOGLE_MAPS_API_KEY = String.fromEnvironment(
    'DRIVVO_GOOGLE_MAPS_API_KEY',
  );
}

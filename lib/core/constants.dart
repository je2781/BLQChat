class AppConstants {
  static const String applicationId = String.fromEnvironment('application_id');
  static const String channelUrl = String.fromEnvironment('channnel_url');
  static const String baseUrl = "https://api-$applicationId.sendbird.com/v3/";
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String applicationId = dotenv.env['APPLICATION_ID']!;
  static String baseUrl = "https://api-$applicationId.sendbird.com/v3/";
}

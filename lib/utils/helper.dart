import 'constants.dart';

class Helper {
  static String getLanguageCodeByCountryCode(String countryCode) {
    return Constants.countries
        .firstWhere((el) => el['country_code'] == countryCode)['language_code'];
  }

  static String getTextTranslated(
    String key,
    String currentLanguageCode,
    Map<String, Map<String, String>> allTextStatic, {
    String? previousLanguageCode,
  }) {
    return allTextStatic[key]![currentLanguageCode] ??
        (allTextStatic[key]![previousLanguageCode] ??
            allTextStatic[key]!['en']!);
  }
}

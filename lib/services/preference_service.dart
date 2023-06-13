import 'package:shared_preferences/shared_preferences.dart';

class AppPreferenceService {
  SharedPreferences? _prefs;

  Future<void> initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    //workaround test to avoid nullPtrExn
    await Future.delayed(const Duration(milliseconds: 500));
    return;
  }

  static final _shared = AppPreferenceService._sharedInstance();

  AppPreferenceService._sharedInstance() {
    initPrefs();
  }

  factory AppPreferenceService() => _shared;

  Future<void> setUserId({required String userId}) async {
    final couldSet = await _prefs!.setString('userId', userId);
    if (!couldSet) {
      throw CouldNotSetPreferenceException();
    }
  }

  String getUserId() {
    final String value = _prefs!.get('userId') as String;
    return value;
  }

  bool get userNull {
    final value = _prefs!.get('userId');
    return value == null ? true : false;
  }
}

class CouldNotGetPreferenceException implements Exception {}

class CouldNotSetPreferenceException implements Exception {}

class PreferenceNotInitializedException implements Exception {}

import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferenceService {
  late SharedPreferences _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final _shared = AppPreferenceService._sharedInstance();

  AppPreferenceService._sharedInstance() {
    initPrefs();
  }

  factory AppPreferenceService() => _shared;

  Future<void> setUserId({required String userId}) async {
    final couldSet = await _prefs.setString('userId', userId);
    if (!couldSet) {
      throw CouldNotSetPreferenceException();
    }
  }

  String getUserId() {
    final String value = _prefs.get('userId') as String;
    return value;
  }

  bool get userNull {
    final value = _prefs.get('userId');
    return value == null ? true : false;
  }

  Future<void> setUserAvatar({required String assetName}) async {
    final couldSet = await _prefs.setString('userAvatar', assetName);
    if (!couldSet) {
      throw CouldNotSetPreferenceException();
    }
  }

  String getUserAvatar() {
    final String value = _prefs.get('userAvatar') as String;
    return value;
  }
}

class CouldNotGetPreferenceException implements Exception {}

class CouldNotSetPreferenceException implements Exception {}

class PreferenceNotInitializedException implements Exception {}

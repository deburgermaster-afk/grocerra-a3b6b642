import 'package:shared_preferences/shared_preferences.dart';

/// Persisted, device-local state for the pre-auth and location flow.
///
/// Only UI-local facts live here (onboarding completion, the chosen delivery
/// address). Identity and tokens belong to Supabase Auth.
abstract final class SessionStore {
  static const String _kOnboardingSeen = 'grocerra.onboarding_seen';
  static const String _kAddressLine = 'grocerra.address_line';
  static const String _kAddressUnit = 'grocerra.address_unit';
  static const String _kAddressNote = 'grocerra.address_note';
  static const String _kAddressLat = 'grocerra.address_lat';
  static const String _kAddressLng = 'grocerra.address_lng';
  static const String _kAddressSource = 'grocerra.address_source';

  static Future<bool> onboardingSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingSeen) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingSeen, true);
  }

  static Future<void> saveManualAddress({
    required String addressLine,
    String unit = '',
    String instructions = '',
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAddressLine, addressLine);
    await prefs.setString(_kAddressUnit, unit);
    await prefs.setString(_kAddressNote, instructions);
    await prefs.setString(_kAddressSource, 'manual');
    await prefs.remove(_kAddressLat);
    await prefs.remove(_kAddressLng);
  }

  static Future<void> saveCurrentLocation({
    required double latitude,
    required double longitude,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kAddressLat, latitude);
    await prefs.setDouble(_kAddressLng, longitude);
    await prefs.setString(_kAddressLine, 'Current location');
    await prefs.setString(_kAddressSource, 'gps');
  }

  /// The saved address line, or null when nothing has been chosen yet.
  static Future<String?> savedAddressLine() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAddressLine);
  }
}

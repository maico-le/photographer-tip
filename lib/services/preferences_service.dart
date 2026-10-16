import 'package:shared_preferences/shared_preferences.dart';
import '../theme/pixel_theme.dart';

class PreferencesService {
  static const _keyTheme = 'pixel_theme_v1';
  static const _keyFavorites = 'favorite_scenes_v1';
  static const _keyChecklist = 'checklist_completed_v1';
  static const _keyCityIndex = 'sun_city_index_v1';
  static const _keyCustomSR = 'custom_sr_v1';
  static const _keyCustomSS = 'custom_ss_v1';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  AppPixelTheme getTheme() {
    final val = _prefs.getString(_keyTheme);
    switch (val) {
      case 'mistralAmber':
        return AppPixelTheme.mistralAmber;
      case 'monochrom':
        return AppPixelTheme.monochrom;
      case 'cyberBlue':
        return AppPixelTheme.cyberBlue;
      case 'leicaRed':
      default:
        return AppPixelTheme.leicaRed;
    }
  }

  Future<void> setTheme(AppPixelTheme theme) async {
    await _prefs.setString(_keyTheme, theme.name.split('.').last);
  }

  Set<String> getFavorites() {
    final list = _prefs.getStringList(_keyFavorites) ?? [];
    return list.toSet();
  }

  Future<void> toggleFavorite(String sceneId) async {
    final current = getFavorites();
    if (current.contains(sceneId)) {
      current.remove(sceneId);
    } else {
      current.add(sceneId);
    }
    await _prefs.setStringList(_keyFavorites, current.toList());
  }

  Set<int> getChecklist() {
    final list = _prefs.getStringList(_keyChecklist) ?? [];
    return list.map((e) => int.tryParse(e) ?? 0).toSet();
  }

  Future<void> toggleChecklistItem(int index) async {
    final current = getChecklist();
    if (current.contains(index)) {
      current.remove(index);
    } else {
      current.add(index);
    }
    await _prefs.setStringList(
      _keyChecklist,
      current.map((e) => e.toString()).toList(),
    );
  }

  Future<void> resetChecklist() async {
    await _prefs.remove(_keyChecklist);
  }

  int getSelectedCityIndex() {
    return _prefs.getInt(_keyCityIndex) ?? 0;
  }

  Future<void> setSelectedCityIndex(int index) async {
    await _prefs.setInt(_keyCityIndex, index);
  }

  String? getCustomSR() => _prefs.getString(_keyCustomSR);
  String? getCustomSS() => _prefs.getString(_keyCustomSS);

  Future<void> setCustomSunTimes(String sr, String ss) async {
    await _prefs.setString(_keyCustomSR, sr);
    await _prefs.setString(_keyCustomSS, ss);
  }
}

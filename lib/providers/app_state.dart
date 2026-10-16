import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';
import '../theme/pixel_theme.dart';
import '../models/recipe_model.dart';
import '../data/recipes_data.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('preferencesServiceProvider must be overridden');
});

// App Theme State
final appThemeProvider = StateNotifierProvider<AppThemeNotifier, AppPixelTheme>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return AppThemeNotifier(prefs);
});

class AppThemeNotifier extends StateNotifier<AppPixelTheme> {
  final PreferencesService _prefs;

  AppThemeNotifier(this._prefs) : super(_prefs.getTheme());

  Future<void> changeTheme(AppPixelTheme theme) async {
    state = theme;
    await _prefs.setTheme(theme);
  }
}

// Favorites State
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return FavoritesNotifier(prefs);
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final PreferencesService _prefs;

  FavoritesNotifier(this._prefs) : super(_prefs.getFavorites());

  Future<void> toggle(String sceneId) async {
    await _prefs.toggleFavorite(sceneId);
    state = _prefs.getFavorites();
  }
}

// Checklist State
final checklistProvider = StateNotifierProvider<ChecklistNotifier, Set<int>>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return ChecklistNotifier(prefs);
});

class ChecklistNotifier extends StateNotifier<Set<int>> {
  final PreferencesService _prefs;

  ChecklistNotifier(this._prefs) : super(_prefs.getChecklist());

  Future<void> toggle(int index) async {
    await _prefs.toggleChecklistItem(index);
    state = _prefs.getChecklist();
  }

  Future<void> reset() async {
    await _prefs.resetChecklist();
    state = {};
  }
}

// Sun Calculator City & Time Model
class SunLocation {
  final String name;
  final TimeOfDay sunrise;
  final TimeOfDay sunset;

  const SunLocation({
    required this.name,
    required this.sunrise,
    required this.sunset,
  });
}

final sunLocations = <SunLocation>[
  const SunLocation(name: 'TP. Hồ Chí Minh', sunrise: TimeOfDay(hour: 5, minute: 35), sunset: TimeOfDay(hour: 17, minute: 35)),
  const SunLocation(name: 'Hà Nội', sunrise: TimeOfDay(hour: 5, minute: 48), sunset: TimeOfDay(hour: 17, minute: 32)),
  const SunLocation(name: 'Đà Nẵng / Hội An', sunrise: TimeOfDay(hour: 5, minute: 32), sunset: TimeOfDay(hour: 17, minute: 28)),
  const SunLocation(name: 'Đà Lạt', sunrise: TimeOfDay(hour: 5, minute: 36), sunset: TimeOfDay(hour: 17, minute: 30)),
  const SunLocation(name: 'Phú Quốc', sunrise: TimeOfDay(hour: 5, minute: 52), sunset: TimeOfDay(hour: 17, minute: 50)),
  const SunLocation(name: 'Sa Pa / Tây Bắc', sunrise: TimeOfDay(hour: 5, minute: 50), sunset: TimeOfDay(hour: 17, minute: 35)),
];

class CalculatedTimeframe {
  final TimeframeInfo info;
  final TimeOfDay start;
  final TimeOfDay end;
  final bool isCurrent;

  const CalculatedTimeframe({
    required this.info,
    required this.start,
    required this.end,
    required this.isCurrent,
  });

  String formatRange() {
    String p(int n) => n.toString().padLeft(2, '0');
    return '${p(start.hour)}:${p(start.minute)} - ${p(end.hour)}:${p(end.minute)}';
  }
}

class SunCalculatorState {
  final int cityIndex;
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final bool isCustom;

  const SunCalculatorState({
    required this.cityIndex,
    required this.sunrise,
    required this.sunset,
    required this.isCustom,
  });

  List<CalculatedTimeframe> calculateRanges() {
    final now = DateTime.now();
    final nowMins = now.hour * 60 + now.minute;

    TimeOfDay addMin(TimeOfDay base, int deltaMinutes) {
      final total = base.hour * 60 + base.minute + deltaMinutes;
      final clamped = (total % 1440 + 1440) % 1440;
      return TimeOfDay(hour: clamped ~/ 60, minute: clamped % 60);
    }

    final t1Start = addMin(sunrise, -40);
    final t1End = addMin(sunrise, -5);

    final t2Start = sunrise;
    final t2End = addMin(sunrise, 60);

    final t3Start = t2End;
    final t3End = const TimeOfDay(hour: 9, minute: 30);

    final t4Start = const TimeOfDay(hour: 9, minute: 30);
    final t4End = const TimeOfDay(hour: 15, minute: 0);

    final t5Start = const TimeOfDay(hour: 15, minute: 0);
    final t5End = addMin(sunset, -60);

    final t6Start = addMin(sunset, -60);
    final t6End = addMin(sunset, 5);

    final t7Start = addMin(sunset, 5);
    final t7End = addMin(sunset, 35);

    final t8Start = addMin(sunset, 40);
    final t8End = t1Start;

    bool checkCurrent(TimeOfDay s, TimeOfDay e) {
      final sm = s.hour * 60 + s.minute;
      final em = e.hour * 60 + e.minute;
      if (sm <= em) {
        return nowMins >= sm && nowMins < em;
      } else {
        // Crosses midnight
        return nowMins >= sm || nowMins < em;
      }
    }

    final pairs = [
      (TimeframeInfo.all[0], t1Start, t1End),
      (TimeframeInfo.all[1], t2Start, t2End),
      (TimeframeInfo.all[2], t3Start, t3End),
      (TimeframeInfo.all[3], t4Start, t4End),
      (TimeframeInfo.all[4], t5Start, t5End),
      (TimeframeInfo.all[5], t6Start, t6End),
      (TimeframeInfo.all[6], t7Start, t7End),
      (TimeframeInfo.all[7], t8Start, t8End),
    ];

    return pairs.map((p) {
      return CalculatedTimeframe(
        info: p.$1,
        start: p.$2,
        end: p.$3,
        isCurrent: checkCurrent(p.$2, p.$3),
      );
    }).toList();
  }
}

final sunCalculatorProvider = StateNotifierProvider<SunCalculatorNotifier, SunCalculatorState>((ref) {
  final prefs = ref.watch(preferencesServiceProvider);
  return SunCalculatorNotifier(prefs);
});

class SunCalculatorNotifier extends StateNotifier<SunCalculatorState> {
  final PreferencesService _prefs;

  SunCalculatorNotifier(this._prefs)
      : super(SunCalculatorState(
          cityIndex: _prefs.getSelectedCityIndex(),
          sunrise: sunLocations[_prefs.getSelectedCityIndex().clamp(0, sunLocations.length - 1)].sunrise,
          sunset: sunLocations[_prefs.getSelectedCityIndex().clamp(0, sunLocations.length - 1)].sunset,
          isCustom: false,
        ));

  void selectCity(int index) {
    if (index >= 0 && index < sunLocations.length) {
      _prefs.setSelectedCityIndex(index);
      state = SunCalculatorState(
        cityIndex: index,
        sunrise: sunLocations[index].sunrise,
        sunset: sunLocations[index].sunset,
        isCustom: false,
      );
    }
  }

  void setCustom(TimeOfDay sr, TimeOfDay ss) {
    state = SunCalculatorState(
      cityIndex: -1,
      sunrise: sr,
      sunset: ss,
      isCustom: true,
    );
  }
}

// Search and filter providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedTimeframeFilterProvider = StateProvider<String?>((ref) => null);
final selectedLensFilterProvider = StateProvider<String?>((ref) => null);
final onlyFavoritesFilterProvider = StateProvider<bool>((ref) => false);

final filteredScenesProvider = Provider<List<SceneModel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final tfFilter = ref.watch(selectedTimeframeFilterProvider);
  final lensFilter = ref.watch(selectedLensFilterProvider);
  final onlyFavs = ref.watch(onlyFavoritesFilterProvider);
  final favorites = ref.watch(favoritesProvider);

  return RecipesData.allScenes.where((scene) {
    if (onlyFavs && !favorites.contains(scene.id)) {
      return false;
    }

    if (query.isNotEmpty) {
      final matchTitle = scene.title.toLowerCase().contains(query);
      final matchSubtitle = scene.subtitle.toLowerCase().contains(query);
      final matchTip = scene.mainTip.toLowerCase().contains(query);
      final matchId = scene.id.toLowerCase() == query;
      final matchRecipe = scene.recipes.any((r) =>
          r.contextTitle.toLowerCase().contains(query) ||
          r.look.toLowerCase().contains(query) ||
          r.shooting.lens.toLowerCase().contains(query) ||
          (r.customNote?.toLowerCase().contains(query) ?? false));

      if (!matchTitle && !matchSubtitle && !matchTip && !matchId && !matchRecipe) {
        return false;
      }
    }

    if (tfFilter != null) {
      // Must have recipes in that timeframe or suitability not avoid
      final hasRecipe = scene.recipes.any((r) => r.timeframeCode == tfFilter);
      final suitability = scene.matrix[tfFilter]?.level;
      if (!hasRecipe && suitability == SuitabilityLevel.avoid) {
        return false;
      }
    }

    if (lensFilter != null) {
      final hasLens = scene.recipes.any((r) => r.shooting.lens.contains(lensFilter));
      if (!hasLens) {
        return false;
      }
    }

    return true;
  }).toList();
});

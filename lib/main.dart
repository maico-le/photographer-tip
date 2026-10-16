import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'services/preferences_service.dart';
import 'theme/pixel_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefsService = await PreferencesService.init();

  runApp(
    ProviderScope(
      overrides: [
        preferencesServiceProvider.overrideWithValue(prefsService),
      ],
      child: const LeicaRecipeApp(),
    ),
  );
}

class LeicaRecipeApp extends ConsumerWidget {
  const LeicaRecipeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(appThemeProvider);
    final themeData = PixelThemeData(theme: activeTheme);

    return MaterialApp(
      title: 'Leica Recipe Book - Xiaomi 17T',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: themeData.bg,
        cardColor: themeData.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeData.primary,
          primary: themeData.primary,
          secondary: themeData.secondary,
          surface: themeData.surface,
        ),
        fontFamily: 'monospace',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'monospace'),
          bodyLarge: TextStyle(fontFamily: 'monospace'),
          titleMedium: TextStyle(fontFamily: 'monospace'),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

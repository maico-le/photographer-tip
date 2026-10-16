import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photographer_tip/main.dart';
import 'package:photographer_tip/providers/app_state.dart';
import 'package:photographer_tip/services/preferences_service.dart';
import 'package:photographer_tip/data/recipes_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('RecipesData contains all 14 scenes with recipes', () {
    expect(RecipesData.allScenes.length, 14);

    final sceneIds = RecipesData.allScenes.map((s) => s.id).toList();
    expect(sceneIds, [
      'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7',
      'S8', 'S9', 'S10', 'S11', 'S12', 'S13', 'S14'
    ]);

    for (final scene in RecipesData.allScenes) {
      expect(scene.recipes.isNotEmpty, isTrue);
      expect(scene.matrix.length, 8); // T1 to T8
    }
  });

  testWidgets('LeicaRecipeApp smoke test and tabs navigation', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await PreferencesService.init();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider.overrideWithValue(prefs),
        ],
        child: const LeicaRecipeApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('LEICA RECIPES'), findsOneWidget);
    expect(find.text('CẨM NANG'), findsOneWidget);
    expect(find.text('MA TRẬN'), findsOneWidget);
    expect(find.text('GIỜ NẮNG'), findsOneWidget);
    expect(find.text('CHECKLIST'), findsOneWidget);

    // Verify Scene 1 Street is visible
    expect(find.text('Street'), findsOneWidget);

    // Tap Matrix tab
    await tester.tap(find.text('MA TRẬN'));
    await tester.pumpAndSettle();
    expect(find.text('MA TRẬN CẢNH × GIỜ'), findsOneWidget);

    // Tap Sun Calc tab
    await tester.tap(find.text('GIỜ NẮNG'));
    await tester.pumpAndSettle();
    expect(find.text('TÍNH GIỜ NẮNG & BLUE HOUR'), findsOneWidget);

    // Tap Checklist tab
    await tester.tap(find.text('CHECKLIST'));
    await tester.pumpAndSettle();
    expect(find.text('CHECKLIST & QUY ƯỚC'), findsOneWidget);
  });
}

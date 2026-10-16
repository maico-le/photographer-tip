import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/recipes_data.dart';
import '../models/recipe_model.dart';
import '../providers/app_state.dart';
import '../theme/pixel_theme.dart';
import '../widgets/pixel_icons.dart';
import '../widgets/pixel_widgets.dart';
import 'recipe_detail_screen.dart';

class MatrixScreen extends ConsumerWidget {
  const MatrixScreen({super.key});

  void _showCellDetails(BuildContext context, SceneModel scene, String tfCode, Suitability suit) {
    final tfInfo = TimeframeInfo.fromCode(tfCode);
    final hasRecipe = scene.recipes.any((r) => r.timeframeCode == tfCode);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
            border: Border(
              top: BorderSide(color: Color(0xFF141416), width: 2.5),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      PixelBadge(
                        label: scene.id,
                        backgroundColor: const Color(0xFFD9222A),
                        textColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${scene.title} × $tfCode',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF141416),
                        ),
                      ),
                    ],
                  ),
                  PixelBadge(
                    label: suit.label,
                    backgroundColor: suit.color,
                    textColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Khung giờ: ${tfInfo.name} (${tfInfo.period})',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF4A4D57),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Ánh sáng: ${tfInfo.lightChar}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Color(0xFF6B6E7B),
                ),
              ),
              const SizedBox(height: 12),
              if (suit.note != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    border: Border.all(color: const Color(0xFFF39C12), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text('💡 ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(
                          'Khuyến nghị: ${suit.note!}',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF704803),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              PixelButton(
                isPrimary: true,
                backgroundColor: const Color(0xFFD9222A),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(
                        scene: scene,
                        initialTimeframeCode: hasRecipe ? tfCode : null,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    hasRecipe
                        ? 'XEM CÔNG THỨC CHI TIẾT ($tfCode)'
                        : 'XEM CÁC CÔNG THỨC KHÁC CỦA ${scene.title.toUpperCase()}',
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);
    final themeData = PixelThemeData(theme: currentTheme);

    final timeframes = TimeframeInfo.all;
    final scenes = RecipesData.allScenes;

    return Scaffold(
      backgroundColor: themeData.bg,
      appBar: AppBar(
        backgroundColor: themeData.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFF141416), width: 2),
        ),
        title: const Row(
          children: [
            PixelIcon(PixelIconType.matrix, size: 18, color: Color(0xFFD9222A)),
            SizedBox(width: 8),
            Text(
              'MA TRẬN CẢNH × GIỜ',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF141416),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Legend Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFF141416), width: 1.5),
              ),
            ),
            child: const Wrap(
              spacing: 12,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _LegendBadge(symbol: '◎', label: 'Tốt nhất', color: Color(0xFF1EA858)),
                _LegendBadge(symbol: '○', label: 'Tốt', color: Color(0xFF2575FC)),
                _LegendBadge(symbol: '△', label: 'Tạm được', color: Color(0xFFF39C12)),
                _LegendBadge(symbol: '×', label: 'Nên tránh', color: Color(0xFFE74C3C)),
              ],
            ),
          ),

          // Matrix Interactive Grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF141416), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF141416),
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: const FixedColumnWidth(110),
                      for (int i = 1; i <= 8; i++) i: const FixedColumnWidth(48),
                    },
                    border: TableBorder.all(color: const Color(0xFFE0E0E0), width: 1),
                    children: [
                      // Header Row
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFF141416)),
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                            child: Text(
                              'CẢNH \\ GIỜ',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ...timeframes.map((tf) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                tf.code,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFAE19),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      // Scene Rows
                      ...scenes.map((scene) {
                        return TableRow(
                          decoration: BoxDecoration(
                            color: scenes.indexOf(scene) % 2 == 0 ? Colors.white : const Color(0xFFF9F9F7),
                          ),
                          children: [
                            // Scene Name Cell
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RecipeDetailScreen(scene: scene),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      scene.id,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFD9222A),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        scene.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF141416),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Timeframe Cells (T1..T8)
                            ...timeframes.map((tf) {
                              final suit = scene.matrix[tf.code] ?? const Suitability(SuitabilityLevel.fair);

                              return InkWell(
                                onTap: () => _showCellDetails(context, scene, tf.code, suit),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  color: suit.level == SuitabilityLevel.best
                                      ? const Color(0xFF1EA858).withValues(alpha: 0.12)
                                      : Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      suit.symbol,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: suit.color,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendBadge extends StatelessWidget {
  final String symbol;
  final String label;
  final Color color;

  const _LegendBadge({
    required this.symbol,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          symbol,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: Color(0xFF4A4D57),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

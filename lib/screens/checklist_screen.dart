import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/recipes_data.dart';
import '../models/recipe_model.dart';
import '../providers/app_state.dart';
import '../theme/pixel_theme.dart';
import '../widgets/pixel_icons.dart';
import '../widgets/pixel_widgets.dart';

class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);
    final themeData = PixelThemeData(theme: currentTheme);
    final checkedItems = ref.watch(checklistProvider);

    final totalItems = RecipesData.checklistItems.length;
    final completedCount = checkedItems.length;
    final isAllCompleted = completedCount == totalItems;

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
            PixelIcon(PixelIconType.check, size: 18, color: Color(0xFF1EA858)),
            SizedBox(width: 8),
            Text(
              'CHECKLIST & QUY ƯỚC',
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
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Checklist Card
          PixelCard(
            backgroundColor: themeData.surface,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        PixelIcon(PixelIconType.camera, size: 16, color: Color(0xFFD9222A)),
                        SizedBox(width: 6),
                        Text(
                          'CHECKLIST TRƯỚC MỖI BẤM MÁY',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF141416),
                          ),
                        ),
                      ],
                    ),
                    PixelBadge(
                      label: '$completedCount / $totalItems',
                      backgroundColor: isAllCompleted ? const Color(0xFF1EA858) : const Color(0xFF141416),
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Interactive checklist rows
                ...RecipesData.checklistItems.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final text = entry.value;
                  final isDone = checkedItems.contains(idx);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: () {
                        ref.read(checklistProvider.notifier).toggle(idx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDone ? const Color(0xFFEAF5EA) : Colors.white,
                          border: Border.all(
                            color: isDone ? const Color(0xFF1EA858) : const Color(0xFF141416),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: isDone ? const Color(0xFF1EA858) : Colors.white,
                                border: Border.all(color: const Color(0xFF141416), width: 1.5),
                              ),
                              child: isDone
                                  ? const Center(
                                      child: PixelIcon(PixelIconType.check, size: 12, color: Colors.white),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: isDone ? FontWeight.bold : FontWeight.w600,
                                  color: isDone ? const Color(0xFF0F5132) : const Color(0xFF141416),
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: PixelButton(
                    isSmall: true,
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFFE74C3C),
                    borderColor: const Color(0xFFE74C3C),
                    onPressed: () {
                      ref.read(checklistProvider.notifier).reset();
                    },
                    child: const Text('ĐẶT LẠI CHECKLIST'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Quy ước 0.1 & Base Card
          PixelCard(
            backgroundColor: themeData.surface,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    PixelIcon(PixelIconType.sliders, size: 16, color: Color(0xFF2575FC)),
                    SizedBox(width: 6),
                    Text(
                      'QUY ƯỚC & BASE ÁP CHO MỌI FILE RAW',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141416),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3EC),
                    border: Border.all(color: const Color(0xFF141416), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📸 TIÊU CỰ XIAOMI 17T (LEICA):',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF141416),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• 15mm: Góc siêu rộng (Ultrawide)\n• 23mm: Ống kính chính Leica Summilux\n• 115mm: Ống kính Tele tiềm vọng 5x',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: Color(0xFF4A4D57),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                ...RecipesData.conventionsBase.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('▫ ', style: TextStyle(color: Color(0xFFD9222A), fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: Color(0xFF141416),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Look Library Card (D1 to D11)
          PixelCard(
            backgroundColor: themeData.surface,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.palette, size: 16, color: Color(0xFFFFAE19)),
                    SizedBox(width: 6),
                    Text(
                      'BẢNG MÃ LOOK PHONG CÁCH (D1 - D11)',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141416),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...LookModel.all.map((look) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF141416), width: 1.2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: look.previewColor,
                            border: Border.all(color: const Color(0xFF141416), width: 1.2),
                          ),
                          child: Center(
                            child: Text(
                              look.code,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                look.title,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF141416),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Thích hợp: ${look.matchFor}',
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  color: Color(0xFF6B6E7B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

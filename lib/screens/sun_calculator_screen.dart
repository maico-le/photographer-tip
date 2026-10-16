import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/recipes_data.dart';
import '../models/recipe_model.dart';
import '../providers/app_state.dart';
import '../theme/pixel_theme.dart';
import '../widgets/pixel_icons.dart';
import '../widgets/pixel_widgets.dart';
import 'recipe_detail_screen.dart';

class SunCalculatorScreen extends ConsumerWidget {
  const SunCalculatorScreen({super.key});

  Future<void> _pickCustomTimes(BuildContext context, WidgetRef ref, SunCalculatorState state) async {
    final sr = await showTimePicker(
      context: context,
      initialTime: state.sunrise,
      helpText: 'CHỌN GIỜ MẶT TRỜI MỌC (SUNRISE - SR)',
    );
    if (sr == null || !context.mounted) return;

    final ss = await showTimePicker(
      context: context,
      initialTime: state.sunset,
      helpText: 'CHỌN GIỜ MẶT TRỜI LẶN (SUNSET - SS)',
    );
    if (ss == null) return;

    ref.read(sunCalculatorProvider.notifier).setCustom(sr, ss);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);
    final themeData = PixelThemeData(theme: currentTheme);
    final sunState = ref.watch(sunCalculatorProvider);
    final ranges = sunState.calculateRanges();

    final currentTf = ranges.firstWhere(
      (r) => r.isCurrent,
      orElse: () => ranges[1],
    );

    // Filter scenes that are best (◎) right now!
    final bestNowScenes = RecipesData.allScenes.where((s) {
      final suit = s.matrix[currentTf.info.code]?.level;
      return suit == SuitabilityLevel.best;
    }).toList();

    String p(int n) => n.toString().padLeft(2, '0');
    final srText = '${p(sunState.sunrise.hour)}:${p(sunState.sunrise.minute)}';
    final ssText = '${p(sunState.sunset.hour)}:${p(sunState.sunset.minute)}';

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
            PixelIcon(PixelIconType.sun, size: 18, color: Color(0xFFFFAE19)),
            SizedBox(width: 8),
            Text(
              'TÍNH GIỜ NẮNG & BLUE HOUR',
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
          // Realtime Live Status Banner
          PixelCard(
            backgroundColor: const Color(0xFF141416),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.radar, size: 16, color: Color(0xFF1EA858)),
                        SizedBox(width: 6),
                        Text(
                          'TRẠNG THÁI HIỆN TẠI',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1EA858),
                          ),
                        ),
                      ],
                    ),
                    PixelBadge(
                      label: currentTf.info.code,
                      backgroundColor: const Color(0xFFD9222A),
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentTf.info.name} (${currentTf.formatRange()})',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ánh sáng: ${currentTf.info.lightChar}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFFA0A4B2),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Location & Sunrise/Sunset Selector Card
          PixelCard(
            backgroundColor: themeData.surface,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    PixelIcon(PixelIconType.compass, size: 16, color: Color(0xFF2575FC)),
                    SizedBox(width: 6),
                    Text(
                      'ĐỊA ĐIỂM & GIỜ MẶT TRỜI (SR / SS)',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141416),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...List.generate(sunLocations.length, (idx) {
                      final isSelected = !sunState.isCustom && sunState.cityIndex == idx;
                      return PixelButton(
                        isSmall: true,
                        backgroundColor: isSelected ? themeData.primary : Colors.white,
                        textColor: isSelected ? Colors.white : const Color(0xFF141416),
                        onPressed: () {
                          ref.read(sunCalculatorProvider.notifier).selectCity(idx);
                        },
                        child: Text(sunLocations[idx].name),
                      );
                    }),
                    PixelButton(
                      isSmall: true,
                      backgroundColor: sunState.isCustom ? themeData.primary : Colors.white,
                      textColor: sunState.isCustom ? Colors.white : const Color(0xFF141416),
                      onPressed: () => _pickCustomTimes(context, ref, sunState),
                      child: Text(sunState.isCustom ? 'Tùy chỉnh: $srText-$ssText' : 'Tùy chỉnh...'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: const Color(0xFFF5F3EC),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSunTimeItem('Mặt trời mọc (SR)', srText, Icons.wb_sunny_outlined),
                      Container(width: 1.5, height: 24, color: const Color(0xFFDCD8CC)),
                      _buildSunTimeItem('Mặt trời lặn (SS)', ssText, Icons.nights_stay_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Recommended Scenes Right Now
          Row(
            children: [
              const Icon(Icons.stars, size: 16, color: Color(0xFF1EA858)),
              const SizedBox(width: 6),
              Text(
                'CẢNH ĐẸP NHẤT BÂY GIỜ (${currentTf.info.code}):',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF141416),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (bestNowScenes.isEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF141416), width: 1.5),
              ),
              child: const Text(
                'Khung giờ này nên tìm bóng râm hoặc chụp chi tiết bằng ống kính tele.',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Color(0xFF6B6E7B),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: bestNowScenes.map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(
                              scene: s,
                              initialTimeframeCode: currentTf.info.code,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF141416), width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF141416),
                              offset: Offset(2, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PixelIcon(s.icon, size: 16, color: themeData.primary),
                            const SizedBox(width: 6),
                            Text(
                              '${s.id} ${s.title}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF141416),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '◎',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1EA858),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 16),

          // Full Schedule Table (T1..T8)
          const Text(
            'LỊCH TRÌNH 8 KHUNG GIỜ TRONG NGÀY:',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF141416),
            ),
          ),
          const SizedBox(height: 8),

          Container(
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
            child: Column(
              children: ranges.map((r) {
                final isLast = ranges.last == r;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: r.isCurrent ? const Color(0xFFFFF9E6) : Colors.white,
                    border: isLast
                        ? null
                        : const Border(
                            bottom: BorderSide(color: Color(0xFFE8E9EC), width: 1.2),
                          ),
                  ),
                  child: Row(
                    children: [
                      PixelBadge(
                        label: r.info.code,
                        backgroundColor: r.isCurrent ? const Color(0xFFD9222A) : const Color(0xFF2B2C33),
                        textColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  r.info.name,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: r.isCurrent ? const Color(0xFFD9222A) : const Color(0xFF141416),
                                  ),
                                ),
                                Text(
                                  r.formatRange(),
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2575FC),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              r.info.period,
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
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 5 Tips Before Going Card
          PixelCard(
            backgroundColor: themeData.surface,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    PixelIcon(PixelIconType.info, size: 16, color: Color(0xFFD9222A)),
                    SizedBox(width: 6),
                    Text(
                      '5 MẸO TÌM GIỜ ĐẸP TRƯỚC KHI ĐI',
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
                ...RecipesData.tipsBeforeGoing.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${e.key + 1}. ',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD9222A),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.value,
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

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSunTimeItem(String label, String time, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFFF39C12)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Color(0xFF6B6E7B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF141416),
          ),
        ),
      ],
    );
  }
}

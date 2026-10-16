import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe_model.dart';
import '../providers/app_state.dart';
import '../theme/pixel_theme.dart';
import '../widgets/pixel_icons.dart';
import '../widgets/pixel_widgets.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final SceneModel scene;
  final String? initialTimeframeCode;

  const RecipeDetailScreen({
    super.key,
    required this.scene,
    this.initialTimeframeCode,
  });

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  late String _selectedTimeframe;

  @override
  void initState() {
    super.initState();
    if (widget.initialTimeframeCode != null &&
        widget.scene.recipes.any((r) => r.timeframeCode == widget.initialTimeframeCode)) {
      _selectedTimeframe = widget.initialTimeframeCode!;
    } else {
      _selectedTimeframe = widget.scene.recipes.first.timeframeCode;
    }
  }

  void _copyRecipe(SceneRecipe recipe) {
    final text = recipe.generateCopyText(widget.scene.title);
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF141416),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: Row(
          children: [
            const PixelIcon(PixelIconType.check, size: 16, color: Color(0xFF1EA858)),
            const SizedBox(width: 8),
            Text(
              'Đã sao chép công thức ${widget.scene.id} · $recipe.timeframeCode!',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(appThemeProvider);
    final themeData = PixelThemeData(theme: currentTheme);
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(widget.scene.id);

    final currentRecipe = widget.scene.recipes.firstWhere(
      (r) => r.timeframeCode == _selectedTimeframe,
      orElse: () => widget.scene.recipes.first,
    );

    return Scaffold(
      backgroundColor: themeData.bg,
      appBar: AppBar(
        backgroundColor: themeData.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFF141416), width: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF141416)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            PixelBadge(
              label: widget.scene.id,
              backgroundColor: themeData.primary,
              textColor: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              widget.scene.title,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF141416),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: PixelIcon(
              isFav ? PixelIconType.heartFilled : PixelIconType.heart,
              size: 20,
              color: isFav ? const Color(0xFFD9222A) : const Color(0xFF141416),
            ),
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggle(widget.scene.id);
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Scene Overview Header Card
          PixelCard(
            backgroundColor: themeData.surface,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: themeData.primary.withValues(alpha: 0.12),
                        border: Border.all(color: const Color(0xFF141416), width: 1.5),
                      ),
                      child: Center(
                        child: PixelIcon(widget.scene.icon, size: 24, color: themeData.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.scene.subtitle,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF141416),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 14, color: Color(0xFF6B6E7B)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Giờ đẹp: ${widget.scene.bestTime}',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: Color(0xFF4A4D57),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    border: Border.all(color: const Color(0xFFF39C12), width: 1.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💡 ', style: TextStyle(fontSize: 13)),
                      Expanded(
                        child: Text(
                          widget.scene.mainTip,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Color(0xFF704803),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Suitability mini matrix row
                const Text(
                  'MA TRẬN PHÙ HỢP CÁC KHUNG GIỜ:',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B6E7B),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: widget.scene.matrix.entries.map((e) {
                    final tf = e.key;
                    final suit = e.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: suit.color.withValues(alpha: 0.12),
                        border: Border.all(color: suit.color, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tf,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF141416),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            suit.symbol,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: suit.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Timeframe Tabs Selector
          const Text(
            'CHỌN KHUNG GIỜ CHỤP:',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF141416),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.scene.recipes.map((r) {
                final isSelected = r.timeframeCode == _selectedTimeframe;
                final tfInfo = TimeframeInfo.fromCode(r.timeframeCode);

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: PixelButton(
                    isSmall: true,
                    backgroundColor: isSelected ? themeData.primary : Colors.white,
                    textColor: isSelected ? Colors.white : const Color(0xFF141416),
                    onPressed: () {
                      setState(() {
                        _selectedTimeframe = r.timeframeCode;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PixelIcon(
                          tfInfo.iconType,
                          size: 14,
                          color: isSelected ? Colors.white : const Color(0xFF141416),
                        ),
                        const SizedBox(width: 6),
                        Text('${r.timeframeCode} · ${tfInfo.name}'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),

          // Context Title Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF141416),
              border: Border.all(color: const Color(0xFF141416), width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.wb_twilight, size: 16, color: Color(0xFFFFAE19)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentRecipe.contextTitle,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Section 1: Thông số Chụp (Shooting Specs)
          PixelCard(
            backgroundColor: themeData.surface,
            padding: const EdgeInsets.all(12),
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
                          'THÔNG SỐ CHỤP (PRO MODE RAW)',
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
                      label: currentRecipe.shooting.lens,
                      backgroundColor: const Color(0xFF2B2C33),
                      textColor: const Color(0xFFFFAE19),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(children: [
                      _buildSpecItem('ISO', currentRecipe.shooting.iso, Icons.exposure),
                      _buildSpecItem('TỐC ĐỘ', currentRecipe.shooting.shutter, Icons.speed),
                    ]),
                    TableRow(children: [
                      _buildSpecItem('WB KELVIN', currentRecipe.shooting.wb, Icons.thermostat),
                      _buildSpecItem('BÙ TRỪ EV', currentRecipe.shooting.ev, Icons.brightness_6),
                    ]),
                  ],
                ),
                if (currentRecipe.shooting.extraNote != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: const Color(0xFFF5F3EC),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 14, color: Color(0xFF2575FC)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Lưu ý: ${currentRecipe.shooting.extraNote!}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: Color(0xFF141416),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Section 2: Hậu kỳ Lightroom
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
                      'HẬU KỲ LIGHTROOM (L & C & E)',
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

                // L-Sliders
                PixelSliderBar(
                  label: 'Exp',
                  value: currentRecipe.light.exposure,
                  min: -2.0,
                  max: 2.0,
                  activeColor: const Color(0xFFF39C12),
                ),
                PixelSliderBar(
                  label: 'Contrast',
                  value: currentRecipe.light.contrast,
                  min: -50,
                  max: 50,
                  activeColor: const Color(0xFF383A42),
                ),
                PixelSliderBar(
                  label: 'Highlights',
                  value: currentRecipe.light.highlights,
                  min: -100,
                  max: 100,
                  activeColor: const Color(0xFF2575FC),
                ),
                PixelSliderBar(
                  label: 'Shadows',
                  value: currentRecipe.light.shadows,
                  min: -100,
                  max: 100,
                  activeColor: const Color(0xFF1EA858),
                ),
                PixelSliderBar(
                  label: 'Whites',
                  value: currentRecipe.light.whites,
                  min: -100,
                  max: 100,
                  activeColor: const Color(0xFF888B96),
                ),
                PixelSliderBar(
                  label: 'Blacks',
                  value: currentRecipe.light.blacks,
                  min: -100,
                  max: 100,
                  activeColor: const Color(0xFF141416),
                ),

                const Divider(height: 16, color: Color(0xFFE8E9EC), thickness: 1.5),

                // Color & HSL & Effects Info
                if (currentRecipe.color.formatSummary().trim() != 'C') ...[
                  _buildDetailRow('Màu (C)', currentRecipe.color.formatSummary().replaceFirst('C ', '')),
                ],
                if (currentRecipe.hsl != null) ...[
                  _buildDetailRow('HSL (H)', currentRecipe.hsl!),
                ],
                if (currentRecipe.effects != null) ...[
                  _buildDetailRow('Effects (E)', currentRecipe.effects!),
                ],
                if (currentRecipe.grading != null) ...[
                  _buildDetailRow('Grading (G)', currentRecipe.grading!),
                ],

                const SizedBox(height: 6),
                // Look Preset Card
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3EC),
                    border: Border.all(color: const Color(0xFF141416), width: 1.2),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Phong cách Look: ',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4D57),
                        ),
                      ),
                      PixelBadge(
                        label: currentRecipe.look,
                        backgroundColor: themeData.primary,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                if (currentRecipe.customNote != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5EA),
                      border: Border.all(color: const Color(0xFF1EA858), width: 1.2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡 ', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Text(
                            currentRecipe.customNote!,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: Color(0xFF0F5132),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Copy Recipe Button
          PixelButton(
            isPrimary: true,
            backgroundColor: themeData.primary,
            onPressed: () => _copyRecipe(currentRecipe),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PixelIcon(PixelIconType.copy, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text('SAO CHÉP CÔNG THỨC NÀY'),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF6B6E7B)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9,
                  color: Color(0xFF6B6E7B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF141416),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4D57),
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF141416),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe_model.dart';
import '../providers/app_state.dart';
import '../theme/pixel_theme.dart';
import '../widgets/pixel_icons.dart';
import '../widgets/pixel_widgets.dart';
import 'checklist_screen.dart';
import 'matrix_screen.dart';
import 'recipe_detail_screen.dart';
import 'settings_dialog.dart';
import 'sun_calculator_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(appThemeProvider);
    final themeData = PixelThemeData(theme: currentTheme);

    return Scaffold(
      backgroundColor: themeData.bg,
      appBar: AppBar(
        backgroundColor: themeData.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFF141416), width: 2),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/app_icon.png',
              width: 28,
              height: 28,
              filterQuality: FilterQuality.none, // Keep pixel art sharp!
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'LEICA RECIPES',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141416),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      color: const Color(0xFFD9222A),
                      child: const Text(
                        '17T',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Xiaomi 17T · Pro Mode RAW · Lightroom',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    color: Color(0xFF6B6E7B),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const PixelIcon(PixelIconType.settings, size: 20, color: Color(0xFF141416)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const SettingsDialog(),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildExplorerTab(themeData),
          const MatrixScreen(),
          const SunCalculatorScreen(),
          const ChecklistScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFF141416), width: 2),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              _buildBottomNavItem(
                index: 0,
                label: 'CẨM NANG',
                icon: PixelIconType.camera,
                themeData: themeData,
              ),
              _buildBottomNavItem(
                index: 1,
                label: 'MA TRẬN',
                icon: PixelIconType.matrix,
                themeData: themeData,
              ),
              _buildBottomNavItem(
                index: 2,
                label: 'GIỜ NẮNG',
                icon: PixelIconType.sun,
                themeData: themeData,
              ),
              _buildBottomNavItem(
                index: 3,
                label: 'CHECKLIST',
                icon: PixelIconType.check,
                themeData: themeData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required String label,
    required PixelIconType icon,
    required PixelThemeData themeData,
  }) {
    final isSelected = _currentTabIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: isSelected ? themeData.primary.withValues(alpha: 0.12) : Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PixelIcon(
                icon,
                size: 20,
                color: isSelected ? themeData.primary : const Color(0xFF6B6E7B),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? themeData.primary : const Color(0xFF6B6E7B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplorerTab(PixelThemeData themeData) {
    final scenes = ref.watch(filteredScenesProvider);
    final selectedTf = ref.watch(selectedTimeframeFilterProvider);
    final selectedLens = ref.watch(selectedLensFilterProvider);
    final onlyFavs = ref.watch(onlyFavoritesFilterProvider);
    final favorites = ref.watch(favoritesProvider);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Search Box
        PixelCard(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Row(
            children: [
              const PixelIcon(PixelIconType.search, size: 16, color: Color(0xFF6B6E7B)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    ref.read(searchQueryProvider.notifier).state = val;
                  },
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Color(0xFF141416),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm bối cảnh, tiêu cự, Look D1..',
                    hintStyle: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFFA0A4B2),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: Color(0xFF6B6E7B)),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Filter chips bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Favorites Toggle Chip
              PixelButton(
                isSmall: true,
                backgroundColor: onlyFavs ? const Color(0xFFD9222A) : Colors.white,
                textColor: onlyFavs ? Colors.white : const Color(0xFF141416),
                onPressed: () {
                  ref.read(onlyFavoritesFilterProvider.notifier).state = !onlyFavs;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PixelIcon(
                      onlyFavs ? PixelIconType.heartFilled : PixelIconType.heart,
                      size: 12,
                      color: onlyFavs ? Colors.white : const Color(0xFFD9222A),
                    ),
                    const SizedBox(width: 4),
                    const Text('Yêu thích'),
                  ],
                ),
              ),
              const SizedBox(width: 6),

              // Timeframe filter chips
              PixelButton(
                isSmall: true,
                backgroundColor: selectedTf == null ? themeData.primary : Colors.white,
                textColor: selectedTf == null ? Colors.white : const Color(0xFF141416),
                onPressed: () {
                  ref.read(selectedTimeframeFilterProvider.notifier).state = null;
                },
                child: const Text('Tất cả giờ'),
              ),
              const SizedBox(width: 6),

              ...TimeframeInfo.all.map((tf) {
                final isSelected = selectedTf == tf.code;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: PixelButton(
                    isSmall: true,
                    backgroundColor: isSelected ? themeData.primary : Colors.white,
                    textColor: isSelected ? Colors.white : const Color(0xFF141416),
                    onPressed: () {
                      ref.read(selectedTimeframeFilterProvider.notifier).state =
                          isSelected ? null : tf.code;
                    },
                    child: Text(tf.code),
                  ),
                );
              }),

              // Lens filter chips
              ...['15mm', '23mm', '115mm'].map((lens) {
                final isSelected = selectedLens == lens;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: PixelButton(
                    isSmall: true,
                    backgroundColor: isSelected ? const Color(0xFF2B2C33) : Colors.white,
                    textColor: isSelected ? const Color(0xFFFFAE19) : const Color(0xFF141416),
                    onPressed: () {
                      ref.read(selectedLensFilterProvider.notifier).state =
                          isSelected ? null : lens;
                    },
                    child: Text(lens),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Scenes Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DANH SÁCH BỐI CẢNH (${scenes.length}/14):',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF141416),
                letterSpacing: 0.5,
              ),
            ),
            if (selectedTf != null)
              PixelBadge(
                label: 'Lọc: $selectedTf',
                backgroundColor: themeData.primary,
                textColor: Colors.white,
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Scene Cards List
        if (scenes.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF141416), width: 2),
            ),
            child: const Center(
              child: Text(
                'Không tìm thấy công thức nào phù hợp với bộ lọc.',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF6B6E7B),
                ),
              ),
            ),
          )
        else
          ...scenes.map((scene) {
            final isFav = favorites.contains(scene.id);
            final activeSuit = selectedTf != null ? scene.matrix[selectedTf] : null;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: PixelCard(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(
                        scene: scene,
                        initialTimeframeCode: selectedTf,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: themeData.primary.withValues(alpha: 0.12),
                            border: Border.all(color: const Color(0xFF141416), width: 1.5),
                          ),
                          child: Center(
                            child: PixelIcon(scene.icon, size: 20, color: themeData.primary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  PixelBadge(
                                    label: scene.id,
                                    backgroundColor: themeData.primary,
                                    textColor: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      scene.title,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF141416),
                                      ),
                                    ),
                                  ),
                                  if (activeSuit != null)
                                    PixelBadge(
                                      label: activeSuit.label,
                                      backgroundColor: activeSuit.color,
                                      textColor: Colors.white,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                scene.subtitle,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: Color(0xFF4A4D57),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: PixelIcon(
                            isFav ? PixelIconType.heartFilled : PixelIconType.heart,
                            size: 16,
                            color: isFav ? const Color(0xFFD9222A) : const Color(0xFFB0B4C0),
                          ),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggle(scene.id);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: Color(0xFF6B6E7B)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Giờ vàng: ${scene.bestTime}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              color: Color(0xFF6B6E7B),
                            ),
                          ),
                        ),
                        PixelBadge(
                          label: '${scene.recipes.length} công thức',
                          backgroundColor: const Color(0xFFF5F3EC),
                          textColor: const Color(0xFF141416),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

        const SizedBox(height: 20),
      ],
    );
  }
}

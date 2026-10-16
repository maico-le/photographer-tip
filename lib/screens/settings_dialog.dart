import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state.dart';
import '../theme/pixel_theme.dart';
import '../widgets/pixel_icons.dart';
import '../widgets/pixel_widgets.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(appThemeProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: PixelCard(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    PixelIcon(PixelIconType.settings, size: 18, color: Color(0xFF141416)),
                    SizedBox(width: 8),
                    Text(
                      'CÀI ĐẶT & GIAO DIỆN',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141416),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            const Text(
              'BẢNG MÀU RETRO PIXEL:',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B6E7B),
              ),
            ),
            const SizedBox(height: 8),

            ...AppPixelTheme.values.map((t) {
              final isSelected = t == currentTheme;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () {
                    ref.read(appThemeProvider.notifier).changeTheme(t);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? t.primary.withValues(alpha: 0.12) : Colors.white,
                      border: Border.all(
                        color: isSelected ? t.primary : const Color(0xFF141416),
                        width: isSelected ? 2 : 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: t.primary,
                            border: Border.all(color: const Color(0xFF141416), width: 1.2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            t.name,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: const Color(0xFF141416),
                            ),
                          ),
                        ),
                        if (isSelected)
                          const PixelIcon(PixelIconType.check, size: 14, color: Color(0xFF1EA858)),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 14),
            const Divider(color: Color(0xFFE8E9EC), thickness: 1.5),
            const SizedBox(height: 8),

            const Text(
              'THÔNG TIN ỨNG DỤNG:',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B6E7B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '• Sổ tay 2: Công thức theo cảnh × khung giờ trong ngày\n• Thiết bị mục tiêu: Xiaomi 17T (Leica Pro RAW)\n• Hậu kỳ: Adobe Lightroom Mobile / Classic\n• Mã nguồn: maico-le/photographer-tip',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                color: Color(0xFF4A4D57),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),
            PixelButton(
              isSmall: true,
              backgroundColor: const Color(0xFF141416),
              textColor: Colors.white,
              onPressed: () => Navigator.pop(context),
              child: const Center(child: Text('ĐÓNG')),
            ),
          ],
        ),
      ),
    );
  }
}

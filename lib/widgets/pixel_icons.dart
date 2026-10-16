import 'package:flutter/material.dart';

enum PixelIconType {
  camera,
  sun,
  sunset,
  moon,
  mountain,
  beach,
  forest,
  field,
  water,
  city,
  temple,
  coffee,
  flower,
  road,
  portrait,
  cloud,
  check,
  search,
  copy,
  settings,
  heart,
  heartFilled,
  matrix,
  sliders,
  compass,
  info,
}

class PixelIcon extends StatelessWidget {
  final PixelIconType type;
  final double size;
  final Color? color;

  const PixelIcon(
    this.type, {
    super.key,
    this.size = 20.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? IconTheme.of(context).color ?? Colors.black;

    return CustomPaint(
      size: Size(size, size),
      painter: _PixelIconPainter(type: type, color: effectiveColor),
    );
  }
}

class _PixelIconPainter extends CustomPainter {
  final PixelIconType type;
  final Color color;

  _PixelIconPainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const grid = 16;
    final px = size.width / grid;

    void dot(int x, int y) {
      if (x >= 0 && x < grid && y >= 0 && y < grid) {
        canvas.drawRect(Rect.fromLTWH(x * px, y * px, px, px), paint);
      }
    }

    void block(int x1, int y1, int x2, int y2) {
      for (int y = y1; y <= y2; y++) {
        for (int x = x1; x <= x2; x++) {
          dot(x, y);
        }
      }
    }

    switch (type) {
      case PixelIconType.camera:
        // Top plate
        block(6, 2, 9, 3);
        block(2, 4, 13, 13);
        // Lens hole
        for (int y = 6; y <= 11; y++) {
          for (int x = 5; x <= 10; x++) {
            if ((x == 5 || x == 10) && (y == 6 || y == 11)) continue;
            // Leave hole or draw ring
          }
        }
        // Red dot placeholder or lens center
        dot(3, 6); // red dot position
        block(6, 7, 9, 10);
        break;

      case PixelIconType.sun:
        block(6, 6, 9, 9);
        // Rays
        dot(7, 2); dot(8, 2);
        dot(7, 13); dot(8, 13);
        dot(2, 7); dot(2, 8);
        dot(13, 7); dot(13, 8);
        dot(4, 4); dot(11, 4);
        dot(4, 11); dot(11, 11);
        break;

      case PixelIconType.sunset:
        // Horizon
        block(2, 11, 13, 12);
        // Half sun
        block(6, 6, 9, 10);
        dot(5, 8); dot(5, 9);
        dot(10, 8); dot(10, 9);
        // Rays
        dot(7, 3); dot(8, 3);
        dot(3, 6); dot(12, 6);
        break;

      case PixelIconType.moon:
        // Crescent
        block(4, 3, 10, 12);
        // Erase center
        break;

      case PixelIconType.mountain:
        // Peak 1
        dot(6, 4);
        block(5, 5, 7, 6);
        block(4, 7, 8, 8);
        block(3, 9, 9, 11);
        // Peak 2
        dot(11, 7);
        block(10, 8, 12, 9);
        block(9, 10, 13, 11);
        block(2, 12, 14, 13);
        break;

      case PixelIconType.beach:
        // Waves
        block(2, 11, 5, 12);
        block(7, 11, 10, 12);
        block(12, 11, 14, 12);
        // Umbrella or palm
        block(7, 4, 9, 5);
        block(5, 6, 11, 6);
        block(7, 7, 9, 10);
        break;

      case PixelIconType.forest:
        // Tree 1
        dot(7, 2);
        block(6, 3, 8, 4);
        block(5, 5, 9, 7);
        block(4, 8, 10, 10);
        block(7, 11, 8, 13);
        break;

      case PixelIconType.field:
        // Furrows / rice lines
        block(2, 5, 13, 6);
        block(2, 8, 13, 9);
        block(2, 11, 13, 12);
        dot(5, 3); dot(9, 3);
        break;

      case PixelIconType.water:
        // Water ripples
        block(2, 4, 6, 5);
        block(9, 4, 13, 5);
        block(5, 7, 11, 8);
        block(2, 10, 7, 11);
        block(10, 10, 14, 11);
        break;

      case PixelIconType.city:
        // Buildings
        block(3, 6, 6, 13);
        block(7, 3, 10, 13);
        block(11, 8, 13, 13);
        // Spire
        dot(8, 2);
        break;

      case PixelIconType.temple:
        // Pagoda tiers
        block(6, 2, 9, 3);
        block(4, 4, 11, 5);
        block(3, 6, 12, 7);
        block(5, 8, 10, 13);
        block(2, 13, 13, 14);
        break;

      case PixelIconType.coffee:
        // Cup
        block(4, 6, 11, 11);
        block(5, 12, 10, 12);
        // Handle
        dot(12, 7); dot(12, 8); dot(12, 9);
        // Steam
        dot(6, 3); dot(7, 4);
        dot(9, 3); dot(8, 4);
        break;

      case PixelIconType.flower:
        // Petals
        block(7, 4, 8, 5);
        block(7, 9, 8, 10);
        block(4, 6, 5, 7);
        block(10, 6, 11, 7);
        // Center
        block(6, 6, 9, 7);
        // Stem
        block(7, 11, 8, 13);
        break;

      case PixelIconType.road:
        // Perspective road
        dot(6, 3); dot(9, 3);
        block(5, 4, 6, 5); block(9, 4, 10, 5);
        block(4, 6, 5, 8); block(10, 6, 11, 8);
        block(3, 9, 4, 13); block(11, 9, 12, 13);
        // Dashed center line
        block(7, 4, 8, 5);
        block(7, 8, 8, 9);
        block(7, 11, 8, 13);
        break;

      case PixelIconType.portrait:
        // Head
        block(6, 3, 9, 6);
        // Neck
        block(7, 7, 8, 8);
        // Shoulders
        block(4, 9, 11, 13);
        break;

      case PixelIconType.cloud:
        block(5, 5, 10, 6);
        block(3, 7, 12, 10);
        block(2, 9, 13, 11);
        break;

      case PixelIconType.check:
        dot(4, 8); dot(5, 9); dot(6, 10);
        dot(7, 9); dot(8, 8); dot(9, 7); dot(10, 6); dot(11, 5);
        // Thicken
        dot(4, 7); dot(5, 8); dot(6, 9); dot(7, 8); dot(8, 7); dot(9, 6);
        break;

      case PixelIconType.search:
        block(4, 3, 9, 8);
        // Handle
        dot(10, 9); dot(11, 10); dot(12, 11); dot(13, 12);
        break;

      case PixelIconType.copy:
        // Back card
        block(5, 2, 13, 9);
        // Front card
        block(2, 5, 10, 13);
        break;

      case PixelIconType.settings:
        block(6, 6, 9, 9);
        // Cogs
        dot(7, 2); dot(8, 2);
        dot(7, 13); dot(8, 13);
        dot(2, 7); dot(2, 8);
        dot(13, 7); dot(13, 8);
        dot(4, 4); dot(11, 4);
        dot(4, 11); dot(11, 11);
        break;

      case PixelIconType.heart:
      case PixelIconType.heartFilled:
        block(3, 4, 6, 7);
        block(9, 4, 12, 7);
        block(4, 8, 11, 10);
        block(6, 11, 9, 12);
        dot(7, 13); dot(8, 13);
        break;

      case PixelIconType.matrix:
        // 3x3 pixel grid
        block(3, 3, 5, 5);
        block(7, 3, 9, 5);
        block(11, 3, 13, 5);
        block(3, 7, 5, 9);
        block(7, 7, 9, 9);
        block(11, 7, 13, 9);
        block(3, 11, 5, 13);
        block(7, 11, 9, 13);
        block(11, 11, 13, 13);
        break;

      case PixelIconType.sliders:
        // Slider rails
        block(4, 2, 4, 13);
        block(8, 2, 8, 13);
        block(12, 2, 12, 13);
        // Knobs
        block(3, 4, 5, 6);
        block(7, 8, 9, 10);
        block(11, 5, 13, 7);
        break;

      case PixelIconType.compass:
        block(4, 4, 11, 11);
        dot(7, 2); dot(8, 2);
        dot(7, 13); dot(8, 13);
        dot(2, 7); dot(2, 8);
        dot(13, 7); dot(13, 8);
        // Needle
        dot(7, 5); dot(8, 5);
        dot(7, 10); dot(8, 10);
        break;

      case PixelIconType.info:
        block(7, 3, 8, 4);
        block(7, 6, 8, 12);
        block(6, 12, 9, 12);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PixelIconPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}

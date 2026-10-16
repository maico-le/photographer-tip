import 'package:flutter/material.dart';
import '../widgets/pixel_icons.dart';

enum TimeframeId {
  t1, t2, t3, t4, t5, t6, t7, t8
}

class TimeframeInfo {
  final TimeframeId id;
  final String code; // T1..T8
  final String name; // Blue hour sáng
  final String period; // SR - 40 đến SR - 5 phút
  final String lightChar; // Mềm, xanh lạnh, ít người, tương phản thấp
  final PixelIconType iconType;

  const TimeframeInfo({
    required this.id,
    required this.code,
    required this.name,
    required this.period,
    required this.lightChar,
    required this.iconType,
  });

  static const List<TimeframeInfo> all = [
    TimeframeInfo(
      id: TimeframeId.t1,
      code: 'T1',
      name: 'Blue hour sáng',
      period: 'SR − 40 đến SR − 5 phút',
      lightChar: 'Mềm, xanh lạnh, ít người, tương phản thấp',
      iconType: PixelIconType.moon,
    ),
    TimeframeInfo(
      id: TimeframeId.t2,
      code: 'T2',
      name: 'Golden hour sáng',
      period: 'SR đến SR + 60 phút',
      lightChar: 'Ấm, thấp, bóng dài, thường có sương',
      iconType: PixelIconType.sunset,
    ),
    TimeframeInfo(
      id: TimeframeId.t3,
      code: 'T3',
      name: 'Sáng muộn',
      period: 'SR + 1h đến khoảng 9:30',
      lightChar: 'Sạch, trung tính, góc nắng còn đẹp',
      iconType: PixelIconType.sun,
    ),
    TimeframeInfo(
      id: TimeframeId.t4,
      code: 'T4',
      name: 'Trưa gắt',
      period: 'Khoảng 9:30 đến 15:00',
      lightChar: 'Nắng đứng đầu, bóng cứng, màu phẳng (chụp đen trắng / bóng râm)',
      iconType: PixelIconType.sun,
    ),
    TimeframeInfo(
      id: TimeframeId.t5,
      code: 'T5',
      name: 'Chiều',
      period: 'Khoảng 15:00 đến SS − 60 phút',
      lightChar: 'Nắng xiên trở lại, ấm dần, nổi khối địa hình',
      iconType: PixelIconType.sun,
    ),
    TimeframeInfo(
      id: TimeframeId.t6,
      code: 'T6',
      name: 'Golden hour chiều / hoàng hôn',
      period: 'SS − 60 phút đến SS + 5 phút',
      lightChar: 'Ấm, thấp, màu bầu trời mạnh, ngược sáng rim light',
      iconType: PixelIconType.sunset,
    ),
    TimeframeInfo(
      id: TimeframeId.t7,
      code: 'T7',
      name: 'Blue hour tối',
      period: 'SS + 5 đến SS + 35 phút',
      lightChar: 'Trời xanh đậm, đèn thành phố bắt đầu bật',
      iconType: PixelIconType.moon,
    ),
    TimeframeInfo(
      id: TimeframeId.t8,
      code: 'T8',
      name: 'Đêm',
      period: 'Từ SS + 40 phút',
      lightChar: 'Đèn nhân tạo, neon, đường ướt, tương phản đêm',
      iconType: PixelIconType.moon,
    ),
  ];

  static TimeframeInfo fromCode(String code) {
    return all.firstWhere(
      (t) => t.code == code,
      orElse: () => all[1],
    );
  }
}

enum SuitabilityLevel {
  best,   // ◎
  good,   // ○
  fair,   // △
  avoid,  // ×
}

class Suitability {
  final SuitabilityLevel level;
  final String? note;

  const Suitability(this.level, [this.note]);

  String get symbol {
    switch (level) {
      case SuitabilityLevel.best:
        return '◎';
      case SuitabilityLevel.good:
        return '○';
      case SuitabilityLevel.fair:
        return '△';
      case SuitabilityLevel.avoid:
        return '×';
    }
  }

  String get label {
    final s = symbol;
    if (note != null && note!.isNotEmpty) {
      return '$s ($note)';
    }
    switch (level) {
      case SuitabilityLevel.best:
        return '◎ Tốt nhất';
      case SuitabilityLevel.good:
        return '○ Tốt';
      case SuitabilityLevel.fair:
        return '△ Tạm được';
      case SuitabilityLevel.avoid:
        return '× Nên tránh';
    }
  }

  Color get color {
    switch (level) {
      case SuitabilityLevel.best:
        return const Color(0xFF1EA858);
      case SuitabilityLevel.good:
        return const Color(0xFF2575FC);
      case SuitabilityLevel.fair:
        return const Color(0xFFF39C12);
      case SuitabilityLevel.avoid:
        return const Color(0xFFE74C3C);
    }
  }
}

class ShootingParams {
  final String lens;        // 15mm / 23mm / 115mm
  final String iso;         // 50-200
  final String shutter;     // 1/250-1/500
  final String wb;          // 5300K
  final String ev;          // −0.3
  final String? extraNote;  // tựa vật cố định / đo mặt

  const ShootingParams({
    required this.lens,
    required this.iso,
    required this.shutter,
    required this.wb,
    required this.ev,
    this.extraNote,
  });

  String formatSummary() {
    final buf = StringBuffer();
    buf.write('$lens · ISO $iso · $shutter · WB $wb · EV $ev');
    if (extraNote != null) {
      buf.write(' · $extraNote');
    }
    return buf.toString();
  }
}

class PostLight {
  final double exposure;
  final double contrast;
  final double highlights;
  final double shadows;
  final double whites;
  final double blacks;

  const PostLight({
    this.exposure = 0.0,
    this.contrast = 0.0,
    this.highlights = 0.0,
    this.shadows = 0.0,
    this.whites = 0.0,
    this.blacks = 0.0,
  });

  String formatSummary() {
    String f(double v) => v > 0 ? '+$v' : (v == 0 ? '0' : '$v');
    return 'L ${f(exposure)}/${f(contrast)}/${f(highlights)}/${f(shadows)}/${f(whites)}/${f(blacks)}';
  }
}

class PostColor {
  final String? temp; // ấm+4, lạnh-6...
  final double? tint;
  final double vibrance;
  final double saturation;

  const PostColor({
    this.temp,
    this.tint,
    this.vibrance = 0,
    this.saturation = 0,
  });

  String formatSummary() {
    final parts = <String>[];
    if (temp != null) parts.add(temp!);
    if (tint != null) parts.add('Tint${tint! > 0 ? '+$tint' : '$tint'}');
    if (vibrance != 0) parts.add('Vib${vibrance > 0 ? '+$vibrance' : '$vibrance'}');
    if (saturation != 0) parts.add('Sat${saturation > 0 ? '+$saturation' : '$saturation'}');
    return 'C ${parts.join(' ')}';
  }
}

class SceneRecipe {
  final String timeframeCode; // T1..T8
  final String contextTitle;  // Sáng sớm (phố ăn sáng, người tập thể dục, khói bếp)
  final ShootingParams shooting;
  final PostLight light;
  final PostColor color;
  final String? hsl;          // Cam S+6, Lam S-8...
  final String? effects;      // Deh+5 Gr10 Vig-8
  final String? grading;      // Sh H215 S8 Hi H45 S8
  final String look;          // D4/D8
  final String? customNote;

  const SceneRecipe({
    required this.timeframeCode,
    required this.contextTitle,
    required this.shooting,
    required this.light,
    required this.color,
    this.hsl,
    this.effects,
    this.grading,
    required this.look,
    this.customNote,
  });

  String generateCopyText(String sceneName) {
    final sb = StringBuffer();
    sb.writeln('[$sceneName - $timeframeCode]');
    sb.writeln('📍 Bối cảnh: $contextTitle');
    sb.writeln('📷 Chụp: ${shooting.formatSummary()}');
    sb.writeln('🎨 Hậu kỳ:');
    sb.writeln('  • ${light.formatSummary()}');
    if (color.formatSummary().trim() != 'C') {
      sb.writeln('  • ${color.formatSummary()}');
    }
    if (hsl != null) sb.writeln('  • H: $hsl');
    if (effects != null) sb.writeln('  • E: $effects');
    if (grading != null) sb.writeln('  • G: $grading');
    sb.writeln('  • Look: $look');
    if (customNote != null) sb.writeln('💡 Mẹo: $customNote');
    return sb.toString();
  }
}

class SceneModel {
  final String id;          // S1..S14
  final String title;       // Street
  final String subtitle;    // phố, sinh hoạt
  final PixelIconType icon;
  final String bestTime;    // T2 và T6 (bóng dài, ánh ấm), T8 (neon)
  final String mainTip;     // Đặt trước focus ở 2-3m...
  final Map<String, Suitability> matrix; // T1 -> Suitability
  final List<SceneRecipe> recipes;

  const SceneModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bestTime,
    required this.mainTip,
    required this.matrix,
    required this.recipes,
  });
}

class LookModel {
  final String code;        // D1..D11
  final String title;       // Đen trắng kiểu Leica Monochrom
  final String matchFor;    // Street, kiến trúc, trưa gắt
  final Color previewColor;

  const LookModel({
    required this.code,
    required this.title,
    required this.matchFor,
    required this.previewColor,
  });

  static const List<LookModel> all = [
    LookModel(
      code: 'D1',
      title: 'Đen trắng kiểu Leica Monochrom (tương phản cao, đen sâu)',
      matchFor: 'Street, kiến trúc, trưa gắt',
      previewColor: Color(0xFF1E1E22),
    ),
    LookModel(
      code: 'D2',
      title: 'Đen trắng hạt thô (kiểu Tri-X)',
      matchFor: 'Street, mây giông',
      previewColor: Color(0xFF383A42),
    ),
    LookModel(
      code: 'D3',
      title: 'Đen trắng mềm, matte',
      matchFor: 'Chân dung, tĩnh vật',
      previewColor: Color(0xFF6B6E7B),
    ),
    LookModel(
      code: 'D4',
      title: 'Tông phim ấm, da đẹp (kiểu Portra)',
      matchFor: 'Chân dung, golden hour',
      previewColor: Color(0xFFDE8D5D),
    ),
    LookModel(
      code: 'D5',
      title: 'Nostalgia vàng (kiểu Gold 200)',
      matchFor: 'Nắng nhẹ, du lịch, ẩm thực',
      previewColor: Color(0xFFE5A638),
    ),
    LookModel(
      code: 'D6',
      title: 'Màu rực rỡ phong cảnh (kiểu Velvia)',
      matchFor: 'Biển, núi, bầu trời',
      previewColor: Color(0xFF1D87E4),
    ),
    LookModel(
      code: 'D7',
      title: 'Đêm kiểu vonfram có halation (kiểu Cinestill 800T)',
      matchFor: 'Neon, đèn đêm',
      previewColor: Color(0xFFD63031),
    ),
    LookModel(
      code: 'D8',
      title: 'Leica Classic, màu trầm',
      matchFor: 'Street, kiến trúc, ánh sáng gắt',
      previewColor: Color(0xFF8B0000),
    ),
    LookModel(
      code: 'D9',
      title: 'Faded matte',
      matchFor: 'Sương, lifestyle',
      previewColor: Color(0xFF9EA392),
    ),
    LookModel(
      code: 'D10',
      title: 'Teal-orange điện ảnh',
      matchFor: 'Hoàng hôn, thành phố',
      previewColor: Color(0xFF009688),
    ),
    LookModel(
      code: 'D11',
      title: 'Màu đậm kiểu slide cổ điển (kiểu Kodachrome)',
      matchFor: 'Thiên nhiên, đồng quê',
      previewColor: Color(0xFFC0392B),
    ),
  ];
}

import os
from PIL import Image, ImageDraw

def generate_pixel_camera_icon():
    # Grid size for authentic retro pixel art: 32x32 pixel matrix
    GRID = 32
    img = Image.new("RGBA", (GRID, GRID), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Palette
    BG_CARD = (26, 26, 30, 255)       # Dark retro body / chassis
    BORDER = (10, 10, 12, 255)         # Deep black pixel border
    SILVER_TOP = (210, 214, 222, 255) # Leica classic brushed silver top plate
    SILVER_LIGHT = (235, 238, 245, 255)
    SILVER_SHADOW = (160, 165, 175, 255)
    BODY_DARK = (45, 48, 55, 255)     # Leatherette textured body
    BODY_TEXTURE = (38, 40, 46, 255)
    LEICA_RED = (225, 25, 30, 255)    # Iconic Leica Red Dot
    RED_ACCENT = (255, 60, 60, 255)
    LENS_OUTER = (140, 145, 155, 255)
    LENS_RING = (30, 32, 38, 255)
    GLASS_DEEP = (18, 38, 58, 255)    # Blue/Cyan anti-reflective coated glass
    GLASS_MID = (32, 75, 115, 255)
    GLASS_CYAN = (75, 175, 215, 255)
    GLASS_GLINT = (255, 255, 255, 255)
    VIEWFINDER = (60, 130, 190, 255)
    BUTTON = (220, 70, 60, 255)

    def p(x, y, color):
        if 0 <= x < GRID and 0 <= y < GRID:
            draw.point((x, y), fill=color)

    def rect(x1, y1, x2, y2, color):
        for y in range(y1, y2 + 1):
            for x in range(x1, x2 + 1):
                p(x, y, color)

    # 1. Background rounded pixel badge (app icon container)
    # 28x28 rounded rect in 32x32
    for y in range(1, 31):
        for x in range(1, 31):
            # cut corners for rounded badge
            if (x in (1, 30) and y in (1, 2, 29, 30)) or (x in (2, 29) and y in (1, 30)):
                continue
            p(x, y, (244, 245, 240, 255)) # Warm retro paper cream background

    # Border around badge
    for x in range(3, 29):
        p(x, 1, BORDER)
        p(x, 30, BORDER)
    for y in range(3, 29):
        p(1, y, BORDER)
        p(30, y, BORDER)
    p(2, 2, BORDER); p(29, 2, BORDER); p(2, 29, BORDER); p(29, 29, BORDER)

    # 2. Camera Body Outline
    # Shutter button on top left: x=6..9, y=5..6
    rect(6, 6, 8, 7, SILVER_LIGHT)
    rect(7, 5, 8, 5, (230, 45, 45, 255)) # Red shutter release cap!
    # Mode dial on top right: x=22..24, y=6..7
    rect(22, 6, 24, 7, SILVER_SHADOW)
    # Hotshoe in center: x=13..17, y=6..7
    rect(13, 6, 17, 7, BORDER)

    # Main camera chassis: x=4..26, y=8..25
    # Outline of camera
    rect(5, 8, 25, 25, BORDER)

    # Silver Top Plate: y=9..12, x=5..25
    rect(5, 9, 25, 12, SILVER_TOP)
    # Silver highlights and shadows
    for x in range(5, 26):
        p(x, 9, SILVER_LIGHT)
        p(x, 12, SILVER_SHADOW)

    # Rangefinder window / Viewfinder: x=21..24, y=10..11
    rect(21, 10, 24, 11, BORDER)
    p(22, 10, VIEWFINDER)
    p(23, 10, (140, 210, 255, 255))
    p(22, 11, (30, 80, 130, 255))
    p(23, 11, VIEWFINDER)

    # Small sensor/focus assist window: x=7..8, y=10..11
    p(7, 10, BORDER); p(8, 10, BORDER)
    p(7, 11, (180, 180, 190, 255)); p(8, 11, (100, 100, 110, 255))

    # Camera Body (Black leatherette textured): y=13..24, x=5..25
    rect(5, 13, 25, 24, BODY_DARK)
    # Texture noise
    for y in range(13, 25):
        for x in range(5, 26):
            if (x + y) % 2 == 0:
                p(x, y, BODY_TEXTURE)

    # Iconic Leica Red Dot: x=8..10, y=14..16
    rect(8, 14, 10, 16, LEICA_RED)
    p(8, 14, RED_ACCENT)
    p(9, 15, (255, 255, 255, 255)) # 'L' signature center glint

    # Lens barrel (centered at x=15.5, y=18.5 -> roughly circle around (15, 18))
    # Outer ring
    lens_coords = [
        (13, 14), (14, 14), (15, 14), (16, 14), (17, 14),
        (12, 15), (18, 15),
        (11, 16), (19, 16),
        (11, 17), (19, 17),
        (11, 18), (19, 18),
        (11, 19), (19, 19),
        (11, 20), (19, 20),
        (12, 21), (18, 21),
        (13, 22), (14, 22), (15, 22), (16, 22), (17, 22),
    ]
    for (lx, ly) in lens_coords:
        p(lx, ly, LENS_OUTER)

    # Inner lens ring & glass
    for ly in range(15, 22):
        for lx in range(12, 19):
            if (lx in (12, 18) and ly in (15, 21)):
                continue
            p(lx, ly, GLASS_DEEP)

    # Glass aperture reflection & cyan coated element
    for ly in range(16, 21):
        for lx in range(13, 18):
            p(lx, ly, GLASS_MID)

    # Glass highlights / retro flare reflection
    p(14, 16, GLASS_CYAN)
    p(15, 16, GLASS_GLINT)
    p(14, 17, GLASS_GLINT)
    p(16, 19, (25, 45, 75, 255))
    p(17, 19, (15, 25, 45, 255))

    # Bottom camera plate: y=24, x=5..25
    for x in range(5, 26):
        p(x, 24, BORDER)

    return img

if __name__ == "__main__":
    icon_32 = generate_pixel_camera_icon()
    
    # Target directories
    base_dir = r"c:\PetProject\photographer-tip"
    res_dir = os.path.join(base_dir, "android", "app", "src", "main", "res")
    assets_dir = os.path.join(base_dir, "assets")
    web_dir = os.path.join(base_dir, "web")
    os.makedirs(assets_dir, exist_ok=True)
    os.makedirs(web_dir, exist_ok=True)

    # Upscale using NEAREST NEIGHBOR to keep crispy pixel art look!
    sizes = {
        os.path.join(assets_dir, "app_icon.png"): 512,
        os.path.join(assets_dir, "app_icon_1024.png"): 1024,
        os.path.join(res_dir, "mipmap-mdpi", "ic_launcher.png"): 48,
        os.path.join(res_dir, "mipmap-hdpi", "ic_launcher.png"): 72,
        os.path.join(res_dir, "mipmap-xhdpi", "ic_launcher.png"): 96,
        os.path.join(res_dir, "mipmap-xxhdpi", "ic_launcher.png"): 144,
        os.path.join(res_dir, "mipmap-xxxhdpi", "ic_launcher.png"): 192,
        os.path.join(web_dir, "favicon.png"): 32,
    }

    for path, sz in sizes.items():
        os.makedirs(os.path.dirname(path), exist_ok=True)
        scaled = icon_32.resize((sz, sz), Image.Resampling.NEAREST)
        scaled.save(path, "PNG")
        print(f"Generated {path} ({sz}x{sz})")

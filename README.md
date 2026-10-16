<div align="center">

<img src="assets/app_icon.png" width="128" height="128" alt="Leica Recipe Book Logo" />

# 📷 Leica Recipe Book
### *Sổ tay 2: Công thức theo cảnh × khung giờ trong ngày*
*Dành cho Xiaomi 17T (Leica Summilux) · Chế độ Pro RAW · Hậu kỳ Adobe Lightroom*

[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://github.com/maico-le/photographer-tip/releases)
[![Version](https://img.shields.io/badge/Version-v1.0.0-D9222A?style=for-the-badge)](https://github.com/maico-le/photographer-tip/releases/latest)
[![Device](https://img.shields.io/badge/Device-Xiaomi_17T_Leica-FA520F?style=for-the-badge)](#)
[![Style](https://img.shields.io/badge/Style-Retro_Pixel_Art-FFAF00?style=for-the-badge)](#)

<br/>

### 📲 [👉 TẢI NGAY BẢN CÀI ĐẶT LEICA RECIPE APK CHO ANDROID (TRỰC TIẾP) 👈](https://github.com/maico-le/photographer-tip/releases/latest/download/app-release.apk)
*Hoặc xem các bản cập nhật và changelog tại trang [GitHub Releases](https://github.com/maico-le/photographer-tip/releases).*

---

</div>

## 🌟 Giới thiệu

Ứng dụng Flutter di động dạng **sổ tay bỏ túi (pocket field-guide)** dành cho các nhiếp ảnh gia và người dùng yêu thích chụp ảnh với **Xiaomi 17T (Leica Summilux)** bằng **chế độ Chuyên Nghiệp (Pro mode RAW)** và hậu kỳ theo phong cách **Adobe Lightroom**.

Ứng dụng tích hợp đầy đủ dữ liệu từ **Sổ tay 2**:
- **14 Bối cảnh thực tế**: Phố phường (Street), Chợ & ẩm thực, Biển đảo, Đỉnh núi & biển mây, Rừng & thác suối, Đồng quê thôn dã, Sông hồ & cầu, Thành phố & Skyline, Đền chùa di tích, Quán cà phê & lifestyle, Hoa cỏ & macro, Đường đèo phượt, Chân dung du lịch, Bầu trời & trăng sao.
- **8 Khung giờ vàng (T1 - T8)** tính theo giờ mọc (SR) và lặn (SS) của mặt trời.
- **Ma trận tương thích cảnh × giờ**: Tra cứu nhanh mức độ phù hợp (`◎` Tốt nhất, `○` Tốt, `△` Tạm được, `×` Nên tránh).
- **Bộ thông số Lightroom trực quan**: Mô phỏng dạng thanh trượt Pixel Stepped Slider (Exposure, Contrast, Highlights, Shadows, Whites, Blacks), cân bằng trắng Kelvin, HSL, Color Grading, Effects.
- **1-Tap Copy Recipe**: Sao chép toàn bộ thông số chụp và hậu kỳ vào clipboard chỉ với một chạm.

---

## 👾 Phong cách Thiết kế Retro Pixel Art

Lấy cảm hứng từ phong cách đồ họa của **/muxik**:
- **Viền pixel đậm (2px black borders)** cùng đổ bóng cơ học **3px solid offset shadow** (`blurRadius: 0`).
- **Hiệu ứng nút bấm cơ học (Stepped Press Effect)**: Lún xuống tức thì khi chạm.
- **Bộ icon 8-bit / 16-bit vẽ tay trên Canvas**: Máy ảnh Leica chấm đỏ, mặt trời, hoàng hôn, trăng sao, ngọn núi, tách cà phê, ma trận, v.v.
- **App Icon Pixel Art**: Máy ảnh Rangefinder Leica cổ điển với chấm đỏ Red Dot đặc trưng, nắp nút chụp đỏ và phản chiếu thấu kính màu xanh lam.
- **Bộ màu linh hoạt**:
  1. *Leica Classic* (Đỏ Leica & Thép Bạc)
  2. *Retro Amber* (Cam ấm cổ điển)
  3. *Leica Monochrom* (Đen trắng tương phản cao)
  4. *Cyber 8-Bit* (Xanh cyan phong cách arcade)

---

## 📱 Các tính năng chính

### 1. Tab Cẩm Nang (Recipes Explorer)
- Duyệt qua 14 cảnh chụp với công thức chi tiết theo từng thời điểm.
- Thanh tìm kiếm nhanh theo từ khóa, tiêu cự ống kính (`15mm`, `23mm`, `115mm`), hoặc mã phong cách Look (`D1` - `D11`).
- Bộ lọc theo khung giờ (T1 đến T8) và danh sách Yêu thích.
- Trang chi tiết hiển thị:
  - Thông số Pro mode: Tiêu cự, ISO, Tốc độ, WB Kelvin, Bù trừ sáng EV, Ghi chú đo sáng.
  - Thông số hậu kỳ Lightroom với thanh trượt trực quan.
  - Phân tích HSL từng kênh màu và Color Grading.
  - Nút **Sao chép công thức** để lưu vào ứng dụng ghi chú hoặc dán nhanh.

### 2. Tab Ma Trận Giờ (Matrix Lookup)
- Bảng ma trận 14×8 hiển thị độ phù hợp:
  - `◎`: Tốt nhất
  - `○`: Tốt
  - `△`: Tạm được
  - `×`: Nên tránh
- Chạm vào bất kỳ ô nào để xem popup phân tích điều kiện ánh sáng và mở ngay công thức tương ứng.

### 3. Tab Tính Giờ Nắng (Sun & Golden Hour Calculator)
- Tự động tính toán chính xác 8 khoảng thời gian (T1 - T8) trong ngày.
- Cung cấp sẵn các địa phương Việt Nam: *TP. Hồ Chí Minh, Hà Nội, Đà Nẵng, Đà Lạt, Phú Quốc, Sa Pa* hoặc nhập giờ tùy chỉnh.
- Hiển thị khung giờ **đang diễn ra theo thời gian thực** và gợi ý những cảnh chụp đẹp nhất **ngay tại thời điểm hiện tại**.
- Bảng lịch trình và 5 mẹo săn giờ đẹp trước khi xuất phát.

### 4. Tab Checklist & Quy Ước
- **Checklist 7 bước** trước mỗi lần bấm máy (chống rung, khóa AE/AF, đo sáng histogram, WB manual...).
- Quy ước thiết lập thông số cơ bản (Base RAW vs JPG).
- Bảng tra cứu 11 mã Look phong cách (D1 Monochrom, D4 Portra, D5 Gold 200, D6 Velvia, D7 Cinestill, D10 Teal-Orange...).

---

## 🚀 Tự động Build APK qua GitHub Actions

Kho lưu trữ tích hợp sẵn workflow `.github/workflows/build_release.yml`:
- Tự động kích hoạt khi `push` lên nhánh `main` hoặc tạo tag release `v*`.
- Tự động kiểm tra cú pháp (`flutter analyze`), chạy bộ kiểm thử (`flutter test`) và build bản release APK.
- Tự động đăng tải file cài đặt **`app-release.apk`** lên mục **Releases** của GitHub.

---

## 📥 Hướng Dẫn Cài Đặt Nhanh (Android)

1. Nhấn tải file APK phát hành trực tiếp: [**Leica Recipe Book APK (Mới nhất)**](https://github.com/maico-le/photographer-tip/releases/latest/download/app-release.apk).
2. Sau khi tải về máy điện thoại Android, nhấn mở file `.apk` và chọn **Cài đặt**.
   *(Nếu được hỏi, hãy bật quyền **Cho phép cài đặt ứng dụng không rõ nguồn gốc** cho trình duyệt của bạn)*.
3. Mở ứng dụng **Leica Recipe Book** và bắt đầu tra cứu công thức chụp ảnh theo cảnh và khung giờ!

---

## 🛠️ Hướng dẫn cài đặt & chạy thử (Dành cho Lập trình viên)

### Yêu cầu môi trường
- Flutter SDK `>=3.16.0` (Khuyên dùng `3.24+`)
- Dart SDK `>=3.2.0`
- Android Studio / Android SDK

### Chạy trên máy ảo hoặc thiết bị thật
```bash
git clone https://github.com/maico-le/photographer-tip.git
cd photographer-tip
flutter pub get
flutter run
```

### Tạo lại bộ Icon Pixel Art
```bash
python generate_icon.py
```

### Biên dịch APK Release cục bộ
```bash
flutter build apk --release
```
File APK hoàn chỉnh sẽ nằm tại: `build/app/outputs/flutter-apk/app-release.apk`.

---

© 2026 Leica Recipe Book. Giao diện Pixel Art thiết kế cho dòng máy Xiaomi 17T Leica Camera.

# Berber Organization App

İşletme sahiplerinin ve çalışanlarının kullandığı cross-platform uygulama. Flutter ile geliştirilmiş web, mobil ve desktop uygulaması.

## Özellikler

- İşletme profil yönetimi
- Randevu yönetimi
- Personel yönetimi
- Müşteri yönetimi
- Finans takibi
- Analiz ve raporlama
- Sosyal medya entegrasyonu

## Teknik Detaylar

### Kullanılan Teknolojiler

- Flutter
- GraphQL (berber2425/gql_client)
- State Management (berber2425/sign, berber2425/sign_flutter)
- Data Layer (berber2425/org_data_layer)

### Geliştirme Ortamı Gereksinimleri

- Flutter SDK
- VS Code veya Android Studio
- Git
- iOS için: Xcode ve CocoaPods
- Android için: Android Studio ve Android SDK

### Kurulum

1. Repository'yi klonlayın

```bash
git clone https://github.com/berber2425/org_app.git
```

2. Bağımlılıkları yükleyin

```bash
flutter pub get
```

3. Uygulamayı çalıştırın

```bash
# iOS için
flutter run -d ios

# Android için
flutter run -d android

# Web için
flutter run -d chrome

# Desktop için
flutter run -d windows # veya macos, linux
```

## Proje Yapısı

```
lib/
  ├── core/           # Çekirdek fonksiyonlar ve utilities
  ├── data/           # Data layer entegrasyonu
  ├── features/       # Özellik bazlı modüller
  │   ├── auth/       # Kimlik doğrulama
  │   ├── profile/    # Profil yönetimi
  │   ├── calendar/   # Takvim ve randevu
  │   ├── staff/      # Personel yönetimi
  │   ├── customers/  # Müşteri yönetimi
  │   ├── finance/    # Finans takibi
  │   └── analytics/  # Analiz ve raporlar
  ├── shared/         # Paylaşılan widget'lar ve helper'lar
  └── main.dart       # Uygulama giriş noktası
```

## Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

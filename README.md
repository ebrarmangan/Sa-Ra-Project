# Sara Project

Sara Project, iOS uygulaması ve Node.js backend'inden oluşan modern bir full-stack mesajlaşma ve iletişim platformudur.

## Proje Yapısı

Bu proje iki ana bölümden oluşmaktadır:

### Frontend (iOS)
- **Dil ve Teknoloji:** Swift ve SwiftUI
- **Mimari:** MVVM (Model-View-ViewModel)
- **Özellikler:** Network katmanı için özel NetworkManager implementasyonu

### Backend (Node.js)
- **Framework:** Express.js
- **Veritabanı:** MongoDB
- **Kimlik Doğrulama:** JWT tabanlı
- **Mimari:** RESTful API

---

## Başlangıç

### Gereksinimler

#### iOS Uygulaması için:
- Xcode 14.0 veya üzeri
- iOS 15.0 veya üzeri
- Swift 5.0
- Apple Developer hesabı (geliştirme için)

#### Backend için:
- Node.js (v14.0.0 veya üzeri)
- npm (Node Package Manager)
- MongoDB
- Twilio hesabı (SMS doğrulama için)

---

### Kurulum

1. Projeyi klonlayın:
   ```bash
   git clone https://github.com/ebrarmangan/Sa-Ra-Project.git
   cd Sa-Ra-Project
   ```

2. **Backend Kurulumu**
   ```bash
   cd backend
   npm install
   ```

   `.env` Dosyası oluşturun ve aşağıdaki bilgileri ekleyin:
   ```env
   MONGODB_URI=your_mongodb_uri
   JWT_SECRET=your_jwt_secret
   TWILIO_ACCOUNT_SID=your_twilio_sid
   TWILIO_AUTH_TOKEN=your_twilio_token
   ```

   Backend'i başlatın:
   ```bash
   npm start
   ```

3. **iOS Uygulaması Kurulumu**
   - `projectSara.xcodeproj` dosyasını Xcode'da açın.
   - Gerekli sertifikaları ve provisioning profile'ları yapılandırın.
   - Uygulamayı bir simülatör veya gerçek cihazda çalıştırın.

---

## Özellikler

- Kullanıcı kaydı ve girişi
- SMS doğrulama sistemi
- Gerçek zamanlı mesajlaşma
- Kullanıcı profil yönetimi
- Güvenli veri iletişimi

---

## Teknoloji Yığını

### Frontend
- SwiftUI
- Combine Framework
- URLSession
- Swift Package Manager

### Backend
- Node.js
- Express.js
- MongoDB
- JWT (JSON Web Tokens)
- Twilio API

---

## Güvenlik

- JWT tabanlı kimlik doğrulama
- Şifrelenmiş veri iletişimi
- Güvenli API endpoint'leri
- Input validasyonu
- Rate limiting

---

## Katkıda Bulunma

1. Bu repository'yi fork edin:
   ```bash
   git checkout -b feature/amazing-feature
   ```
2. Değişikliklerinizi commit edin:
   ```bash
   git commit -m 'Add some amazing feature'
   ```
3. Branch'inizi push edin:
   ```bash
   git push origin feature/amazing-feature
   ```
4. Pull Request oluşturun.

---

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

---

## İletişim

Ebrar Mangan - [GitHub Profilim](https://github.com/ebrarmangan)

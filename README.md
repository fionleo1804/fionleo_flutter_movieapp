**FL MovieApp**

A high-performance movie database built with Flutter to provide a seamless app-link epxerience with offline caching, an internal WebView booking system (currently point to Google) and real-time Firebase push notification.

🚀 Features

* **Native Experience:** Smooth navigation with internal WebView integration for ticket booking.
* **Offline Support:** Persistent data storage using Hive to allow browsing previously loaded movies without internet.
* **Push Notifications:** Integrated with Firebase Cloud Messaging (FCM). Users are automatically subscribed to the external_testers topic.
* **Dynamic UI:** Infinite scrolling, pull-to-refresh, and advanced sorting (Release Date, Popularity, etc.).
* **Adaptive Design:** Optimized layouts for mobile devices and basic support for Web.

🛠️ Tech Stack
* Framework: Flutter
* Language: Dart
* State Management: Provider
* Database (Caching): Hive
* Notifications: Firebase Cloud Messaging
* API: TMDB (The Movie Database)
* WebView: webview_flutter with Custom User Agent spoofing for Google compatibility.

📦 Installation & Setup
1. Prerequisites
    - Flutter SDK (v3.x or higher)
    - Dart SDK
    - Android Studio / VS Code

2. Environment Variables

Create a .env.local file in the root directory. Refer to .env.sample

3. Installation

`flutter pub get`

4. Development Server

`flutter run`

🟢▶️ Android Production Build (Important)

To ensure the internal WebView avoids "Gray Screen" security blocks on Android, the app uses User Agent Spoofing. To build a release-ready APK:

1. Clean the project:

`flutter clean`

`flutter pub get`

2. Build APKs:

`flutter build apk --release`

3. For Google Play Store

`flutter build appbundle --release`

**Wiki**
For detailed logic, API documentation, and architecture, please visit the Wiki:
[https://github.com/fionleo1804/fionleo_flutter_movieapp/wiki]

**Outputs**
- Mobile: [https://github.com/fionleo1804/fionleo_flutter_movieapp/blob/main/outputs/mobile.mp4]

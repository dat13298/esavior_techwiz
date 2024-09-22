# eSavior Application
## Installation and Setup
### 1. System Requirements:

Before you begin, make sure your environment meets the following re-quirements:
- Operating System: Windows, macOS, or Linux.
- Flutter SDK installed (version 2.x or later).
- Android Studio or Visual Studio Code (for running and debugging).
- Android Device/Emulator running Android 5.0 (Lollipop) or higher.

### 2. Installing Flutter SDK:

- Download and install the Flutter SDK from the official website: https://flutter.dev/docs/get-started/install
- Follow the instructions for your operating system to set up the Flutter environment variables.

### 3. Cloning the application:

- Open your terminal or command prompt.
- Clone the eSavior project repository using Git: git clone https://github.com/dat13298/esavior_techwiz
- Navigate to the project folder.

### 4. Installing Dependencies:

Run the following command to install the required Flutter packages: flutter pub get

### 5. Setting Up Android Device/Emulator:

**5.1 Using a Physical Device:**

- Enable Developer Mode and USB Debugging on your Android device.
- Connect your device to your computer via USB.
- Run the following command to verify that Flutter recognizes your device: flutter devices

**5.2 Using an Emulator:**

- Open Android Studio > AVD Manager.
- Create a virtual device if not already available.
- Launch the emulator.

### 6. Configuring Permissions:

Your app requires access to **GPS**, **phone**, and **network**. Follow these steps to configure permissions in your app.
In your **Flutter project**, navigate to: `android/app/src/main/AndroidManifest.xml`
Add the following permissions inside the `<manifest>` tag:

    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.CALL_PHONE" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

### 7. Configuring Permissions:

- Ensure your device is connected or the emulator is running.
- In your terminal, run the following command: flutter run.
- The app will be built and deployed to your device or emulator.

### 8. Testing GPS and Phone Access:
When you first run the app, it will ask for permission to access GPS and phone features:

- Location Access: Required for tracking your position to send emergency services to your location.
- Phone Access: Needed to make emergency calls directly through the app.

Ensure that you grant these permissions to avoid any issues with app functionality.

### 9. Troubleshooting:

If you encounter issues during installation or running the app, try the following steps:

- Ensure your Flutter SDK is up to date: flutter upgrade.
- Check if all dependencies are correctly installed using: flutter doctor.
- Make sure your Android device or emulator is running and connected properly: _flutter devices_

### 10. Building APK for Distribution:

If you want to build an APK for installation on other devices, follow these steps:

- In your terminal, run: `flutter build apk --release`
- The APK will be generated in the `build/app/outputs/flutter-apk/` directory.

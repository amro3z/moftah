# Moftah — ELM327 Bluetooth Classic setup

## New package

Add this dependency to `pubspec.yaml`:

```yaml
dependencies:
  bluetooth_serial_android: ^1.1.2
```

Then run:

```bash
flutter pub get
flutter clean
flutter run
```

`flutter_bloc` is already used by the project and is not a new dependency.

## Android support

This implementation targets Android because the ELM327 in use is Bluetooth Classic / SPP (paired with PIN 1234).

The Bluetooth plugin merges the Bluetooth permissions into the Android manifest and exposes `ensurePermissions()` for runtime permission requests. If you prefer to declare them explicitly, these are the relevant Android permissions:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

The project already uses location permissions for its map/location feature.

## Before testing

1. Give the ELM327 power.
2. Pair it from Android Bluetooth settings using PIN `1234`.
3. Open Vehicle Health.
4. Press **اتصل بـ ELM327**.

With power only, the app can test the Bluetooth + ELM327 adapter connection (`ATI`, `ATZ`, etc.). Engine live data and fault codes need the adapter connected to a vehicle ECU through the car's OBD-II port.

## What the app reads

- `ATI` — adapter identification
- `ATRV` — adapter input voltage
- `0100` — checks whether an ECU responds / supported PID bitmap
- `010C` — engine RPM
- `0105` — coolant temperature
- `03` — stored diagnostic trouble codes (DTCs)

The screen deliberately distinguishes **adapter connected but ECU unavailable** from **no stored fault codes**, so a powered-only ELM327 is not incorrectly shown as a healthy car.

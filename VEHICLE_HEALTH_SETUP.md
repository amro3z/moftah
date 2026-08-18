# Vehicle Health setup

Add this dependency to the app `pubspec.yaml` because online car logos are SVG files:

```yaml
dependencies:
  flutter_svg: ^2.2.0
```

Then run:

```bash
flutter pub get
```

## Passing API data to VehicleHealthScreen

The screen no longer creates demo data internally. Build a `VehicleHealthModel` from the API response:

```dart
final health = VehicleHealthModel.fromJson(response.data);

Navigator.pushNamed(
  context,
  '/vehicle-health',
  arguments: health,
);
```

The route requires `VehicleHealthModel` and injects it into `VehicleHealthScreen(data: arguments)`.

## Logos

`VehicleBrandLogo` first uses `brandLogoUrl` if the backend provides one. Otherwise it resolves the `brand` name to the pinned jsDelivr VehicleSpecs brand-logo CDN. This means the backend can override any logo later without changing UI code.

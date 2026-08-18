# OBD-II Mock Preview

تم تفعيل Mock Mode مؤقتًا من `lib/routing/route.dart`:

```dart
ObdCubit(
  repository: ObdRepository(),
  mockMode: true,
)..initialize()
```

الـMock يعرض بيانات متغيرة كل 3 ثواني أثناء فتح Dashboard:
- RPM
- السرعة
- حرارة المحرك
- حرارة هواء السحب
- Engine Load
- Throttle Position
- Voltage
- DTCs: P0300 و P0420

لما تخلص معاينة الديزاين وتريد الرجوع للـELM327 الحقيقية:

```dart
mockMode: false,
```

أو احذف `mockMode` لأنه `false` افتراضيًا.

import 'package:moftah/ui/car_owner/vehicle_health/cubit/obd_state.dart';

String obdStageText(ObdConnectionStage stage) => switch (stage) {
      ObdConnectionStage.checkingPairedDevices =>
        'بنفحص أجهزة البلوتوث المقترنة...',
      ObdConnectionStage.waitingForDeviceSelection =>
        'اختار جهاز Bluetooth المقترن...',
      ObdConnectionStage.connectingBluetooth =>
        'بنعمل اتصال Bluetooth مع القطعة...',
      ObdConnectionStage.initializingAdapter =>
        'بنجهز ELM327 بأوامر AT...',
      ObdConnectionStage.detectingProtocol =>
        'بنطلب من ELM327 اكتشاف بروتوكول العربية...',
      ObdConnectionStage.readingVehicle =>
        'بنتواصل مع ECU ونقرأ بيانات العربية...',
      ObdConnectionStage.ecuNotResponding =>
        'Bluetooth متصل، لكن ECU لم يرد',
      ObdConnectionStage.done => 'تم الاتصال وECU أرسل البيانات',
      ObdConnectionStage.idle => 'جاهز للاتصال',
    };

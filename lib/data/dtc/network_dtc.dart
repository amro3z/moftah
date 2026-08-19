import 'package:moftah/data/dtc/dtc_info.dart';

const Map<String, ObdDtcInfo> networkDtc = {
  'U0001': ObdDtcInfo(
    title: 'مشكلة في شبكة CAN الرئيسية',
    description:
        'في مشكلة في الاتصال على شبكة CAN اللي بتخلي وحدات العربية تكلم بعض. افحص التغذية والأرضي والشبكة قبل تغيير أي وحدة.',
    system: 'شبكة الاتصال بين وحدات العربية',
  ),
  'U0100': ObdDtcInfo(
    title: 'الاتصال بكمبيوتر المحرك اتقطع',
    description:
        'وحدة في العربية فقدت الاتصال بكمبيوتر المحرك ECM/PCM. السبب ممكن يكون كهربا، أرضي، شبكة CAN أو الوحدة نفسها.',
    system: 'شبكة الاتصال - كمبيوتر المحرك',
  ),
  'U0121': ObdDtcInfo(
    title: 'الاتصال بوحدة ABS اتقطع',
    description:
        'وحدة في العربية مش قادرة تتواصل مع كمبيوتر ABS. افحص كهربا الوحدة وشبكة CAN والتوصيلات.',
    system: 'شبكة الاتصال - ABS',
  ),
};

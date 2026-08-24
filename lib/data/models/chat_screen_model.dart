import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/data/models/emergency_tow_provider_model.dart';
import 'package:moftah/data/models/profile_history_models.dart';

class ChatSeedMessageModel {
  final String text;
  final bool isMine;
  final String time;

  const ChatSeedMessageModel({
    required this.text,
    required this.isMine,
    required this.time,
  });
}

class ChatScreenModel {
  final String participantId;
  final String participantName;
  final String subtitle;
  final String? imageUrl;
  final String? phone;
  final CurrentRepairModel? repairData;
  final bool isRoadside;
  final List<ChatSeedMessageModel> initialMessages;

  const ChatScreenModel({
    required this.participantId,
    required this.participantName,
    required this.subtitle,
    this.imageUrl,
    this.phone,
    this.repairData,
    this.isRoadside = false,
    this.initialMessages = const [],
  });

  factory ChatScreenModel.fromRepair(CurrentRepairModel repair) {
    return ChatScreenModel(
      participantId: 'repair-technician',
      participantName: repair.technicianName,
      subtitle: 'متصل الآن',
      repairData: repair,
      initialMessages: const [
        ChatSeedMessageModel(
          text: 'مرحبًا، تم استلام السيارة وبدأت الفحص.',
          isMine: false,
          time: '10:30',
        ),
        ChatSeedMessageModel(
          text: 'شكرًا، متى تتوقع الانتهاء؟',
          isMine: true,
          time: '10:32',
        ),
        ChatSeedMessageModel(
          text: 'إن شاء الله خلال 2-3 ساعات، وهبلغك بأي تحديث.',
          isMine: false,
          time: '10:33',
        ),
      ],
    );
  }

  factory ChatScreenModel.fromEmergencyTow(
    EmergencyTowProviderModel provider,
  ) {
    return ChatScreenModel(
      participantId: provider.id,
      participantName: provider.driverName,
      subtitle: 'ونش • ${provider.governorate}',
      phone: provider.phone,
      isRoadside: true,
      initialMessages: const [
        ChatSeedMessageModel(
          text: 'أهلاً، ابعتلي مكان العربية ونوعها علشان أحدد لك التكلفة.',
          isMine: false,
          time: 'الآن',
        ),
      ],
    );
  }

  factory ChatScreenModel.fromConversation(
    ConversationHistoryModel conversation,
  ) {
    return ChatScreenModel(
      participantId: conversation.participantId,
      participantName: conversation.participantName,
      subtitle: conversation.subtitle,
      phone: conversation.phone,
      isRoadside: conversation.kind == ConversationKind.emergency,
      initialMessages: [
        ChatSeedMessageModel(
          text: conversation.lastMessage,
          isMine: false,
          time: conversation.timeLabel,
        ),
      ],
    );
  }
}

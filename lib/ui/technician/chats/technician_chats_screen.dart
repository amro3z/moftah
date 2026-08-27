import 'package:flutter/material.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/technician/home/technician_home.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';

class TechnicianChatsScreen extends StatelessWidget {
  const TechnicianChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TechnicianStore.instance;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('المحادثات', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: store.conversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final conversation = store.conversations[index];
            final request = store.byId(conversation.requestId);
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 14)],
              ),
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, '/chat', arguments: conversation.toChat(request)),
                leading: const CircleAvatar(backgroundColor: Color(0x141976D2), child: Icon(Icons.person_rounded, color: AppColors.secondary)),
                title: Text(conversation.customerName, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: AppColors.primary)),
                subtitle: Text('${request.vehicleName} • ${conversation.lastMessage}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Cairo', color: AppColors.textMuted)),
                trailing: Text(conversation.time, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textMuted)),
              ),
            );
          },
        ),
        bottomNavigationBar: const TechnicianBottomNav(current: 3),
      ),
    );
  }
}

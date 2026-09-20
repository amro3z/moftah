import 'package:flutter/material.dart';

import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/technician/widgets/technician_scaffold.dart';

class TechnicianChatsScreen extends StatelessWidget {
  const TechnicianChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TechnicianStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TechnicianScaffold(
        title: 'المحادثات',
        current: 3,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
        

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    120,
                  ),
                  itemCount: store.conversations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final conversation = store.conversations[index];

                    final request = store.byId(conversation.requestId);

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .05),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/chat',
                              arguments: conversation.toChat(request),
                            );
                          },
                          leading: const CircleAvatar(
                            backgroundColor: Color(0x141976D2),
                            child: Icon(
                              Icons.person_rounded,
                              color: AppColors.secondary,
                            ),
                          ),
                          title: Text(
                            conversation.customerName,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          subtitle: Text(
                            '${request.vehicleName} • '
                            '${conversation.lastMessage}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.textMuted,
                            ),
                          ),
                          trailing: Text(
                            conversation.time,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

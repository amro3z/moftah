import 'package:flutter/material.dart';
import 'package:moftah/data/models/chat_screen_model.dart';
import 'package:moftah/data/store/profile_history_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ProfileHistoryStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: ResponsiveSize.width(context, 5),
                ),
              ),
              Expanded(
                child: customText(
                  text: 'سجل المحادثات',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final conversations = store.conversations;

            return ListView.separated(
              padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
              itemCount: conversations.length,
              separatorBuilder: (_, __) =>
                  SizedBox(height: ResponsiveSize.height(context, .8)),
              itemBuilder: (context, index) {
                final chat = conversations[index];

                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/chat',
                      arguments: ChatScreenModel.fromConversation(chat),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(
                        ResponsiveSize.width(context, 3.5),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: .10),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: ResponsiveSize.width(context, 6.5),
                            backgroundColor: AppColors.secondary.withValues(
                              alpha: .10,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: AppColors.secondary,
                              size: ResponsiveSize.width(context, 6),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 3)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  text: chat.participantName,
                                  fontSize: ResponsiveSize.width(
                                    context,
                                    AppSizes.fontMd,
                                  ),
                                  color: AppColors.primary,
                                  isBold: true,
                                ),
                                customText(
                                  text: chat.subtitle,
                                  fontSize: ResponsiveSize.width(
                                    context,
                                    AppSizes.fontXs,
                                  ),
                                  color: AppColors.secondary,
                                  isBold: true,
                                ),
                                customText(
                                  text: chat.lastMessage,
                                  fontSize: ResponsiveSize.width(
                                    context,
                                    AppSizes.fontXs,
                                  ),
                                  color: AppColors.textMuted,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          customText(
                            text: chat.timeLabel,
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontXs,
                            ),
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

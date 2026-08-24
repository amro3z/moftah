import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/data/models/chat_screen_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/repair/widgets/animated_entrance.dart';
import 'package:moftah/utils/responsive.dart';

class RepairChatScreen extends StatefulWidget {
  final ChatScreenModel data;

  const RepairChatScreen({super.key, required this.data});

  @override
  State<RepairChatScreen> createState() => _RepairChatScreenState();
}

class _RepairChatScreenState extends State<RepairChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final List<_ChatMessage> _messages;

  @override
  void initState() {
    super.initState();

    if (widget.data.initialMessages.isNotEmpty) {
      _messages = widget.data.initialMessages
          .map(
            (message) => _ChatMessage(
              text: message.text,
              isMine: message.isMine,
              time: message.time,
            ),
          )
          .toList();

      if (widget.data.repairData != null) {
        _messages.add(const _ChatMessage.offer(time: '12:30'));
      }
      return;
    }

    _messages = [
      const _ChatMessage(
        text: 'مرحبًا، كيف أقدر أساعدك؟',
        isMine: false,
        time: 'الآن',
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 4),
                  vertical: ResponsiveSize.height(context, 1.5),
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return AnimatedEntrance(
                    delay: Duration(milliseconds: 35 * index),
                    beginOffset: Offset(message.isMine ? -14 : 14, 6),
                    child: _messageItem(context, message),
                  );
                },
              ),
            ),
            _inputBar(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.primary,
          ),
          CircleAvatar(
            radius: ResponsiveSize.width(context, 5),
            backgroundColor: AppColors.secondary.withValues(alpha: .12),
            child: Icon(
              Icons.engineering_rounded,
              color: AppColors.secondary,
              size: ResponsiveSize.width(context, 5),
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                customText(
                  text: widget.data.participantName,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  isBold: true,
                ),
                customText(
                  text: widget.data.subtitle,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.success,
                  isBold: true,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_horiz_rounded,
              color: AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            onSelected: (value) {
              if (value == 'report') _showReportDialog(context);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: AppColors.danger),
                    SizedBox(width: ResponsiveSize.width(context, 2)),
                    customText(
                      text: 'إبلاغ عن مشكلة',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _messageItem(BuildContext context, _ChatMessage message) {
    if (message.isOffer && widget.data.repairData == null) {
      return const SizedBox.shrink();
    }

    if (message.isOffer) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, 1.4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  '/repair-offer',
                  arguments: widget.data.repairData,
                ),
                child: Container(
                  width: ResponsiveSize.width(context, 56),
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusLg),
                      topRight: Radius.circular(AppSizes.radiusLg),
                      bottomRight: Radius.circular(AppSizes.radiusLg),
                      bottomLeft: const Radius.circular(5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline_rounded,
                            color: AppColors.info,
                            size: ResponsiveSize.width(context, 4.36),
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 1.2)),
                          customText(
                            text: 'عرض إصلاح',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontXs,
                            ),
                            color: AppColors.info,
                            isBold: true,
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .7)),
                      customText(
                        text: 'عرض ${widget.data.repairData!.offeredPartName}',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .5)),
                      customText(
                        text:
                            '${widget.data.repairData!.offerTotal.toStringAsFixed(0)} جنيه',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXl,
                        ),
                        color: AppColors.info,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.height(context, .8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: customText(
                          text: 'عرض التفاصيل',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: Colors.white,
                          isBold: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, .3)),
              customText(
                text: message.time,
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, 1.2)),
        child: Column(
          crossAxisAlignment: message.isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveSize.width(context, 72),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 4),
                vertical: ResponsiveSize.height(context, 1.15),
              ),
              decoration: BoxDecoration(
                color: message.isMine ? AppColors.secondary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusMd),
                  topRight: Radius.circular(AppSizes.radiusMd),
                  bottomLeft: Radius.circular(
                    message.isMine ? AppSizes.radiusMd : 4,
                  ),
                  bottomRight: Radius.circular(
                    message.isMine ? 4 : AppSizes.radiusMd,
                  ),
                ),
                boxShadow: message.isMine
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: customText(
                text: message.text,
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                color: message.isMine ? Colors.white : AppColors.primary,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, .25)),
            customText(
              text: message.time,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          ResponsiveSize.width(context, 3),
          ResponsiveSize.height(context, 1),
          ResponsiveSize.width(context, 3),
          ResponsiveSize.height(context, 1),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.border.withValues(alpha: .12)),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'إرفاق الصور والملفات سيتم ربطه بالباك إند لاحقًا',
                    ),
                  ),
                );
              },
              icon: Icon(Icons.attach_file_rounded),
              color: AppColors.primary,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  hintStyle: TextStyle(fontFamily: 'Cairo'),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.width(context, 4),
                    vertical: ResponsiveSize.height(context, 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            SizedBox(width: ResponsiveSize.width(context, 2)),
            Material(
              color: AppColors.secondary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _sendMessage,
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 3.2)),
                  child: Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isMine: true, time: 'الآن'));
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showReportDialog(BuildContext context) {
    final reportController = TextEditingController();
    String selectedReason = 'تأخر الفني';
    const reasons = <(String, IconData)>[
      ('تأخر الفني', Icons.schedule_rounded),
      ('مشكلة في السعر', Icons.payments_outlined),
      ('لم يتم تنفيذ المتفق عليه', Icons.assignment_late_outlined),
      ('سلوك غير مناسب', Icons.person_off_outlined),
      ('أخرى', Icons.more_horiz_rounded),
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 1.2),
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 2.5),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: ResponsiveSize.width(context, 11.28),
                          height: ResponsiveSize.height(context, 0.47),
                          decoration: BoxDecoration(
                            color: AppColors.border.withValues(alpha: .28),
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.8)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: .06),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          border: Border.all(color: AppColors.danger.withValues(alpha: .12)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: ResponsiveSize.width(context, 11),
                              height: ResponsiveSize.width(context, 11),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: .10),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.shield_outlined,
                                color: AppColors.danger,
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.width(context, 3)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    text: 'إبلاغ عن مشكلة مع الفني',
                                    fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                                    color: AppColors.primary,
                                    isBold: true,
                                  ),
                                  customText(
                                    text: 'البلاغ بيروح لفريق الدعم فقط، والفني مش هيشوف تفاصيله.',
                                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                                    color: AppColors.textMuted,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.5)),
                      customText(
                        text: 'إيه المشكلة؟',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .8)),
                      ...reasons.map((item) {
                        final selected = selectedReason == item.$1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, .7)),
                          child: InkWell(
                            onTap: () => setSheetState(() => selectedReason = item.$1),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.width(context, 3),
                                vertical: ResponsiveSize.height(context, 1),
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.danger.withValues(alpha: .07)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.danger
                                      : AppColors.border.withValues(alpha: .16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.$2,
                                    color: selected ? AppColors.danger : AppColors.textMuted,
                                    size: ResponsiveSize.width(context, 5.38),
                                  ),
                                  SizedBox(width: ResponsiveSize.width(context, 2.5)),
                                  Expanded(
                                    child: customText(
                                      text: item.$1,
                                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                                      color: AppColors.primary,
                                      isBold: selected,
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: ResponsiveSize.width(context, 5.13),
                                    height: ResponsiveSize.height(context, 2.37),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected ? AppColors.danger : Colors.transparent,
                                      border: Border.all(
                                        color: selected ? AppColors.danger : AppColors.border,
                                      ),
                                    ),
                                    child: selected
                                        ? Icon(Icons.check_rounded, color: Colors.white, size: ResponsiveSize.width(context, 3.59))
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: ResponsiveSize.height(context, .7)),
                      TextField(
                        controller: reportController,
                        maxLines: 4,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontFamily: 'Cairo'),
                        decoration: InputDecoration(
                          hintText: 'اكتب تفاصيل إضافية لو محتاج...',
                          hintStyle: TextStyle(fontFamily: 'Cairo'),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.3)),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            minimumSize: Size.fromHeight(ResponsiveSize.height(context, 5.8)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text('تم إرسال بلاغ "$selectedReason" لفريق الدعم'),
                              ),
                            );
                          },
                          icon: Icon(Icons.flag_rounded),
                          label: Text(
                            'إرسال البلاغ',
                            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(reportController.dispose);
  }

}

class _ChatMessage {
  final String text;
  final bool isMine;
  final String time;
  final bool isOffer;

  const _ChatMessage({
    required this.text,
    required this.isMine,
    required this.time,
    this.isOffer = false,
  });

  const _ChatMessage.offer({required this.time})
    : text = '',
      isMine = false,
      isOffer = true;
}

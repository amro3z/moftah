import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moftah/data/models/problem_attachment_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ReportMediaStep extends StatefulWidget {
  final List<ProblemAttachmentModel> attachments;
  final ValueChanged<List<ProblemAttachmentModel>> onChanged;

  const ReportMediaStep({
    super.key,
    required this.attachments,
    required this.onChanged,
  });

  @override
  State<ReportMediaStep> createState() => _ReportMediaStepState();
}

class _ReportMediaStepState extends State<ReportMediaStep> {
  final ImagePicker _picker = ImagePicker();

  List<ProblemAttachmentModel> get _attachments => widget.attachments;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 2),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: 'صورة أو فيديو ممكن يفرق جدًا في التشخيص',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.primary,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.4)),
          Row(
            children: [
              Expanded(
                child: _mediaTile(
                  context,
                  Icons.camera_alt_rounded,
                  'الكاميرا',
                  'صوّر المشكلة الآن',
                  () => _showCameraPicker(context),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: _mediaTile(
                  context,
                  Icons.photo_library_rounded,
                  'المعرض',
                  'صور أو فيديو موجود',
                  () => _showGalleryPicker(context),
                ),
              ),
            ],
          ),
          if (_attachments.isNotEmpty) ...[
            SizedBox(height: ResponsiveSize.height(context, 1.6)),
            _attachmentsHeader(context),
            SizedBox(
              height: ResponsiveSize.height(context, 14),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _attachments.length,
                separatorBuilder: (_, __) => SizedBox(
                  width: ResponsiveSize.width(context, 2),
                ),
                itemBuilder: (context, index) =>
                    _attachmentPreview(context, index),
              ),
            ),
          ],
          SizedBox(height: ResponsiveSize.height(context, 1.4)),
          _infoCard(context),
        ],
      ),
    );
  }

  Widget _attachmentsHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: customText(
            text: 'المرفقات (${_attachments.length})',
            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
            color: AppColors.primary,
            isBold: true,
          ),
        ),
        TextButton.icon(
          onPressed: () => widget.onChanged(const []),
          icon: Icon(Icons.delete_outline_rounded, size: ResponsiveSize.width(context, 4.62)),
          label: Text(
            'مسح الكل',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      ],
    );
  }

  Widget _mediaTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        height: ResponsiveSize.height(context, 16),
        padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: AppColors.border.withValues(alpha: .14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ResponsiveSize.width(context, 11),
              height: ResponsiveSize.width(context, 11),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .09),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.secondary),
            ),
            SizedBox(height: ResponsiveSize.height(context, .8)),
            customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.primary,
              isBold: true,
            ),
            customText(
              text: subtitle,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentPreview(BuildContext context, int index) {
    final attachment = _attachments[index];
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: Container(
            width: ResponsiveSize.width(context, 28),
            color: AppColors.primary,
            child: attachment.type == ProblemAttachmentType.image
                ? Image.file(File(attachment.path), fit: BoxFit.cover)
                : Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: ResponsiveSize.width(context, 10.77),
                    ),
                  ),
          ),
        ),
        Positioned(
          top: 6,
          left: 6,
          child: InkWell(
            onTap: () => _removeAttachment(index),
            child: CircleAvatar(
              radius: ResponsiveSize.width(context, 3.08),
              backgroundColor: Colors.black54,
              child: Icon(Icons.close_rounded, color: Colors.white, size: ResponsiveSize.width(context, 3.85)),
            ),
          ),
        ),
        if (attachment.type == ProblemAttachmentType.video)
          const Positioned(
            right: 8,
            bottom: 8,
            child: Icon(Icons.videocam_rounded, color: Colors.white),
          ),
      ],
    );
  }

  Widget _infoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.secondary),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: customText(
              text:
                  'الصور والفيديو بيتحفظوا في البلاغ. الفيديو بحد أقصى 30 ثانية. رفعهم للباك إند يتم مع إرسال البلاغ.',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCameraPicker(BuildContext context) async {
    final type = await showModalBottomSheet<ProblemAttachmentType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _mediaChoiceSheet(context, camera: true),
    );
    if (type == null) return;

    if (type == ProblemAttachmentType.image) {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 82,
      );
      if (file != null) _addAttachment(file.path, type);
      return;
    }

    final file = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );
    if (file != null) _addAttachment(file.path, type);
  }

  Future<void> _showGalleryPicker(BuildContext context) async {
    final type = await showModalBottomSheet<ProblemAttachmentType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _mediaChoiceSheet(context, camera: false),
    );
    if (type == null) return;

    if (type == ProblemAttachmentType.image) {
      final files = await _picker.pickMultiImage(imageQuality: 82);
      if (files.isEmpty) return;

      final remaining = 6 - _attachments.length;
      final next = [
        ..._attachments,
        ...files.take(remaining).map(
              (file) => ProblemAttachmentModel(
                path: file.path,
                type: ProblemAttachmentType.image,
              ),
            ),
      ];
      widget.onChanged(List.unmodifiable(next));
      return;
    }

    final file = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );
    if (file != null) _addAttachment(file.path, type);
  }

  Widget _mediaChoiceSheet(BuildContext context, {required bool camera}) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customText(
              text: camera ? 'استخدم الكاميرا' : 'اختر من المعرض',
              fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
              color: AppColors.primary,
              isBold: true,
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.5)),
            ListTile(
              leading: Icon(Icons.image_rounded, color: AppColors.secondary),
              title: Text(
                'صورة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.pop(context, ProblemAttachmentType.image),
            ),
            ListTile(
              leading: Icon(
                Icons.videocam_rounded,
                color: AppColors.secondary,
              ),
              title: Text(
                'فيديو حتى 30 ثانية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.pop(context, ProblemAttachmentType.video),
            ),
          ],
        ),
      ),
    );
  }

  void _addAttachment(String path, ProblemAttachmentType type) {
    if (_attachments.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الحد الأقصى 6 مرفقات')),
      );
      return;
    }
    widget.onChanged(
      List.unmodifiable([
        ..._attachments,
        ProblemAttachmentModel(path: path, type: type),
      ]),
    );
  }

  void _removeAttachment(int index) {
    final next = [..._attachments]..removeAt(index);
    widget.onChanged(List.unmodifiable(next));
  }
}

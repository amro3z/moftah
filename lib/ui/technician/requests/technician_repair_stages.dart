import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/repair_status.dart';
import 'package:moftah/data/store/technician_repair_status.dart';
import 'package:moftah/ui/core/helper/date/date_picker_field.dart';
import 'package:moftah/ui/technician/widgets/repair_stages/customer_approval_card.dart';
import 'package:moftah/ui/technician/widgets/repair_stages/customer_chat_button.dart';
import 'package:moftah/ui/technician/widgets/repair_stages/repair_stage_content.dart';
import 'package:moftah/ui/technician/widgets/technician_scaffold.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRepairStages extends StatefulWidget {
  const TechnicianRepairStages({super.key});

  @override
  State<TechnicianRepairStages> createState() => _TechnicianRepairStagesState();
}

class _TechnicianRepairStagesState extends State<TechnicianRepairStages> {
  List<RepairStageItem> stages = List.of(TechnicianRepairStatus.stages);

  CustomerApprovalStatus approvalStatus = CustomerApprovalStatus.approved;

  DateTime? expectedDeliveryDate;

  bool get canSelectDeliveryDate {
    final inspectionIndex = stages.indexWhere(
      (stage) => stage.title == 'جاري الفحص',
    );

    if (inspectionIndex == -1) {
      return false;
    }

    return stages[inspectionIndex].status == RepairStageStatus.completed;
  }

  Future<void> _completeStage(int index) async {
    setState(() {
      stages[index] = stages[index].copyWith(
        status: RepairStageStatus.completed,
      );
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (index + 1 < stages.length) {
      setState(() {
        stages[index + 1] = stages[index + 1].copyWith(
          status: RepairStageStatus.current,
        );
      });
    }
  }

  void _openInspectionDetails() {
    Navigator.pushNamed(context, '/technician/finish_inspection');
  }

  void _openChat() {
    Navigator.pushNamed(context, '/technician/chat');
  }

  @override
  Widget build(BuildContext context) {
    return TechnicianScaffold(
      title: 'مراحل الإصلاح',
      withBackArrow: true,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 3),
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 12),
        ),
        children: [
          ...List.generate(stages.length, (index) {
            final stage = stages[index];

            return RepairTimelineTile(
              stage: stage,
              isFirst: index == 0,
              isLast: index == stages.length - 1,
              onAction: stage.onActionPath != null
                  ? () {
                      Navigator.pushNamed(context, stage.onActionPath!);
                    }
                  : () {
                      _completeStage(index);
                    },
            );
          }),
          SizedBox(height: ResponsiveSize.height(context, 3)),
          DatePickerField(
            title: 'موعد استلام السيارة',
            subtitle: 'حدد اليوم المتوقع لتسليم السيارة',
            value: expectedDeliveryDate,
            enabled: canSelectDeliveryDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            onChanged: (date) {
              setState(() {
                expectedDeliveryDate = date;
              });
            },
          ),
          SizedBox(height: ResponsiveSize.height(context, 2)),
          CustomerApprovalCard(
            status: approvalStatus,
            estimatedCost: 2350,
            onViewDetails: _openInspectionDetails,
          ),
          SizedBox(height: ResponsiveSize.height(context, 2)),
          CustomerChatButton(onTap: _openChat),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/repair_status.dart';
import 'package:moftah/data/store/technician_repair_status.dart';
import 'package:moftah/ui/technician/widgets/repair_stage_content.dart';
import 'package:moftah/ui/technician/widgets/technician_scaffold.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRepairStages extends StatefulWidget {
  const TechnicianRepairStages({super.key});

  @override
  State<TechnicianRepairStages> createState() => _TechnicianRepairStagesState();
}

class _TechnicianRepairStagesState extends State<TechnicianRepairStages> {
  List<RepairStageItem> stages = TechnicianRepairStatus.stages;
  
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

  @override
  Widget build(BuildContext context) {
    return TechnicianScaffold(
      title: 'مراحل الإصلاح',
      withBackArrow: true,
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 3),
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 5),
        ),
        itemCount: stages.length,
        itemBuilder: (context, index) {
          RepairStageItem stage = stages[index];

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
        },
      ),
    );
  }
}




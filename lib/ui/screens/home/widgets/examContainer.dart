import 'package:aurora_student/cubits/authCubit.dart';
import 'package:aurora_student/cubits/examTabSelectionCubit.dart';
import 'package:aurora_student/data/models/subject.dart';
import 'package:aurora_student/ui/widgets/customTabBarContainer.dart';
import 'package:aurora_student/ui/widgets/examOfflineListContainer.dart';
import 'package:aurora_student/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:aurora_student/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/customBackButton.dart';

class ExamContainer extends StatelessWidget {
  final int? childId;
  final List<Subject>? subjects;
  const ExamContainer({Key? key, this.childId, this.subjects})
      : super(key: key);

  Widget _buildAppBar(
      BuildContext context, ExamTabSelectionState currentState,) {
    return ScreenTopBackgroundContainer(
      heightPercentage: 0.15,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            context.read<AuthCubit>().isParent()
                ? const CustomBackButton()
                : const SizedBox(),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                UiUtils.getTranslatedLabel(context, examsKey),
                style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: UiUtils.screenTitleFontSize,),
              ),
            ),


          ],
        );
      },),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamTabSelectionCubit, ExamTabSelectionState>(
      builder: (context, state) {
        return Stack(
          children: [
            (context.read<ExamTabSelectionCubit>().isExamOnline())
                ? Container()
                : ExamOfflineListContainer(
                    childId: childId,
                  ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildAppBar(context, state),
            ),
          ],
        );
      },
    );
  }
}

import 'package:aurora_student/ui/widgets/svgButton.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onTap;
  final double? topPadding;
  final AlignmentDirectional? alignmentDirectional;
  const CustomBackButton(
      {Key? key, this.onTap, this.topPadding, this.alignmentDirectional,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignmentDirectional ?? AlignmentDirectional.topStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: topPadding ?? 0,
          start: UiUtils.screenContentHorizontalPadding,
        ),
        child: IconButton(
          onPressed: () {
              if (onTap != null) {
                onTap?.call();
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: UiUtils.getBackButtonPath(context)),
      ),
    );
  }
}

import 'dart:io';

import 'package:aurora_student/cubits/appConfigurationCubit.dart';
import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateDialogContainer extends StatelessWidget {
  const ForceUpdateDialogContainer({Key? key}) : super(key: key);

  Widget _buildUpdateButton(BuildContext context) {
    return CupertinoButton(
        child: Text(UiUtils.getTranslatedLabel(context, updateKey)),
        onPressed: () async {
          final appUrl = context.read<AppConfigurationCubit>().getAppLink();
          if (await canLaunchUrl(Uri.parse(appUrl))) {
            launchUrl(Uri.parse(appUrl));
          }
        },);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                    UiUtils.getTranslatedLabel(context, newUpdateAvailableKey),),
                actions: [_buildUpdateButton(context)],
              )
            : AlertDialog(
                title: Text(
                    UiUtils.getTranslatedLabel(context, newUpdateAvailableKey),),
                actions: [_buildUpdateButton(context)],
              ),
      ),
    );
  }
}

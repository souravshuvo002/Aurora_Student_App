import 'package:aurora_student/app/routes.dart';
import 'package:aurora_student/cubits/appConfigurationCubit.dart';
import 'package:aurora_student/cubits/authCubit.dart';
import 'package:aurora_student/cubits/changePasswordCubit.dart';
import 'package:aurora_student/data/repositories/authRepository.dart';
import 'package:aurora_student/ui/widgets/changeLanguageBottomsheetContainer.dart';
import 'package:aurora_student/ui/widgets/changePasswordBottomsheet.dart';
import 'package:aurora_student/ui/widgets/customBackButton.dart';
import 'package:aurora_student/ui/widgets/logoutButton.dart';
import 'package:aurora_student/ui/widgets/notificationIconWidget.dart';
import 'package:aurora_student/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:aurora_student/utils/errorMessageKeysAndCodes.dart';

import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({Key? key}) : super(key: key);

  Future<void> _shareApp(BuildContext context) async {
    final appUrl = context.read<AppConfigurationCubit>().getAppLink();
    if (await canLaunchUrl(Uri.parse(appUrl))) {
      launchUrl(Uri.parse(appUrl));
    } else {
      if (context.mounted) {
        UiUtils.showCustomSnackBar(
          context: context,
          errorMessage: UiUtils.getTranslatedLabel(
            context,
            ErrorMessageKeysAndCode.defaultErrorMessageKey,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  Widget _buildAppbar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      child: Stack(
        children: [
          context.read<AuthCubit>().isParent()
              ? const CustomBackButton(
                  alignmentDirectional: AlignmentDirectional.centerStart,
                )
              : const SizedBox(),
          Center(
            child: Text(
              UiUtils.getTranslatedLabel(context, settingsKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: UiUtils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingDetailsTile({
    required String title,
    required Function onTap,
    required BuildContext context,
    required IconData icon,
    Widget? customIcon,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: 10,
          top: 10,
          start: MediaQuery.of(context).size.width * (0.075),
          end: MediaQuery.of(context).size.width * (0.075),
        ),
        child: DecoratedBox(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: customIcon ??
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(BuildContext context) {
    return Column(
      children: [
        if (context.read<AuthCubit>().isParent())
          _buildSettingDetailsTile(
            icon: Icons.notifications, //this is for show only
            customIcon: const NotificationIconWidget(
              size: Size(24, 24),
            ), //this widget will take icon's place
            title: UiUtils.getTranslatedLabel(context, notificationsKey),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.notifications);
            },
            context: context,
          ),
        if (context.read<AuthCubit>().isParent())
          _buildSettingDetailsTile(
            icon: Icons.payment,
            title: UiUtils.getTranslatedLabel(context, feesTransactionKey),
            onTap: () {
              Navigator.of(context).pushNamed(Routes.feesTransaction);
            },
            context: context,
          ),
        _buildSettingDetailsTile(
          icon: Icons.translate,
          title: UiUtils.getTranslatedLabel(context, appLanguageKey),
          onTap: () {
            UiUtils.showBottomSheet(
              child: const ChangeLanguageBottomsheetContainer(),
              context: context,
            );
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.password,
          title: UiUtils.getTranslatedLabel(context, changePasswordKey),
          onTap: () {
            if (UiUtils.isDemoVersionEnable()) {
              UiUtils.showFeatureDisableInDemoVersion(context);
              return;
            }
            UiUtils.showBottomSheet(
              child: BlocProvider<ChangePasswordCubit>(
                create: (_) => ChangePasswordCubit(AuthRepository()),
                child: const ChangePasswordBottomsheet(),
              ),
              context: context,
            ).then((value) {
              if (value != null && !value['error']) {
                UiUtils.showCustomSnackBar(
                  context: context,
                  errorMessage: UiUtils.getTranslatedLabel(
                    context,
                    passwordChangedSuccessfullyKey,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                );
              }
            });
          },
          context: context,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              bottom: UiUtils.getScrollViewBottomPadding(context),
              top: UiUtils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          UiUtils.appBarSmallerHeightPercentage) -
                  10, //10 is the top padding of first item
            ),
            child: Column(
              children: [
                _buildSettingsContainer(context),
                const SizedBox(
                  height: 25.0,
                ),
                const LogoutButton(),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${UiUtils.getTranslatedLabel(context, appVersionKey)}  ${context.read<AppConfigurationCubit>().getAppVersion()}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: 11.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                //extra height to avoide dashboard's bottom navigationbar
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      UiUtils.bottomNavigationHeightPercentage,
                ),
              ],
            ),
          ),
        ),
        _buildAppbar(context),
      ],
    );
  }
}

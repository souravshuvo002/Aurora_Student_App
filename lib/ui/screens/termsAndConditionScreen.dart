import 'package:aurora_student/cubits/appSettingsCubit.dart';
import 'package:aurora_student/data/repositories/systemInfoRepository.dart';
import 'package:aurora_student/ui/widgets/appSettingsBlocBuilder.dart';
import 'package:aurora_student/ui/widgets/customAppbar.dart';
import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider<AppSettingsCubit>(
              create: (context) => AppSettingsCubit(SystemRepository()),
              child: const TermsAndConditionScreen(),
            ),);
  }
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  final String termsAndConditionType = "terms_condition";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context
          .read<AppSettingsCubit>()
          .fetchAppSettings(type: termsAndConditionType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppSettingsBlocBuilder(
            appSettingsType: termsAndConditionType,
          ),
          CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, termsAndConditionKey),)
        ],
      ),
    );
  }
}

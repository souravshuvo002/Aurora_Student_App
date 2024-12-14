import 'package:aurora_student/cubits/appSettingsCubit.dart';
import 'package:aurora_student/data/repositories/systemInfoRepository.dart';
import 'package:aurora_student/ui/widgets/appSettingsBlocBuilder.dart';
import 'package:aurora_student/ui/widgets/customAppbar.dart';
import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider<AppSettingsCubit>(
        create: (context) => AppSettingsCubit(SystemRepository()),
        child: const AboutUsScreen(),
      ),
    );
  }
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final String aboutUsType = "about_us";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<AppSettingsCubit>().fetchAppSettings(type: aboutUsType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppSettingsBlocBuilder(appSettingsType: aboutUsType),
          CustomAppBar(title: UiUtils.getTranslatedLabel(context, aboutUsKey))
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:aurora_student/cubits/resultsOnlineCubit.dart';
import 'package:aurora_student/data/repositories/resultRepository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:aurora_student/app/appLocalization.dart';
import 'package:aurora_student/app/routes.dart';

import 'package:aurora_student/cubits/appConfigurationCubit.dart';
import 'package:aurora_student/cubits/appLocalizationCubit.dart';
import 'package:aurora_student/cubits/authCubit.dart';


import 'package:aurora_student/cubits/noticeBoardCubit.dart';
import 'package:aurora_student/cubits/postFeesPaymentCubit.dart';
import 'package:aurora_student/cubits/reportTabSelectionCubit.dart';
import 'package:aurora_student/cubits/resultTabSelectionCubit.dart';
import 'package:aurora_student/cubits/studentFeesCubit.dart';
import 'package:aurora_student/cubits/studentSubjectAndSlidersCubit.dart';


import 'package:aurora_student/data/repositories/announcementRepository.dart';
import 'package:aurora_student/data/repositories/authRepository.dart';
import 'package:aurora_student/data/repositories/settingsRepository.dart';
import 'package:aurora_student/data/repositories/studentRepository.dart';
import 'package:aurora_student/data/repositories/systemInfoRepository.dart';
import 'package:aurora_student/ui/styles/colors.dart';

import 'package:aurora_student/utils/appLanguages.dart';
import 'package:aurora_student/utils/hiveBoxKeys.dart';
import 'package:aurora_student/utils/notificationUtility.dart';
import 'package:aurora_student/utils/uiUtils.dart';

import '../cubits/examDetailsCubit.dart';
import '../cubits/examTabSelectionCubit.dart';

//to avoide handshake error on some devices
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  //Register the licence of font
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp();

  await NotificationUtility.initializeAwesomeNotification();

  await Hive.initFlutter();
  await Hive.openBox(showCaseBoxKey);
  await Hive.openBox(authBoxKey);

  await Hive.openBox(settingsBoxKey);
  await Hive.openBox(studentSubjectsBoxKey);

  runApp(const MyApp());
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppLocalizationCubit>(
          create: (_) => AppLocalizationCubit(SettingsRepository()),
        ),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
        BlocProvider<StudentSubjectsAndSlidersCubit>(
          create: (_) => StudentSubjectsAndSlidersCubit(
            studentRepository: StudentRepository(),
            systemRepository: SystemRepository(),
          ),
        ),
        BlocProvider<NoticeBoardCubit>(
          create: (context) => NoticeBoardCubit(AnnouncementRepository()),
        ),
        BlocProvider<AppConfigurationCubit>(
          create: (context) => AppConfigurationCubit(SystemRepository()),
        ),
        BlocProvider<ExamTabSelectionCubit>(
          create: (_) => ExamTabSelectionCubit(),
        ),

        BlocProvider<ResultsOnlineCubit>(
          create: (_) => ResultsOnlineCubit(ResultOnlineRepository()),
        ),
        BlocProvider<ExamDetailsCubit>(
          create: (context) => ExamDetailsCubit(StudentRepository()),
        ),
        BlocProvider<ResultTabSelectionCubit>(
          create: (_) => ResultTabSelectionCubit(),
        ),
        BlocProvider<ReportTabSelectionCubit>(
          create: (_) => ReportTabSelectionCubit(),
        ),


      ],
      child: Builder(
        builder: (context) {
          final currentLanguage =
              context.watch<AppLocalizationCubit>().state.language;

          return MaterialApp(
            navigatorKey: UiUtils.rootNavigatorKey,
            theme: Theme.of(context).copyWith(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              scaffoldBackgroundColor: pageBackgroundColor,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: primaryColor,
                    onPrimary: onPrimaryColor,
                    secondary: secondaryColor,
                    background: backgroundColor,
                    error: errorColor,
                    onSecondary: onSecondaryColor,
                    onBackground: onBackgroundColor,
                  ),
            ),
            builder: (context, widget) {
              return ScrollConfiguration(
                behavior: GlobalScrollBehavior(),
                child: widget!,
              );
            },
            locale: currentLanguage,
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: appLanguages.map((appLanguage) {
              return UiUtils.getLocaleFromLanguageCode(
                appLanguage.languageCode,
              );
            }).toList(),
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.splash,
            onGenerateRoute: Routes.onGenerateRouted,
          );
        },
      ),
    );
  }
}

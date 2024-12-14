import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:aurora_student/data/models/appConfiguration.dart';
import 'package:aurora_student/data/models/feesSettings.dart';
import 'package:aurora_student/data/repositories/systemInfoRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppConfigurationState extends Equatable {}

class AppConfigurationInitial extends AppConfigurationState {
  @override
  List<Object?> get props => [];
}

class AppConfigurationFetchInProgress extends AppConfigurationState {
  @override
  List<Object?> get props => [];
}

class AppConfigurationFetchSuccess extends AppConfigurationState {
  final AppConfiguration appConfiguration;

  AppConfigurationFetchSuccess({required this.appConfiguration});
  @override
  List<Object?> get props => [appConfiguration];
}

class AppConfigurationFetchFailure extends AppConfigurationState {
  final String errorMessage;

  AppConfigurationFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AppConfigurationCubit extends Cubit<AppConfigurationState> {
  final SystemRepository _systemRepository;

  AppConfigurationCubit(this._systemRepository)
      : super(AppConfigurationInitial());

  Future<void> fetchAppConfiguration() async {
    emit(AppConfigurationFetchInProgress());
    try {
      final appConfiguration = AppConfiguration.fromJson(
        await _systemRepository.fetchSettings(type: "app_settings") ?? {},
      );
      if (kDebugMode) {
        print("app config - $appConfiguration");
        print("session year - ${appConfiguration.sessionYear.feesDueDate}");
      }
      emit(AppConfigurationFetchSuccess(appConfiguration: appConfiguration));
    } catch (e) {
      emit(AppConfigurationFetchFailure(e.toString()));
    }
  }

  AppConfiguration getAppConfiguration() {
    if (state is AppConfigurationFetchSuccess) {
      return (state as AppConfigurationFetchSuccess).appConfiguration;
    }
    return AppConfiguration.fromJson({});
  }

  String getAppLink() {
    if (state is AppConfigurationFetchSuccess) {
      return Platform.isIOS
          ? getAppConfiguration().iosAppLink
          : getAppConfiguration().appLink;
    }
    return "";
  }

  String getAppVersion() {
    if (state is AppConfigurationFetchSuccess) {
      return Platform.isIOS
          ? getAppConfiguration().iosAppVersion
          : getAppConfiguration().appVersion;
    }
    return "";
  }

  bool appUnderMaintenance() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().appMaintenance == "1";
    }
    return false;
  }

  bool forceUpdate() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().forceAppUpdate == "1";
    }
    return false;
  }

  FeesSettings getFeesSettings() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().feesSettings;
    }
    return FeesSettings.fromJson(Map.from({}));
  }

  bool getOnlineFeesPaymentStatus() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().isOnlineFeesPaymentEnabled == "1";
    }
    return false;
    // isOnlineFeesPaymentEnabled
  }

  String fetchExamRules() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().onlineExamRules;
    }
    return '';
  }
}

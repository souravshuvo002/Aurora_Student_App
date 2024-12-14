import 'package:aurora_student/app/routes.dart';
import 'package:aurora_student/cubits/authCubit.dart';
import 'package:aurora_student/cubits/resetPasswordRequestCubit.dart';
import 'package:aurora_student/cubits/signInCubit.dart';
import 'package:aurora_student/data/repositories/authRepository.dart';
import 'package:aurora_student/data/repositories/settingsRepository.dart';
import 'package:aurora_student/ui/screens/auth/widgets/requestResetPasswordBottomsheet.dart';
import 'package:aurora_student/ui/screens/auth/widgets/termsAndConditionAndPrivacyPolicyContainer.dart';
import 'package:aurora_student/ui/widgets/customCircularProgressIndicator.dart';
import 'package:aurora_student/ui/widgets/customRoundedButton.dart';
import 'package:aurora_student/ui/widgets/customTextFieldContainer.dart';
import 'package:aurora_student/ui/widgets/passwordHideShowButton.dart';
import 'package:aurora_student/utils/constants.dart';
import 'package:aurora_student/utils/labelKeys.dart';
import 'package:aurora_student/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({Key? key}) : super(key: key);

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<SignInCubit>(
            create: (_) => SignInCubit(AuthRepository()),
          ),
        ],
        child: const StudentLoginScreen(),
      ),
    );
  }
}

class _StudentLoginScreenState extends State<StudentLoginScreen>
    with TickerProviderStateMixin {



  final TextEditingController _grNumberTextEditingController =
      TextEditingController(
          text: showDefaultCredentials
              ? defaultStudentGRNumber
              : null); //default grNumber

  final TextEditingController _passwordTextEditingController =
      TextEditingController(
          text: showDefaultCredentials
              ? defaultStudentPassword
              : null); //default password

  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _grNumberTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  void _signInStudent() {
    if (_grNumberTextEditingController.text.trim().isEmpty) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage:
            UiUtils.getTranslatedLabel(context, pleaseEnterGRNumberKey),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    if (_passwordTextEditingController.text.trim().isEmpty) {
      UiUtils.showCustomSnackBar(
        context: context,
        errorMessage:
            UiUtils.getTranslatedLabel(context, pleaseEnterPasswordKey),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    context.read<SignInCubit>().signInUser(
          userId: _grNumberTextEditingController.text.trim(),
          password: _passwordTextEditingController.text.trim(),
          isStudentLogin: true,
        );
  }

  Widget _buildRequestResetPasswordContainer() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GestureDetector(
          onTap: () {
            if (UiUtils.isDemoVersionEnable()) {
              UiUtils.showFeatureDisableInDemoVersion(context);
              return;
            }
            UiUtils.showBottomSheet(
              child: BlocProvider(
                create: (_) => RequestResetPasswordCubit(AuthRepository()),
                child: const RequestResetPasswordBottomsheet(),
              ),
              context: context,
            ).then((value) {
              if (value != null && !value['error']) {
                UiUtils.showCustomSnackBar(
                  context: context,
                  errorMessage: UiUtils.getTranslatedLabel(
                    context,
                    passwordResetRequestKey,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                );
              }
            });
          },
          child: Text(
            "${UiUtils.getTranslatedLabel(context, resetPasswordKey)}?",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }





  Widget _buildLoginForm() {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: NotificationListener(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * (0.075),
                right: MediaQuery.of(context).size.width * (0.075),
                top: MediaQuery.of(context).size.height * (0.25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    UiUtils.getTranslatedLabel(context, letsSignInKey),
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: UiUtils.getColorScheme(context).secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "${UiUtils.getTranslatedLabel(context, welcomeBackKey)}, \n${UiUtils.getTranslatedLabel(context, youHaveBeenMissedKey)}",
                    style: TextStyle(
                      fontSize: 24.0,
                      height: 1.5,
                      color: UiUtils.getColorScheme(context).secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  CustomTextFieldContainer(
                    hideText: false,
                    hintTextKey: grNumberKey,
                    bottomPadding: 0,
                    textEditingController: _grNumberTextEditingController,
                    suffixWidget: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        UiUtils.getImagePath("user_icon.svg"),
                        colorFilter: ColorFilter.mode(
                          UiUtils.getColorScheme(context).secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  CustomTextFieldContainer(
                    textEditingController: _passwordTextEditingController,
                    suffixWidget: PasswordHideShowButton(
                      hidePassword: _hidePassword,
                      onTap: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                    hideText: _hidePassword,
                    hintTextKey: passwordKey,
                    bottomPadding: 0,
                  ),
                  _buildRequestResetPasswordContainer(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: BlocConsumer<SignInCubit, SignInState>(
                      listener: (context, state) {
                        if (state is SignInSuccess) {
                          //
                          context.read<AuthCubit>().authenticateUser(
                                jwtToken: state.jwtToken,
                                isStudent: state.isStudentLogIn,
                                parent: state.parent,
                                student: state.student,
                              );
                          //somehow user logs out, the login will set count to 0
                          SettingsRepository().setNotificationCount(0);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.home,
                            (Route<dynamic> route) => false,
                          );
                        } else if (state is SignInFailure) {
                          UiUtils.showCustomSnackBar(
                            context: context,
                            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                              context,
                              state.errorMessage,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomRoundedButton(
                          onTap: () {
                            if (state is SignInInProgress) {
                              return;
                            }
                            FocusScope.of(context).unfocus();

                            _signInStudent();
                          },
                          widthPercentage: 0.8,
                          backgroundColor:
                              UiUtils.getColorScheme(context).primary,
                          buttonTitle:
                              UiUtils.getTranslatedLabel(context, signInKey),
                          titleColor: Theme.of(context).scaffoldBackgroundColor,
                          showBorder: false,
                          child: state is SignInInProgress
                              ? const CustomCircularProgressIndicator(
                                  strokeWidth: 2,
                                  widthAndHeight: 20,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildLoginForm(),
        ],
      ),
    );
  }
}

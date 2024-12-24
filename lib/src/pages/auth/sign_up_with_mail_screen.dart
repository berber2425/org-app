import 'dart:async';

import 'package:org_app/src/components/buttons/app_button.dart';
import 'package:org_app/src/components/inputs/app_form_field.dart';
import 'package:org_app/src/constants/app_textstyle.dart';
import 'package:org_app/src/constants/icons.dart';
import 'package:org_app/src/scaffolds/auth_scaffold.dart';
import 'package:org_app/src/utils/auth.dart';
import 'package:org_app/src/utils/validators.dart';
import 'package:org_app/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sign_flutter/sign_flutter.dart';
import 'auth_scaffold.dart';
import 'package:org_data/org_data.dart';

class UserBanner extends StatelessWidget {
  const UserBanner({super.key, required this.user});

  final Fragment$PublicUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        ImggenUserAvatar(avatar: user.avatar),
        Text(
          user.name,
          style: textTheme(context).titleLargeBold.copyWith(fontSize: 24),
        ),
      ],
    );
  }
}

enum _Stage {
  email,
  password,
  newPassword,
  userName,
  verification,
  forgotVerification,
  forgotNewPassword,
}

final class _StageConfig {
  final String pageTitle, buttonTitle;
  final Widget buttonIcon;
  final FutureOr<void> Function() nextPage;
  final Signal<bool> valid;
  final FocusNode? focusNode;
  final Widget page;
  final _Stage stage;

  _StageConfig({
    required this.nextPage,
    required this.valid,
    required this.focusNode,
    required this.pageTitle,
    required this.buttonTitle,
    required this.buttonIcon,
    required this.page,
    required this.stage,
  });

  @override
  int get hashCode =>
      super.hashCode ^
      pageTitle.hashCode ^
      buttonTitle.hashCode ^
      buttonIcon.hashCode;

  @override
  bool operator ==(Object other) {
    return super == other && other is _StageConfig;
  }
}

class SignUpWithMailScreen extends StatefulWidget {
  const SignUpWithMailScreen({super.key});

  @override
  State<SignUpWithMailScreen> createState() => _SignUpWithMailScreenState();
}

class _SignUpWithMailScreenState extends State<SignUpWithMailScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final verificationController = TextEditingController();
  final forgotPasswordController = TextEditingController();

  final pageController = PageController();

  final Signal<bool> isLoading = false.signal;

  Fragment$PublicUser? user;

  List<Enum$Providers>? availableMethods;

  // initial
  _submitEmail() async {
    if (emailValidator(emailController.text) == null) {
      final res = await Api.auth.query.getProvider(emailController.text);

      user = res.user;
      availableMethods = res.providers;

      setState(() {
        emailSubmitted = true;
      });

      if (availableMethods!.isEmpty) {
        addStage(_Stage.newPassword);
      } else {
        addStage(_Stage.password);
      }
    }
  }

  // sign in
  _submitSignInPassword() async {
    if (passwordValidator(passwordController.text) == null) {
      isLoading.value = true;
      try {
        final auth = AuthController();
        await auth.signInWithEmail(
          emailController.text,
          passwordController.text,
        );
        if (auth.hasVerificationSession) {
          addStage(_Stage.verification);
        } else {
          if (auth.isAuthenticated) {
            if (mounted) Navigator.of(context).pop();
          } else {
            if (kDebugMode) {
              print(auth);
            }
            // Get.snackbar('Error', 'Verification failed. Unknown error.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        // Get.snackbar('Error', e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  // sign up - 1
  _submitSignUpNewPassword() async {
    if (passwordValidator(newPasswordController.text) == null) {
      addStage(_Stage.userName);
    }
  }

  // sign up - 2
  _submitSignUpUserName() async {
    if (usernameValidator(userNameController.text) == null) {
      isLoading.value = true;
      try {
        final auth = AuthController();
        await auth.signUpWithEmail(
          emailController.text,
          newPasswordController.text,
          userNameController.text,
        );
        if (auth.hasVerificationSession) {
          addStage(_Stage.verification);
        } else {
          // Get.snackbar('Error', 'Verification failed. Unknown error.');
        }
      } catch (e) {
        // Get.snackbar('Error', e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  // sign up - 3 | sign in - 2
  _submitSignUpInVerification() async {
    if (verificationValidator(verificationController.text) != null) {
      return;
    }

    try {
      final auth = AuthController();
      await auth.verifyEmail(verificationController.text);
      // Get.snackbar('Success', 'Email verified successfully');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.of(context).pushNamed("/");
      });
    } catch (e) {
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // forgot password - 1
  _submitForgotVerification() async {
    if (verificationValidator(verificationController.text) != null) {
      return;
    }
    try {
      final auth = AuthController();
      await auth.verifyForgotPassword(verificationController.text);
      // Get.snackbar('Success', 'Email verified successfully');
      addStage(_Stage.forgotNewPassword);
    } catch (e) {
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // forgot password - 2
  _submitNewPwdForgot() async {
    try {
      if (passwordValidator(forgotPasswordController.text) != null) {
        return;
      }

      final auth = AuthController();
      await auth.setNewPwd(forgotPasswordController.text);
      // Get.snackbar('Success', 'Password changed successfully');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.of(context).pushNamed("/");
      });
    } catch (e) {
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool emailSubmitted = false;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final verificationFocusNode = FocusNode();
  final forgotPasswordFocusNode = FocusNode();

  final emailValid = false.signal;
  final passwordValid = false.signal;
  final newPasswordValid = false.signal;
  final userNameValid = false.signal;
  final verificationValid = false.signal;
  final forgotPasswordValid = false.signal;

  double height = 190;

  Widget _page(Widget child) {
    return Builder(
      builder: (ctx) {
        return SingleChildScrollView(
          child: MeasureSize(
            onChange: (size) {
              setState(() {
                height = size.height + 100;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [child],
            ),
          ),
        );
      },
    );
  }

  late Map<_Stage, _StageConfig> stageConfigs = {
    _Stage.email: _emailStage(),
    _Stage.password: _passwordStage(),
    _Stage.newPassword: _newPwdStage(),
    _Stage.userName: _userNameStage(),
    _Stage.verification: _verificationStage(),
    _Stage.forgotVerification: _verificationStage(true),
    _Stage.forgotNewPassword: _forgotNewPwdStage(),
  };

  _StageConfig _emailStage() {
    return _StageConfig(
      stage: _Stage.email,
      nextPage: _submitEmail,
      valid: emailValid,
      focusNode: emailFocusNode,
      pageTitle: 'Welcome to',
      buttonTitle: 'Next',
      buttonIcon: ImgGenIcons.name(ImgGenIconNames.email),
      page: AppTextFormField(
        focusNode: emailFocusNode,
        label: 'E-Mail',
        onEditingComplete: _submitEmail,
        controller: emailController,
        valid: emailValid,
        validator: emailValidator,
        autofillHints: const [AutofillHints.email],
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  // sign in
  _StageConfig _passwordStage() {
    return _StageConfig(
      stage: _Stage.password,
      nextPage: _submitSignInPassword,
      valid: passwordValid,
      focusNode: passwordFocusNode,
      pageTitle: 'Sign In to',
      buttonTitle: 'Sign In',
      buttonIcon: ImgGenIcons.name(ImgGenIconNames.email),
      page: Builder(
        builder: (ctx) {
          final hasPwd = availableMethods!.contains(Enum$Providers.EMAIL);
          final hasGoogle = availableMethods!.contains(Enum$Providers.GOOGLE);
          final hasApple = availableMethods!.contains(Enum$Providers.APPLE);

          return Column(
            spacing: 12,
            children: [
              if (user != null) UserBanner(user: user!),
              AppButton(
                size: AppButtonSize.small,
                variant: AppButtonVariant.text,
                onPressed: () {
                  addStage(_Stage.email);
                },
                title: const Text("Not you?"),
              ),
              if (hasPwd)
                AppTextFormField(
                  label: "Password",
                  validator: passwordValidator,
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  valid: passwordValid,
                  onEditingComplete: _submitSignInPassword,
                ),
              if (hasApple || hasGoogle)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Or continue with'),
                ),
              if (hasGoogle) const GoogleSignInButton(),
              if (hasApple) const AppleSignInButton(),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  AppButton(
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.text,
                    onPressed: () async {
                      final auth = AuthController();

                      await auth.forgotPassword(emailController.text);

                      if (auth.hasVerificationSession) {
                        addStage(_Stage.forgotVerification);
                      } else {
                        // Get.snackbar(
                        //     'Error', 'Verification failed. Unknown error.');
                      }
                    },
                    title: const Text("Forgot password?"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // sign up - 1
  _StageConfig _newPwdStage() {
    return _StageConfig(
      stage: _Stage.newPassword,
      nextPage: _submitSignUpNewPassword,
      valid: newPasswordValid,
      focusNode: newPasswordFocusNode,
      pageTitle: 'Sign Up to',
      buttonTitle: 'Next',
      buttonIcon: ImgGenIcons.name(ImgGenIconNames.next),
      page: AppTextFormField(
        focusNode: newPasswordFocusNode,
        label: 'New Password',
        hint: 'Enter your new password',
        controller: newPasswordController,
        valid: newPasswordValid,
        validator: passwordValidator,
        obscureText: true,
        autofillHints: const [
          AutofillHints.password,
          AutofillHints.newPassword,
        ],
        onEditingComplete: _submitSignUpNewPassword,
      ),
    );
  }

  // sign up - 2
  _StageConfig _userNameStage() {
    return _StageConfig(
      stage: _Stage.userName,
      nextPage: _submitSignUpUserName,
      valid: userNameValid,
      focusNode: userNameFocusNode,
      pageTitle: 'Sign Up to',
      buttonTitle: 'Sign Up',
      buttonIcon: ImgGenIcons.name(ImgGenIconNames.next),
      page: AppTextFormField(
        focusNode: userNameFocusNode,
        label: 'Username',
        hint: 'Enter your username',
        controller: userNameController,
        valid: userNameValid,
        validator: usernameValidator,
        autofillHints: const [AutofillHints.username],
        onEditingComplete: _submitSignUpUserName,
      ),
    );
  }

  // sign up - 3 | sign in - 2 | forgot password - 1
  _StageConfig _verificationStage([bool forgot = false]) {
    final next =
        forgot ? _submitForgotVerification : _submitSignUpInVerification;
    return _StageConfig(
      stage: forgot ? _Stage.forgotVerification : _Stage.verification,
      nextPage: next,
      valid: verificationValid,
      focusNode: verificationFocusNode,
      pageTitle: 'Verify with',
      buttonTitle: 'Verify',
      buttonIcon: ImgGenIcons.name(ImgGenIconNames.next),
      page: AppTextFormField(
        focusNode: verificationFocusNode,
        label: 'Verification Code',
        hint: 'Enter your 6 digit verification code',
        controller: verificationController,
        valid: verificationValid,
        validator: verificationValidator,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        onEditingComplete: next,
      ),
    );
  }

  // forgot password - 2
  _StageConfig _forgotNewPwdStage() {
    return _StageConfig(
      stage: _Stage.forgotNewPassword,
      nextPage: _submitNewPwdForgot,
      valid: forgotPasswordValid,
      focusNode: forgotPasswordFocusNode,
      pageTitle: 'Set New Password',
      buttonTitle: 'Set Password',
      buttonIcon: ImgGenIcons.name(ImgGenIconNames.next),
      page: AppTextFormField(
        focusNode: forgotPasswordFocusNode,
        label: 'New Password',
        hint: 'Enter your new password',
        controller: forgotPasswordController,
        valid: forgotPasswordValid,
        validator: passwordValidator,
        keyboardType: TextInputType.visiblePassword,
        autofillHints: const [AutofillHints.newPassword],
        onEditingComplete: _submitNewPwdForgot,
      ),
    );
  }

  _nextFrame(Function() callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  int currentStage = 0;

  int _stageIndex(_Stage stage) {
    return _Stage.values.indexOf(stage);
  }

  addStage(_Stage stage) {
    final config = stageConfigs[stage]!;
    _nextFrame(() {
      pageController
          .animateToPage(
            _stageIndex(stage),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          )
          .then((_) {
            _nextFrame(() {
              config.focusNode?.requestFocus();
              setState(() {
                currentStage = _stageIndex(stage);
              });
            });
          });
    });
  }

  _StageConfig get currentConfig {
    return stageConfigs[_Stage.values[currentStage]]!;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      key: const ValueKey("sign-up-with-mail"),
      title: currentConfig.pageTitle,
      children: [
        AnimatedContainer(
          height: height,
          duration: const Duration(milliseconds: 300),
          child: Column(
            spacing: 24,
            children: [
              Expanded(
                child: AppForm(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {},
                    controller: pageController,
                    children: stageConfigs.values
                        .map((e) => _page(e.page))
                        .toList(growable: false),
                  ),
                ),
              ),
              [currentConfig.valid, isLoading].multiSignal.builder((_) {
                return AppButton(
                  isLoading: isLoading.value,
                  isActive: currentConfig.valid.value,
                  onPressed: currentConfig.nextPage,
                  key: ValueKey("button-$currentStage"),
                  title: Padding(
                    key: ValueKey("button-title-padding-$currentStage"),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      spacing: 4,
                      children: [
                        Text(currentConfig.buttonTitle),
                        currentConfig.buttonIcon,
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

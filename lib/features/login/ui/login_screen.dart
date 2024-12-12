import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/features/chat/ui/chat_screen.dart';
import 'package:public_chat/features/country/country.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/widgets/sign_in_button.dart';
import 'package:public_chat/l10n/text_ui_static.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/functions_alert_dialog.dart';
import 'package:public_chat/utils/helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.currentCountryCode,
    required this.currentLanguageCode,
    this.textsUIStaticForTest,
  });

  final String currentCountryCode;
  final String currentLanguageCode;
  final Map<String, Map<String, String>>? textsUIStaticForTest;

  void _handleActionLoginSuccess(
    BuildContext context,
    Map<String, Map<String, String>> textsUIStatic,
  ) {
    FunctionsAlertDialog.showAlertFlushBar(
      context,
      Helper.getTextTranslated(
        'loginSuccessMessage',
        currentLanguageCode,
        textsUIStatic,
      ),
      true,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            context.read<LoginCubit>().checkCountryCodeLocalExisted()
                ? ChatScreen(
                    currentCountryCode: currentCountryCode,
                    currentLanguageCode: currentLanguageCode,
                  )
                : CountryScreen(
                    currentCountryCode: currentCountryCode,
                    currentLanguageCode: currentLanguageCode,
                  ),
      ),
    );
  }

  void _handleActionLoginFailure(
    BuildContext context,
    Map<String, Map<String, String>> textsUIStatic,
  ) {
    FunctionsAlertDialog.showAlertFlushBar(
      context,
      Helper.getTextTranslated(
        'loginFailMessage',
        currentLanguageCode,
        textsUIStatic,
      ),
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textsUIStatic = textsUIStaticForTest ??
        ServiceLocator.instance.get<TextsUIStatic>().texts;
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is LoginLoading ||
          current is LoginSuccess ||
          current is LoginFailed,
      listener: (context, state) async {
        if (state is LoginLoading) {
          await FunctionsAlertDialog.showLoadingDialog(context);
        } else {
          Navigator.of(context).pop();
        }
        if (state is LoginSuccess && context.mounted) {
          _handleActionLoginSuccess(context, textsUIStatic);
        }
        if (state is LoginFailed && context.mounted) {
          _handleActionLoginFailure(context, textsUIStatic);
        }
      },
      child: Scaffold(
        body: Center(
          child: buildSignInButton(
            label: Helper.getTextTranslated(
              'loginTitle',
              currentLanguageCode,
              textsUIStatic,
            ),
            onPressed: () => context.read<LoginCubit>().requestLogin(),
          ),
        ),
      ),
    );
  }
}

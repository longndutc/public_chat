import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';
import 'package:public_chat/l10n/text_ui_static.dart';

import '../../../material_wrapper_extension.dart';

class MockTextsUIStatic extends Mock implements TextsUIStatic {}

void main() {
  final getIt = GetIt.instance;
  final mockTextsUIStatic = MockTextsUIStatic();

  setUp(() {
    getIt.registerSingleton<MockTextsUIStatic>(mockTextsUIStatic);

    when(() => mockTextsUIStatic.texts).thenReturn({
      'loginTitle': {'vi': 'Đăng nhập', 'en': 'Login'}
    });
  });

  tearDown(() {
    getIt.reset();
  });

  group(
    'test localisation',
    () {
      testWidgets(
        'Displays login button with country code VN',
        (widgetTester) async {
          Widget widget = LoginScreen(
            currentCountryCode: 'VN',
            currentLanguageCode: 'vi',
            textsUIStaticForTest: getIt.get<MockTextsUIStatic>().texts,
          );

          await widgetTester.wrapAndPump(widget);

          expect(
            find.byWidget(
              ElevatedButton(
                onPressed: () {},
                child: const Text('Đăng nhập'),
              ),
            ),
            findsOneWidget,
          );
        },
      );

      testWidgets(
        'Displays login button with country code US',
        (widgetTester) async {
          Widget widget = LoginScreen(
            currentCountryCode: 'US',
            currentLanguageCode: 'en',
            textsUIStaticForTest: getIt.get<MockTextsUIStatic>().texts,
          );

          await widgetTester.wrapAndPump(widget);

          expect(
              find.byWidget(
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                ),
              ),
              findsOneWidget);
        },
      );
    },
  );
}

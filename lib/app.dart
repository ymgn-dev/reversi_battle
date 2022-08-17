import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/game_page.dart';
import 'package:reversi_battle/generated/l10n.dart';
import 'package:reversi_battle/utils/navigator_key.dart';
import 'package:reversi_battle/utils/res/res.dart';
import 'package:reversi_battle/utils/scaffold_messenger_key.dart';

class App extends HookConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        navigatorKey: ref.read(navigatorKeyProvider),
        scaffoldMessengerKey: ref.read(scaffoldMessengerKeyProvider),
        onGenerateTitle: (context) => L.of(context).appTitle,
        useInheritedMediaQuery: true,
        theme: appThemeLight(),
        darkTheme: appThemeDark(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          L.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L.delegate.supportedLocales,
        home: const GamePage());
  }
}

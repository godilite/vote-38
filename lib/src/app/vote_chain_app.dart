import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moon_design/moon_design.dart';
import 'package:toastification/toastification.dart';
import 'package:vote38/src/navigation/router.dart';
import 'package:vote38/src/settings/model/setting.dart';

GoRouter? appRouter;

class VoteChainApp extends StatefulWidget {
  const VoteChainApp({super.key});

  @override
  State<VoteChainApp> createState() => _VoteChainAppState();
}

class _VoteChainAppState extends State<VoteChainApp> {
  @override
  void initState() {
    appRouter = AppRouter().router;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ValueListenableBuilder(
        valueListenable: Hive.box<Setting>(Setting.boxName).listenable(),
        builder: (_, box, ___) {
          final settings = box.get('settings', defaultValue: Setting(isDarkMode: true))!;
          return MaterialApp.router(
            title: 'Vote Chain',
            theme: ThemeData.light().copyWith(
              appBarTheme: Theme.of(context).appBarTheme.copyWith(systemOverlayStyle: SystemUiOverlayStyle.light),
              splashFactory: NoSplash.splashFactory,
              scaffoldBackgroundColor: const Color(0xFFFFFFFF),
              textTheme: ThemeData.light().textTheme.apply(fontFamily: 'RedHatText'),
              extensions: <ThemeExtension<dynamic>>[
                MoonTheme(
                  tokens: MoonTokens.light,
                ),
              ],
            ),
            darkTheme: ThemeData.dark().copyWith(
              splashFactory: NoSplash.splashFactory,
              scaffoldBackgroundColor: const Color(0xFF000000),
              textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'RedHatText'),
              extensions: <ThemeExtension<dynamic>>[
                MoonTheme(
                  tokens: MoonTokens.dark,
                ),
              ],
            ),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter,
            builder: (context, child) {
              return NotificationListenerWrapper(
                child: Scaffold(
                  body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600), child: child)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationListenerWrapper extends StatefulWidget {
  final Widget child;
  const NotificationListenerWrapper({super.key, required this.child});

  @override
  State<NotificationListenerWrapper> createState() => _NotificationListenerWrapperState();
}

class _NotificationListenerWrapperState extends State<NotificationListenerWrapper> {
  @override
  void initState() {
    Hive.box<int>('progress').watch().listen((event) {
      toastification.show(
        type: ToastificationType.info,
        showProgressBar: true,
        autoCloseDuration: const Duration(seconds: 2),
        title: Text('NFT Minting Progress ${event.value}'),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

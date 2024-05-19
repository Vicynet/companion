import 'package:companion/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:companion/app/app.bottomsheets.dart';
import 'package:companion/app/app.dialogs.dart';
import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.router.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kcAlternateColor, // Change to your desired color
    ));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }
}

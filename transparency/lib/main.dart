import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparency/pages/card_page.dart';
import 'package:transparency/pages/modal_page.dart';

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(MyApp(
    navigatorKey: navigatorKey,
  ));

  const channel = MethodChannel("method-channel");
  channel.setMethodCallHandler((call) async {
    if (call.method == "navigate") {
      final pageName = call.arguments as String;
      navigatorKey.currentState?.pushReplacementNamed(pageName);
    }
  });
}

class MyApp extends StatelessWidget {
  // This is a workaround. Do not copy.
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: _createMaterialColor(const Color(0xFF7D5260)),
      ),
      // It's important to actually follow the route (in Flutter) so that the
      // PageRouteBuilder's code runs. If you set your modal page as the initial
      // route in native code, you don't get a transparent background here.
      // Prefer using an interop navigator.
      initialRoute: "home",
      navigatorKey: navigatorKey,
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "modal") {
          return PageRouteBuilder(
            settings:
                routeSettings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), work
            pageBuilder: (_, __, ___) => const ModalPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            barrierDismissible: true,
            fullscreenDialog: true,
            opaque: false,
          );
        } else if (routeSettings.name == "card") {
          return PageRouteBuilder(
            settings:
                routeSettings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), work
            pageBuilder: (_, __, ___) => const CardPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            barrierDismissible: true,
            fullscreenDialog: true,
            opaque: false,
          );
        } else {
          // Unknown route.
          return null;
        }
      },
      routes: {
        "home": (context) => const MyHomePage(),
        // "modal": (context) => const ModalPage(), // Call onGenerateRoute instead
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // A fully transparent page to render at the bottom.
    return Scaffold(
      appBar: null,
      body: Container(color: Colors.transparent),
    );
  }
}

MaterialColor _createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  // ignore: avoid_function_literals_in_foreach_calls
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

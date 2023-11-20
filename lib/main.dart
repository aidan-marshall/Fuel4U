import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fuel_app/model/fuel_price.dart';
import 'package:fuel_app/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';


main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
      create: (context) => FuelPriceModel(),
      builder: (context, child) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fuel4U',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
      );
  }
}

final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const MyHomePage(title: 'Fuel4U'),
          routes: [
            GoRoute(
                path: 'sign-in',
                builder: (context, state) {
                  return SignInScreen(
                    actions: [AuthStateChangeAction((
                            (context, state) {
                      context.pushReplacement('/');
                    })),],
                  );
                }
            )
          ]
      ),
    ]
);
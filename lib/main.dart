import 'package:flutter/material.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/routes.dart';
import 'package:store_app/screens/home_screen.dart';
import 'package:store_app/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: MaterialColors.grey,
          fontFamily: 'SF Regular',
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MaterialColors.primary)),
          )),
    );
  }
}

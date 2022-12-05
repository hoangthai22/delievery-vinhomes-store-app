import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store_app/apis/apiService.dart';
import 'package:store_app/constants/Theme.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/models/storeModel.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/routes.dart';
import 'package:store_app/screens/home_screen.dart';
import 'package:store_app/screens/login_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // you need to initialize firebase first
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppProvider()),
    ],
    child: const MyApp(),
  ));
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
          tabBarTheme: TabBarTheme(
              labelColor: MaterialColors.primary,
              labelStyle: TextStyle(fontFamily: "SF SemiBold", fontSize: 16),
              unselectedLabelColor: Colors.black54,
              unselectedLabelStyle:
                  TextStyle(fontFamily: "SF SemiBold", fontSize: 16),
              indicator: UnderlineTabIndicator(
                  // color for indicator (underline)
                  borderSide:
                      BorderSide(color: MaterialColors.primary, width: 3))),
          fontFamily: 'SF Regular',
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MaterialColors.primary)),
          )),
    );
  }
}

class LandingScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  checkUserAuth() async {
    try {
      User user = auth.currentUser!;
      return user;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUserAuth().then((success) {
      if (success != null) {
        context.read<AppProvider>().setUserLogin(success.email);
        context.read<AppProvider>().setUid(success.uid);
        StoreModel store = StoreModel();
        ApiServices.getStoreById(success.email)
            .then((value) => {
                  store = value,
                  context.read<AppProvider>().setName(store.name),
                  context.read<AppProvider>().setAvatar(store.image),
                  context.read<AppProvider>().setStoreModel(store),
                  context.read<AppProvider>().setStatus(store.status!),
                  Navigator.pushReplacementNamed(context, '/home')
                })
            .catchError((onError) => {print(onError)});
      } else {
        print("login");
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Scaffold(
      body: Center(
        child: SpinKitFoldingCube(
          color: MaterialColors.primary,
          size: 50.0,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/provider/appProvider.dart';
import 'package:store_app/screens/home_screen.dart';
import 'package:store_app/screens/menu_screen.dart';
import 'package:store_app/screens/product_list_screen.dart';
import 'package:store_app/screens/profile_screen.dart';
import 'package:store_app/screens/transaction_sreen.dart';
import 'package:store_app/widgets/bottomBar/bottom_navbar.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  var _currentTab = TabItem.home;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.product: GlobalKey<NavigatorState>(),
    TabItem.menu: GlobalKey<NavigatorState>(),
    TabItem.transaction: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // PushNotificationModel? _notificationInfo;
  // FirebaseFirestore db = FirebaseFirestore.instance;
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // void registerNotification() async {
  //   await Firebase.initializeApp();
  //   messaging = FirebaseMessaging.instance;

  //   NotificationSettings settings = await messaging.requestPermission(
  //       alert: true, badge: true, provisional: false, sound: true);
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       print("on app");
  //       PushNotificationModel notification = PushNotificationModel(
  //           title: message.notification!.title,
  //           body: message.notification!.body,
  //           dataTitle: message.data['title'],
  //           dataBody: message.data['body']);

  //       setState(() {
  //         _notificationInfo = notification;
  //       });
  //       print("body: ${notification.body}");
  //       print("title: ${notification.title}");
  //       if (notification != null) {
  //         _showNotification(
  //             _notificationInfo!.title!, _notificationInfo!.body!);
  //       }
  //     });
  //   } else {
  //     print("not permission");
  //   }
  // }

  // Future<void> _showNotification(String title, String content) async {
  //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails('your channel id', 'your channel name',
  //           channelDescription: 'your channel description',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           icon: '@drawable/logo_transparent',
  //           tag: "TWE",
  //           ticker: 'ticker');

  //   final NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin
  //       .show(0, title, content, platformChannelSpecifics, payload: 'item x');
  // }

  // @override
  // void initState() {
  //   var initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var initializationSettingsIOS = IOSInitializationSettings();
  //   var initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: (value) {
  //     Navigator.pushNamed(context, "/notification");
  //   });

  //   registerNotification();
  //   checkForInitialMessage();
  //   super.initState();
  //   UserModel user;
  //   ApiServices.getProfileByUsername(context.read<AppProvider>().getUid)
  //       .then((value) => {
  //             print("value12321: $value"),
  //             if (value != null)
  //               {
  //                 user = value,
  //                 context.read<AppProvider>().setAvatar(user.image)
  //               }
  //           });
  // }

  // checkForInitialMessage() async {
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //   if (initialMessage != null) {
  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //       Navigator.pushNamed(context, "/notification");
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return Consumer<AppProvider>(builder: (context, provider, child) {
    return WillPopScope(onWillPop: () async {
      // if (provider.getIsLogin == true) {
      final isFirstRouteInCurrentTab =
          !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
      if (isFirstRouteInCurrentTab) {
        // if not on the 'main' tab
        if (_currentTab != TabItem.home) {
          // select 'main' tab
          _selectTab(TabItem.home);
          // back button handled by app
          return false;
        }
      }
      // let system handle back button if we're on the first route
      return isFirstRouteInCurrentTab;
    },
        // },
        child: Consumer<AppProvider>(builder: (context, provider, child) {
      var storeId = context.read<AppProvider>().getUserId ?? "";
      List<Widget> widgetOptions = <Widget>[
        HomeScreen(),
        ProductListScreen(
          storeId: storeId,
        ),
        MenuScreen(storeId: storeId),
        TransactionSreen(),
        ProfileScreen()
      ];
      return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: widgetOptions.elementAt(_currentTab.index),
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              primaryColor: Colors.red,
            ),
            child: BottomNavbar(
              currentTab: _currentTab,
              onSelectTab: _selectTab,
            ),
          ));
    }));
    // });
  }
}

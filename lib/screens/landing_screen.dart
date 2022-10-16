// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:store_app/provider/appProvider.dart';

// class LandingScreen extends StatelessWidget {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   checkUserAuth() async {
//     try {
//       User user = await auth.currentUser!;
//       return user;
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     checkUserAuth().then((success) {
//       if (success != null) {
//         print("login");
//         context.read<AppProvider>().setUserLogin(success.email);
//         context.read<AppProvider>().setUid(success.uid);
//         context.read<AppProvider>().setIsLogin();

//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     });

//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

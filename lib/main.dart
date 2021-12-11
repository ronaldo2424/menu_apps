import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:menu_apps/home_page.dart';
import 'package:menu_apps/login_page.dart';

final storage = FlutterSecureStorage();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            if (snapshot.data != "") {
              var str = snapshot.data;
              String strs = str.toString();
              var jwt = strs.split(".");

              if (jwt.length != 3) {
                return LoginPage();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  return HomePage(strs, payload);
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          }),
    );
  }
}

// class LoginCheck extends StatefulWidget {
//   const LoginCheck({Key? key}) : super(key: key);

//   @override
//   _LoginCheckState createState() => _LoginCheckState();
// }

// class _LoginCheckState extends State<LoginCheck> {
//   Future<bool> loginChecker() async {
//     SharedPreferences prefsLogin = await SharedPreferences.getInstance();

//     if (prefsLogin.getString("email") == null) {
//       return false;
//     } else {
//       return true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: loginChecker(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data == true) {
//             return HomePage();
//           } else {
//             return LoginPage();
//           }
//         } else {
//           return Scaffold(body: Center(child: CircularProgressIndicator()));
//         }
//       },
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:menu_apps/const.dart';
import 'package:http/http.dart' as http;
import 'package:menu_apps/home_page.dart';
import 'package:menu_apps/main.dart';
import 'package:menu_apps/register_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  Future<String> attemptLogIn(String email, String password) async {
    print(email);
    print(password);
    var res = await http.post(Uri.parse("$baseURL/api/login"),
        body: {"email": email, "password": password});
    print(res.statusCode);
    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return data['data']['token'];
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Aplikasi Menu Makanan",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 200),
              width: MediaQuery.of(context).size.width - 30,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "email",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "password",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return RegisterPage();
                          },
                        ));
                      },
                      child: Text("belum punya akun?")),
                  GestureDetector(
                    onTap: () async {
                      var username = _emailController.text;
                      var password = _passwordController.text;
                      var jwt = await attemptLogIn(username, password);
                      if (jwt != "") {
                        storage.write(key: "jwt", value: jwt);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage.fromBase64(jwt)));
                      } else {
                        displayDialog(context, "An Error Occurred",
                            "Akun tidak ditemukan");
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

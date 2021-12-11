import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:menu_apps/const.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  Future<int> attemptSignUp(String name, String email, String password) async {
    var res = await http.post(Uri.parse("$baseURL/api/register"),
        body: {"name": name, "email": email, "password": password});
    return res.statusCode;
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
              height: 340,
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "nama",
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
                        Navigator.pop(context);
                      },
                      child: Text("sudah punya akun?")),
                  GestureDetector(
                    onTap: () async {
                      var name = _nameController.text;
                      var email = _emailController.text;
                      var password = _passwordController.text;

                      if (email.length < 4)
                        displayDialog(context, "Invalid Username",
                            "The username should be at least 4 characters long");
                      else if (password.length < 4)
                        displayDialog(context, "Invalid Password",
                            "The password should be at least 4 characters long");
                      else {
                        var res = await attemptSignUp(name, email, password);
                        if (res == 201) {
                          displayDialog(context, "Success",
                              "The user was created. Log in now.");
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        } else if (res == 409)
                          displayDialog(
                              context,
                              "That username is already registered",
                              "Please try to sign up using another username or log in if you already have an account.");
                        else {
                          displayDialog(
                              context, "Error", "An unknown error occurred.");
                        }
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
                          "DAFTAR",
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

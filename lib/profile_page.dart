import 'package:flutter/material.dart';
import 'package:menu_apps/main.dart';

class ProfilePage extends StatelessWidget {
  final Map payload;
  const ProfilePage({
    required this.payload,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              margin: EdgeInsets.only(top: 40, bottom: 14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.shade100,
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.25),
                child: Image.asset(
                  "assets/default_pp.png",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Nama",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
              child: Text(
                this.payload['data']['name'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Email",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
              child: Text(
                this.payload['data']['email'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              onTap: () {
                storage.delete(key: "jwt");
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return MyApp();
                    },
                  ), (route) => false);
                });
              },
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

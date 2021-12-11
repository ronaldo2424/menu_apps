import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:menu_apps/const.dart';
import 'package:menu_apps/edit_page.dart';
import 'package:http/http.dart' as http;
import 'package:menu_apps/main.dart';

class DetailMenuPage extends StatelessWidget {
  final Map menu;
  const DetailMenuPage({
    required this.menu,
    Key? key,
  }) : super(key: key);

  Future _deleteMenu(String id, context) async {
    var response = await http.delete(
      Uri.parse("$baseURL/api/delete/" + id),
    );

    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return MyApp();
          },
        ), (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Menu"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EditPage(
                    menu: this.menu,
                  );
                },
              ));
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deleteMenu(
                this.menu['id'].toString(),
                context,
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - 100,
              // color: Colors.red,

              child: Image.network(
                baseURL + this.menu['image'],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
              child: Text(
                this.menu['name'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
              child: Text(
                "Rp. " + this.menu['price'],
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
              padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.grey.shade300,
              ),
              child: Text(
                this.menu['description'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

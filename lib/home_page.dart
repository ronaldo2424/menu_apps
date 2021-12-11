import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:menu_apps/add_menu.dart';
import 'package:menu_apps/const.dart';
import 'package:menu_apps/detail_menu_page.dart';
import 'package:menu_apps/edit_page.dart';
import 'package:menu_apps/main.dart';
import 'package:menu_apps/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getMenu() async {
    final String url = "$baseURL/api/list";

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var response = await http.get(Uri.parse(url), headers: headers);
    if (mounted) if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
  }

  Future _deleteMenu(String id) async {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Aplikasi Menu Makanan"),
          actions: [
            IconButton(
              onPressed: () {
                // print(widget.jwt);
                // print(widget.payload);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfilePage(
                        payload: widget.payload,
                      );
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.person,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                margin: EdgeInsets.fromLTRB(7, 10, 7, 10),
                child: FutureBuilder(
                    // child: StreamBuilder(
                    future: getMenu(),
                    // stream: Stream.fromFuture(getMenu()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount:
                                (snapshot.data as dynamic)['data'].length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return DetailMenuPage(
                                          menu: (snapshot.data
                                              as dynamic)['data'][index]);
                                    },
                                  ));
                                },
                                child: Card(
                                  elevation: 3,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          child: Image.network(
                                            "$baseURL" +
                                                ((snapshot.data
                                                        as dynamic)['data']
                                                    [index]['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (snapshot.data
                                                          as dynamic)['data']
                                                      [index]['name'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "Rp. " +
                                                      (snapshot.data
                                                                  as dynamic)[
                                                              'data'][index]
                                                          ['price'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Center(
                                            child: IconButton(
                                                onPressed: () {
                                                  showBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          // color: Colors.grey,
                                                          border: Border.all(
                                                            width: 2,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return EditPage(
                                                                      menu: (snapshot.data
                                                                              as dynamic)['data']
                                                                          [
                                                                          index],
                                                                    );
                                                                  },
                                                                ));
                                                              },
                                                              child: Text(
                                                                "Edit",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                _deleteMenu(
                                                                  (snapshot.data
                                                                              as dynamic)['data']
                                                                          [
                                                                          index]['id']
                                                                      .toString(),
                                                                );
                                                              },
                                                              child: Text(
                                                                "Hapus",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(Icons.more_vert)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AddMenu();
                    },
                  ));
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      );
}

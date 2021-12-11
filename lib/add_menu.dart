import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:menu_apps/const.dart';
import 'package:menu_apps/main.dart';
import 'package:path/path.dart' as Path;

class AddMenu extends StatefulWidget {
  const AddMenu({Key? key}) : super(key: key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  File imageFile = File("");
  final picker = ImagePicker();
  final String url = "$baseURL/api/upload";

  Future getImageFromGallery() async {
    /* var pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    ); */
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  /* Future getImageFromCamera() async {
    var pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  } */

  upload() async {
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest('POST', uri);

    request.fields["name"] = _nameController.text;
    request.fields["description"] = _descriptionController.text;
    request.fields["price"] = _priceController.text;

    var length_1 = await imageFile.length();
    var multipartFile_1 = new http.MultipartFile(
        'image', http.ByteStream(imageFile.openRead()).cast(), length_1,
        filename: Path.basename(imageFile.path));
    request.files.add(multipartFile_1);

    var response = await request.send();
    if (response.statusCode > 2) {
      print("XXXXXXXXXXXX");
      print("Berhasil");
      print("XXXXXXXXXXXXxx");
      if (mounted) {
        /* _nameController.text = "";
        _descriptionController.text = "";
        _priceController.text = "";
        imageFile.delete(); */
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return MyApp();
            },
          ), (route) => false);
        });
      }
    } else {
      print("XXXXXXXXXXXX");
      print("Gagal");
      print("XXXXXXXXXXXXxx");
    }
    var res = await http.Response.fromStream(response);
    // ignore: unused_local_variable
    var data = jsonDecode(res.body);
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah menu"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  // controller: _emailController,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "nama",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 200,
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  // controller: _emailController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: "deskripsi",
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
                  controller: _priceController,
                  // controller: _emailController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "harga",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  getImageFromGallery();
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 3,
                      ),
                    ),
                    // child: Icon(Icons.add),
                    child: (imageFile.path == "")
                        ? Icon(Icons.add)
                        : Image.file(imageFile)),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  upload();
                },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

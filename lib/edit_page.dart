import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:menu_apps/const.dart';
import 'package:menu_apps/main.dart';
import 'package:path/path.dart' as Path;

class EditPage extends StatefulWidget {
  final Map menu;
  const EditPage({
    required this.menu,
    Key? key,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String urlImage = "";

  File imageFile = File("");
  final picker = ImagePicker();
  // final String url = "$baseURL/api/upload";

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

  /* Future _editProduct() async {
    final _response = await http.put(
        Uri.parse(
          "$baseURL/api/productsResearcher/" + widget.id.toString(),
        ),
        body: {
          /* "image_1": _image_1Controller.text,
          "image_2": _image_2Controller.text,
          "image_3": _image_3Controller.text, */
          "product_name": _productnameController.text,
          "description": _descriptionController.text,
          "stock": _stockController.text,
          "price": _priceController.text,
          "weight": _weightController.text,
          "category_id": category_id.toString(),
        });
    return jsonDecode(_response.body);
  } */

  update(String id) async {
    var uri = Uri.parse("$baseURL/api/update/$id");
    var request = new http.MultipartRequest('POST', uri);

    request.fields["name"] = _nameController.text;
    request.fields["description"] = _descriptionController.text;
    request.fields["price"] = _priceController.text;

    if (imageFile.path.length > 0) {
      var length_1 = await imageFile.length();
      var multipartFile_1 = new http.MultipartFile(
          'image', http.ByteStream(imageFile.openRead()).cast(), length_1,
          filename: Path.basename(imageFile.path));
      request.files.add(multipartFile_1);
    }

    var response = await request.send();
    if (response.statusCode > 2) {
      print("Berhasil");
      var res = await http.Response.fromStream(response);
      // ignore: unused_local_variable
      // var data = jsonDecode(res.body);
      if (res.body.isNotEmpty) {
        print(res.body);
        json.decode(res.body);
      }
      print(response.statusCode);
      if (mounted) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return MyApp();
            },
          ), (route) => false);
        });
      }
    } else {
      print("Gagal");
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.menu['name'];
    _descriptionController.text = widget.menu['description'];
    _priceController.text = widget.menu['price'];
    urlImage = widget.menu['image'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit menu"),
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
                        ? Image.network(baseURL + widget.menu['image'])
                        : Image.file(imageFile)),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  update(widget.menu['id']);
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

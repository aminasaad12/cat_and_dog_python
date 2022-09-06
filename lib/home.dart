
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late File _image;
  late List _results;
  bool imageSelect=false;
  @override
  void initState()
  {
    super.initState();
    loadModel();
  }
  Future loadModel()
  async {
    Tflite.close();
    String res;
    res=(await Tflite.loadModel(model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image)
  async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results=recognitions!;
      _image=image;
      imageSelect=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:ListView(
        children: [
          (imageSelect)?Container(
            margin: const EdgeInsets.all(20),
            child: Image.file(_image),
          ):Container(
            margin: const EdgeInsets.only(
                top: 100.0,
                left: 20.0,
                right: 20.0
            ),
            child:  Opacity(
              opacity: 0.8,
              child: Center(
                child: Column(
                  children: [
                    Text("Detect Dogs and Cats", style: TextStyle(
                      color: Colors.yellow,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold

                    ),),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0,
                          left: 30.0,
                          right: 10.0
                      ),
                      child: Image(image: AssetImage('assets/images/cat.png')),
                    )  ,
                  ],
                ),

              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)?_results.map((result) {
                return Card(
                  color: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "${result['label']}",
                          style: const TextStyle(color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //fontFamily: Basic_Font
                          ),
                        ),
                      ),
                    ],
                  ),

                );
              }).toList():[],

            ),
          )
        ],
      ),
      floatingActionButton: Row(
            children: [
              SizedBox(
                width:28,
              ),
              FloatingActionButton(
                heroTag: "gallery",
                backgroundColor: Colors.yellow,
                onPressed: galleryImage,
                tooltip: "gallery Image",
                child: const Icon(Icons.image),
              ),
              Spacer(),
              FloatingActionButton(
                heroTag: "camera",
                backgroundColor: Colors.yellow,
                onPressed: camerayImage,
                tooltip: "camera Image",
                child: const Icon(Icons.camera),
              )
            ]
        )


    );
  }
  Future galleryImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }

  Future camerayImage()
  async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    File image=File(pickedFile!.path);
    imageClassification(image);
  }
 }

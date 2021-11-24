import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:chuonchuon/parts/navigation_drawer.dart';
import 'package:chuonchuon/screens/predict_result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final List<CameraDescription> camera;

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final Color _background = const Color.fromRGBO(16, 16, 59, 1);
  final picker = ImagePicker();
  String result = "";
  int _camera = 0;


  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera[_camera],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();

    runThings();
  }

  runThings() async {
    await loadModel();
  }

  loadModel() async {
    await Tflite.loadModel(
      model:"assets/tfmodel/cloud_model.tflite",
      labels:"assets/tfmodel/cloud_label.txt",
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  detectObject(File image) async {
    if (image == null) return;
    var recognitions = await Tflite.runModelOnImage(
        path: image.path,   // required
        threshold: 0.05,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        asynch: true
    );
    String r = "";
    for (var re in recognitions!) {
      r = "${re['label']} - ${re['confidence'].round()}" ;
    }
    log("list predict: $recognitions");

    setState(() {
      result = r;
    });
  }

  predictAndProcess({required File image}) async {
    await detectObject(image);

    log("Result predict: $result");
    // log("Result predict: ${File(image.path)}");

    await Get.to(() => PredictResult(
      imagePath: image.path,
      cloudName: result,
    ));
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null) {
        predictAndProcess(image: File(pickedFile.path));
      } else {
        print("No image Selected");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: const NavigationDrawerWidget(active: 4),
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          title: const Text('Nhận diện qua máy ảnh'),
        ),
        body: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      heroTag: "pick image",
                      onPressed: () async {
                        await getImageFromGallery();
                      },
                      child: const Icon(Icons.add_photo_alternate_outlined),
                    ),FloatingActionButton(
                      heroTag: "take picture",
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;

                          final image = await _controller.takePicture();
                          predictAndProcess(image: File(image.path));

                        } catch (e) {
                          log("Take Image: $e");
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                    FloatingActionButton(
                      heroTag: "turn camera",
                      onPressed: () async {
                        setState((){
                          _camera = _camera == 0 ? 1 : 0;
                        });
                        _controller.dispose();
                        _controller = CameraController(
                          widget.camera[_camera],
                          ResolutionPreset.medium
                        );
                        await _initializeControllerFuture;
                      },
                      child: const Icon(Icons.threesixty),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:chuonchuon/parts/navigation_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:developer';

import '../main.dart';

class PredictCamera extends StatefulWidget{
  const PredictCamera({Key? key}) : super(key: key);

  @override
  _PredictCameraState createState() => _PredictCameraState();

}

class _PredictCameraState extends State<PredictCamera> {
  bool isWorking = false;
  String result="";
  late CameraController cameraController;
  CameraImage? imgCamera;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    runThings();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  runThings() async {
    await loadModel();
    await initCamera();
  }

  loadModel() async {
    await Tflite.loadModel(
      model:"assets/tfmodel/cloud_model.tflite",
      labels:"assets/tfmodel/cloud_label.txt",
    );
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value)
    {
      if(!mounted)
      {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) =>
        {
          if(!isWorking)
            {
              isWorking = true,
              imgCamera = imageFromStream,
              runModelOnStreamFrames(),

            }
        });
      });
    });
  }

  runModelOnStreamFrames() async {
    if(imgCamera != null)
    {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList:  imgCamera!.planes.map((plane)
        {
          return plane.bytes;
        }).toList(),

        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch:true,
      );
      result="";
      for (var response in recognitions!) {
        result += response["label"] + " " + (response["confidence"] as double).toStringAsFixed(2) + "\n\n";
      }

      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        drawer: const NavigationDrawerWidget(active: 4),
        appBar: AppBar(
          title: const Text('nhan dien'),
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white38,
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: imgCamera == null
                      ? const SizedBox(
                    height: 200,
                    width:360,
                    child:Icon(Icons.photo_camera_front, color: Colors.lightBlueAccent,size: 40,),
                  ) : AspectRatio(
                    aspectRatio:cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        result,
                        style:const TextStyle(
                          backgroundColor: Colors.black87,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed:(){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Icon(Icons.add_photo_alternate_outlined),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:() async {

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Icon(Icons.ac_unit_rounded),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:(){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: const Icon(Icons.threesixty),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ), //img to background
      ),
    );
  }
}
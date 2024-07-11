import 'dart:html';
import 'dart:html' as html;
//import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:bispick/pages/camera_web_methods.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({ Key? key }) : super(key: key);

//   @override
//   _CameraPageState createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {

//   CameraController? controller;
//   bool isCameraInitialized = false;
//   late final List<CameraDescription> cameras;
//   bool isrecording = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initializeCamera();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//    final CameraController? cameraController = controller;

//          if (cameraController == null || !cameraController.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       // Free up memory when camera not active
//       cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       // Reinitialize the camera with same properties
//       onNewCameraSelected(cameraController.description);
//     }
//   }

//   Future<void> initializeCamera() async {
//     cameras = await availableCameras();
//     await onNewCameraSelected(cameras.first);
//     setState(() {
//       isCameraInitialized = true;
//     });
//   }

//   Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
//     final previousCameraController = controller;

//     final CameraController cameraController = CameraController(
//       cameraDescription,
//       ResolutionPreset.veryHigh,
//       imageFormatGroup: ImageFormatGroup.jpeg
//     );

//     try {
//       await cameraController.initialize();
//     } on CameraException catch (e) {
//       print('Error in camera');
//     }

//     await previousCameraController?.dispose();

//     if(mounted){
//       setState(() {
//         controller = cameraController;
//       });
//     }

//     cameraController.addListener(() {

//     });
//   }

//   Future<XFile?> capturePhoto() async {
//     final CameraController? cameraController = controller;
//     if(cameraController!.value.isTakingPicture){
//       return null;
//     }
//     try{
//       await cameraController.setFlashMode(FlashMode.off); //optional
//       XFile file = await cameraController.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       print('Error captuing photo');
//     }

//   }

//   void onTakePhotoPressed() async {
//     final navigator = Navigator.of(context);
//     final xFile = await capturePhoto();
//     if (xFile != null) {
//       if (xFile.path.isNotEmpty) {
//         navigator.push(
//           MaterialPageRoute(
//             builder: (context) => PostPage(
//               imgPath: xFile.path,
//             ),
//           ),
//         );
//       }
//     }

//   }

//   @override
//   Widget build(BuildContext context) {
//     if(isCameraInitialized){
//       return SafeArea(
//         child: Scaffold(
//           body: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Stack(
//               children: [
//                 CameraPreview(controller!),
//                 Container(
//                   child: (!isrecording)?
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           fixedSize: Size(70,70),
//                           shape: CircleBorder(),
//                           backgroundColor: Colors.white
//                         ),
//                         onPressed: (){
//                           onTakePhotoPressed();
//                         },
//                         child: Icon(
//                           Icons.add
//                         ),
//                       ),
//                     )
//                     :Container()
//                   ,
//                 )
//               ],
//             ),
//           ),
//         )
//         );
//     } else {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//   }
// }

class PostPage extends StatefulWidget {
  final Uint8List? imgPath;

  const PostPage({Key? key, this.imgPath}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isuploading = false;
  String? username;
  String? useremail;
  String? box_number;
  String? category;
  String? description;
  String? photoURL;
//  ui.Image? image;

  CRUD crud = new CRUD();
  final formKey = GlobalKey<FormState>();
  // Retrieve data from SharedPreferences
  // getusername() async {
  //   return await Helperfunctions.getUserNameSharedPreference().then((value){
  //     setState(() {
  //       username = value;
  //     });
  //   });
  // }

  void upload() async {
    Reference rootreference = FirebaseStorage.instance
        .ref()
        .child('LostThings')
        .child("${randomAlphaNumeric(10)}.jpg");
    UploadTask uploadTask = rootreference.putData(widget.imgPath!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    await snapshot.ref.getDownloadURL().then((url) {
      photoURL = url;
    });

    crud
        .uploadData(username, box_number, category, description,
            DateTime.now().toString(), photoURL)
        .then((value) {
      isuploading = false;
      Navigator.popAndPushNamed(context, 'lostthingsView');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //getusername();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isuploading)
        ? Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  Text('Uploading in process...\n This may take a while...')
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'I FOUND THIS',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: Form(
              key: formKey,
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Username',
                            hintText: 'What is your name?'),
                        onChanged: (value) {
                          username = value;
                        },
                        validator: (value) {
                          // Validate if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          // Return null if the input is valid
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a box';
                          }
                          return null;
                        },
                        value: box_number,
                        hint: Text('Select a box'),
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            box_number = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: "Box 1",
                            child: Text('Box 1'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Box 2",
                            child: Text('Box 2'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Box 3",
                            child: Text('Box 3'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Box 4",
                            child: Text('Box 4'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        //underline: SizedBox.shrink(),
                        decoration: InputDecoration(border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Choose the Category';
                          }
                          return null;
                        },
                        value: category,
                        hint: Text('Category'),
                        isExpanded: true,
                        onChanged: (value) {
                          setState(() {
                            category = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: "E-Device",
                            child: Text('E-Device'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Clothing",
                            child: Text('Clothing'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Stationery",
                            child: Text('Stationery'),
                          ),
                          DropdownMenuItem<String>(
                            value: "Others",
                            child: Text('Others'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Description',
                            hintText: 'What did you find?'),
                        onChanged: (value) {
                          description = value;
                        },
                        validator: (value) {
                          // Validate if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please describe what you found.';
                          }
                          // Return null if the input is valid
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        //padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Image.memory(
                          widget.imgPath!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isuploading = true;
                            });
                            upload();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'Upload',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool? isandroid;
  bool? isios;
  //for android
  bool androidaccess = false;

  //for ios
  bool cameraAccess = false;
  String? error;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    if (html.window.navigator.platform!.contains("iPhone") ||
        html.window.navigator.platform!.contains("MacIntel")) {
      getCameras_ios();
      setState(() {
        isios = true;
      });
    } else {
      getCamera_android().then((value) {
        androidaccess = value!;
      });
      setState(() {
        isios = false;
      });
    }
    super.initState();
  }

  Future<void> getCameras_ios() async {
    try {
      await html.window.navigator.mediaDevices!.getUserMedia(
          {'video': true, 'audio': false}); //get the permission to user media
      setState(() {
        cameraAccess = true;
      });
      await availableCameras().then((value) {
        setState(() {
          cameras = value;
        });
      });
      // setState(() {
      //   this.cameras = cameras;
      // });
    } on html.DomException catch (e) {
      setState(() {
        error = '${e.name}: ${e.message}';
      });
    }
  }

  Future<bool?> getCamera_android() async {
    if (initialized) {
      print('Already init');
      return true;
    }

    try {
      final mediaStream = await window.navigator.mediaDevices!.getUserMedia({
        'video': {'facingMode': 'environment'},
        'audio': false
      }); //get the permission to use media
      video.srcObject = mediaStream;
      await video.play();
      initialized = true;
      return true;
    } on DomException catch (e) {
      print('Error: ${e.message}');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (isios!) {
      if (error != null) {
        return Scaffold(
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text('Error: $error'))),
        );
      }
      if (!cameraAccess) {
        return Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
                child: Text(
              'Camera access not granted yet.',
              style: TextStyle(color: Colors.black),
            )),
          ),
        );
      }
      if (cameras == null) {
        return Scaffold(
          body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                  child: Text(
                'Reading cameras',
                style: TextStyle(color: Colors.black),
              ))),
        );
      }
      return IosCameraView(cameras: cameras!);
    } else {
      return AndroidCameraView(
        success: androidaccess,
      );
    }
  }
}

//ANDROID CAMERA VIEW
class AndroidCameraView extends StatefulWidget {
  final bool success;
  const AndroidCameraView({Key? key, required this.success}) : super(key: key);

  @override
  _AndroidCameraViewState createState() => _AndroidCameraViewState();
}

class _AndroidCameraViewState extends State<AndroidCameraView> {
  Uint8List? photoBytes;

  Uint8List takePic() {
    //assert(initialized);

    final context = canvas.context2D;

    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    context.drawImage(video, 0, 0);

    final data = canvas.toDataUrl('image/png');
    final uri = Uri.parse(data);
    return uri.data!.contentAsBytes();
  }

  @override
  void initState() {
    // TODO: implement initState
    ui.platformViewRegistry
        .registerViewFactory('video-view', (int viewId) => video);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const HtmlElementView(viewType: 'video-view')),
            Align(
              //alignment: Alignment.bottomCenter,

              child: GestureDetector(
                onTap: () async {
                  final bytes = takePic();
                  setState(() {
                    photoBytes = bytes;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PostPage(
                              imgPath: photoBytes,
                            )));
                  });
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
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

//IOS CAMERA VIEW
class IosCameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  const IosCameraView({Key? key, required this.cameras}) : super(key: key);

  @override
  _IosCameraViewState createState() => _IosCameraViewState();
}

class _IosCameraViewState extends State<IosCameraView> {
  String? error;
  CameraController? controller;
  late CameraDescription cameraDescription =
      (widget.cameras.length > 1) ? widget.cameras[1] : widget.cameras[0];

  Future<void> initCam(CameraDescription description) async {
    setState(() {
      controller = CameraController(description, ResolutionPreset.max);
    });

    try {
      await controller!.initialize();
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initCam(cameraDescription);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Text('Initializing error: $error\nCamera list:'),
        ),
      );
    }
    if (controller == null) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(child: Text('Loading controller...')));
    }
    if (!controller!.value.isInitialized) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Center(child: Text('Initializing camera...')));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(controller!)),
            /*Material(
              child: ToggleButtons(
                isSelected: List<bool>.generate(widget.cameras.length, (index) => cameraDescription == widget.cameras[index]),
                onPressed: (int newIndex) async {
                  if (controller != null) {
                    await controller!.dispose();
                  }
                  setState(() {
                    controller = null;
                    cameraDescription = widget.cameras[newIndex];
                  });

                  initCam(widget.cameras[newIndex]);
                },
                children: widget.cameras.map<Widget>((camera) {
                  if(camera.lensDirection == CameraLensDirection.back){
                    return Icon(Icons.camera_front);
                  }
                  else if (camera.lensDirection == CameraLensDirection.front){
                    return Icon(Icons.camera_rear);
                  }
                  else { return Container(height: 0, width: 0,color: Colors.transparent,);}
                }).toList(),
              ),
            ),
            */
            /*ElevatedButton(
              onPressed: controller == null
                  ? null
                  : () async {
                await controller!.startVideoRecording();
                await Future.delayed(Duration(seconds: 5));
                final file = await controller!.stopVideoRecording();
                final bytes = await file.readAsBytes();
                final uri = Uri.dataFromBytes(bytes,
                    mimeType: 'video/webm;codecs=vp8');
      
                final link = AnchorElement(href: uri.toString());
                link.download = 'recording.webm';
                link.click();
                link.remove();
              },
              child: Text('Record 5 second video.'),
            ),*/
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: Container(
            //       width: 70,
            //       height: 70,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.rectangle,
            //         color: Colors.transparent,
            //       ),
            //       child: TextButton(
            //         child: Text('Find my lost item'),
            //         onPressed: (){
            //           Navigator.of(context).popAndPushNamed('lostthingsView');
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            Align(
              //alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: controller == null
                    ? null
                    : () async {
                        final file = await controller!.takePicture();
                        await file.readAsBytes().then((value) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostPage(
                                imgPath: value,
                              ),
                            ),
                          );
                        });

                        // final link = AnchorElement(
                        //     href: Uri.dataFromBytes(bytes, mimeType: 'image/png')
                        //         .toString());

                        //link.download = 'picture.png';
                        //link.click();
                        //link.remove();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => PostPage(
                        //       imgPath: bytes,
                        //     ),
                        //   ),
                        // );ß
                      },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          // child: GestureDetector(
                          //   onTap: controller == null
                          //       ? null
                          //       : () async {
                          //     final file = await controller!.takePicture();
                          //     await file.readAsBytes().then((value){
                          //       Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (context) => PostPage(
                          //           imgPath: value,
                          //         ),
                          //       ),
                          //     );
                          //     });

                          //     // final link = AnchorElement(
                          //     //     href: Uri.dataFromBytes(bytes, mimeType: 'image/png')
                          //     //         .toString());

                          //     //link.download = 'picture.png';
                          //     //link.click();
                          //     //link.remove();
                          //     // Navigator.of(context).push(
                          //     //   MaterialPageRoute(
                          //     //     builder: (context) => PostPage(
                          //     //       imgPath: bytes,
                          //     //     ),
                          //     //   ),
                          //     // );ß
                          //   },
                          // ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

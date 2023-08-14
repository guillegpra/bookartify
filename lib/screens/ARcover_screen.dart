import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'dart:async';

class TutorialPageData {
  final String text;

  TutorialPageData({required this.text});
}

class ARCover extends StatefulWidget {
  const ARCover({Key? key}) : super(key: key);

  @override
  State<ARCover> createState() => _ARCoverState();
}

class _ARCoverState extends State<ARCover> {
  bool _arViewActive = false;
  @override
  void initState() {
    super.initState();
  }
  double sliderValue = 0.2;
  bool _showTutorialDialog = true;
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  List<TutorialPageData> tutorialPages = [
    TutorialPageData(text: "Please note: \nThe AR camera may struggle to recognize plain surfaces like white or plain-colored walls and floors. It works best on textured or designed surfaces."),
    TutorialPageData(text: "Tip: \nTap on the desired location to place an object."),
    TutorialPageData(text: "Want to move the object? \nLong-press and drag to your preferred spot."),
    TutorialPageData(text: "To rotate the object, long-press it and use another finger to swipe in the desired direction."),
  ];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
    clearAllImagesFromPath("/data/user/0/com.example.bookartify/app_flutter/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(70, 192, 162, 73),
        elevation: 0,
      ),
      body: Container(
        child: Stack(
          children: [
          if (_arViewActive)
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Card(
                    color: const Color.fromRGBO(245, 239, 225, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: const Text("Book size:"),
                        ),
                        Slider(
                          value: sliderValue,
                          min: 0.1,
                          max: 0.3,
                          onChanged: (double value) {
                            setState(() {
                              sliderValue = value;
                            });
                            resizeObject(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: onTakeScreenshot,
                            style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            ),
                            child: Image.asset(
                              'images/camera.png',
                              fit: BoxFit.cover,
                              width: 60.0, 
                              height: 60.0, 
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showTutorialDialog) _buildTutorialDialog(),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialDialog() {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.29,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _showTutorialDialog = false;
                      _arViewActive = true;
                    });
                  },
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: tutorialPages.length,
                  itemBuilder: (context, index) {
                    return _tutorialPage(
                      tutorialPages[index].text,
                      index + 1,
                      tutorialPages.length,
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTutorialDialog = false;
                    _arViewActive = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(191, 160, 84, 1), 
                ),
                child: Text("I understand"),
              ),
            ],
          ),
        ),
      );
    }

  Widget _tutorialPage(String text, int currentPage, int totalPages) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Scrollbar( 
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ),
        Text("$currentPage/$totalPages"),
      ],
    );
  }
  
  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "images/Indicator.png",
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  Future<void> resizeObject(double scale) async {
      if (nodes.isNotEmpty) {
        ARNode node = nodes.first; // Select the node you want to resize
        node.scale = Vector3(scale, scale, scale); // Set the new size
      }
  }


  Future<void> onRemoveEverything() async {
      nodes.forEach((node) {
        this.arObjectManager!.removeNode(node);
      });
      anchors.forEach((anchor) {
        this.arAnchorManager!.removeAnchor(anchor);
      });
      nodes = [];  // Clear the nodes list
      anchors = [];
  }

    Future<void> clearAllImagesFromPath(String path) async {
    final dir = Directory(path);
    if (dir.existsSync()) {
      dir.listSync().forEach((file) {
        if (file is File && (file.path.endsWith(".png") || file.path.endsWith(".jpg"))) {
          file.deleteSync();
        }
      });
    }
  }

Future<void> onTakeScreenshot() async {
  var image = await arSessionManager!.snapshot();
  final completer = Completer<Uint8List>();
  image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo info, bool _) async {
        final ByteData? data = await info.image.toByteData(format: ui.ImageByteFormat.png);
        completer.complete(data!.buffer.asUint8List());
      },
    ),
  );
  final Uint8List uint8list = await completer.future;
  final String tempPath = (await getTemporaryDirectory()).path;
  final File tempFile = File('$tempPath/screenshot.png');
  await tempFile.writeAsBytes(uint8list);
  GallerySaver.saveImage(tempFile.path, albumName: "myAlbum").then((bool? success) {
    print("Image saved to gallery: $success");
  });
}


  Future<void> onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
      await onRemoveEverything();
     
      var singleHitTestResult = hitTestResults.firstWhere(
          (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
      if (singleHitTestResult != null) {
        var newAnchor =
            ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
        bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
        if (didAddAnchor!) {
          this.anchors.add(newAnchor);

const fileName = 'book.gltf';

var newNode = ARNode(
    type: NodeType.fileSystemAppFolderGLTF2, 
    uri: fileName, 
    scale: Vector3(0.2, 0.2, 0.2), 
    position: Vector3(0.0, 0.0, 0.0),
    rotation: Vector4(1.0, 0.0, 0.0, 0.0));

          bool? didAddNodeToAnchor =
              await this.arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
          if (didAddNodeToAnchor!) {
            this.nodes.add(newNode);
          } else {
            this.arSessionManager!.onError("Adding Node to Anchor failed");
          }
        } else {
          this.arSessionManager!.onError("Adding Anchor failed");
        }
      }
  }



  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //pannedNode.transform = newTransform;
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);

    /*
    * Uncomment the following command if you want to keep the transformations of the Flutter representations of the nodes up to date
    * (e.g. if you intend to share the nodes through the cloud)
    */
    //rotatedNode.transform = newTransform;
  }
}





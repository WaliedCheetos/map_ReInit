// Disabled null safety for this file:
// @dart=2.9

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:images_picker/images_picker.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagesPicker _picker = ImagesPicker();
  String? path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBaseContainer(),
      floatingActionButton: FloatingActionButton(
        onPressed: onImageButtonPressed,
        tooltip: 'Photo library',
        child: Icon(Icons.photo_library_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _getBaseContainer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SafeArea(child: HereMap(onMapCreated: _onMapCreated)),
        path != null
            ? Container(
                height: 200,
                child: Image.file(
                  File(path!),
                  fit: BoxFit.contain,
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    try {
      hereMapController.mapScene.loadSceneForMapScheme(MapScheme.hybridDay,
          (MapError? mapError) {
        if (mapError != null) {
          print(
              'WaliedCheetos: Map scene has NOT been loaded. HERE mSDK Error: ${mapError.toString()}');
          return;
        }

        hereMapController.camera.flyToWithOptionsAndDistance(
            GeoCoordinates(25.09935, 55.16341),
            7000,
            MapCameraFlyToOptions.withDefaults());
      });
    } catch (e) {
      print("WaliedCheetos - DT_ERROR_MAP : " + e.toString());
    }
  }

  void onImageButtonPressed() async {
    List<Media>? res = await ImagesPicker.pick(
        count: 3,
        pickType: PickType.all,
        language: Language.System,
        cropOpt: null);
    if (res != null) {
      print(res.map((e) => e.path).toList());
      setState(() {
        path = res[0].thumbPath;
      });
    }
  }
}

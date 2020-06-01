import 'dart:io';

import 'package:demo_app/main.dart';
import 'package:demo_app/pages/image_viewer.dart';
import 'package:demo_app/pages/windy_webview.dart';
import 'package:demo_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path/path.dart' as path;

class Gallery extends StatefulWidget {
  static const String route = "/gallery";

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery Test"),
      ),
      drawer: buildDrawer(context, Gallery.route),
      body: Container(
          child: FutureBuilder(
              future: _getImageFiles(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  if (snapshot.data.length == 0) {
                    return Center(child: Text('No Pictures'));
                  }
                  return createGalleryWidget(context, snapshot.data);
                }
                return Center(child: Text('Gallery is loading...'));
              })),
    );
    ;
  }

  Future<List<FileSystemEntity>> _getImageFiles() async {
    var filesList = Directory(await Future.delayed(
            Duration(milliseconds: 200), () => MyApp.windyGalleryPath()))
        .listSync(recursive: true);
    filesList.removeWhere((element) {
      if (FileSystemEntity.isDirectorySync(element.path)) {
        return true;
      } else {
        var mimeType = lookupMimeType(element.path)..split('/');
        if (mimeType.startsWith('image')) {
          return false;
        }
        return true;
      }
    });
    return filesList;
  }

  Widget createGalleryWidget(BuildContext context, filesList) {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: (filesList ?? []).length,
        itemBuilder: (BuildContext context, int index) {
          var imagePath = filesList[index].path;
          var fileName = path.basenameWithoutExtension(imagePath);
          return InkWell(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                FadeInImage(
                  image: FileImage(
                    File(imagePath),
                  ),
                  placeholder: MemoryImage(kTransparentImage),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.7),
                  height: 30,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Regular'),
                    ),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ImageView(FileImage(File(imagePath)))),
              );
            },
          );
        },
      ),
    );
  }
}

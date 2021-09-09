import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

void main() => runApp(MyApp());

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  File? _image;

  String _phone = '917974704221';

  Future<void> share() async {
    await WhatsappShare.share(
      text: 'Example share text',
      linkUrl: 'https://flutter.dev/',
      phone: _phone,
    );
  }

  Future<void> shareFile() async {
    await getImage();
    Directory? directory = await getExternalStorageDirectory();

    print('${directory!.path} / ${_image!.path}');
    await WhatsappShare.shareFile(
      phone: _phone,
      filePath: ["${_image!.path}"],
    );
  }

  Future<void> isInstalled() async {
    final val = await WhatsappShare.isInstalled();
    print('Whatsapp is installed: $val');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Whatsapp Share'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text('Share text and link'),
                onPressed: share,
              ),
              ElevatedButton(
                child: Text('Share Image'),
                onPressed: shareFile,
              ),
              ElevatedButton(
                child: Text('is Installed'),
                onPressed: isInstalled,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Pick Image From gallery using image_picker plugin
  Future getImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? _pickedFile =
          (await _picker.pickImage(source: ImageSource.gallery));

      if (_pickedFile != null) {
        // getting a directory path for saving
        final directory = await getExternalStorageDirectory();

        // copy the file to a new path
        await _pickedFile.saveTo('${directory!.path}/image1.png');
        _image = File('${directory.path}/image1.png');
      }
    } catch (er) {
      print(er);
    }
  }
}

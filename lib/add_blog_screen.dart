import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:blog_app/add_blog_controller.dart';
import 'package:blog_app/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'blog.dart';

class AddBlogScreen extends StatefulWidget {
  final Blog blog;

  AddBlogScreen({this.blog});

  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final AddBlogController addBlogController = Get.put(AddBlogController());

  @override
  void initState() {
    super.initState();
    if (widget.blog != null) {
      addBlogController.initializeBlogForEdit(widget.blog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Blog'),
      ),
      body: SafeArea(
        child: GetBuilder<AddBlogController>(
          builder: (myController) => SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: myController.image != null
                        ? Image.memory(getImageFromString(myController.image),
                            height: Get.width * 0.4,
                            width: Get.width * 0.4,
                            fit: BoxFit.cover)
                        : Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.grey[800],
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: myController.titleController,
                        decoration: InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: myController.contentController,
                        maxLines: 10,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                            hintText: 'content',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (myController.validate()) {
                            myController.saveToDatabase().then((value) {
                              if (value) {
                                Navigator.pop(context, true);
                              } else {
                                CustomSnackbar.showCusotmSnackBar(
                                    message: 'Something went wrong.');
                              }
                            });
                          } else {
                            CustomSnackbar.showCusotmSnackBar(
                                message: '${myController.errorMessage}');
                          }
                        },
                        child: Text('Save'),
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _imagePickerCallBack(ImageSource imageSource) async {
    try {
      PickedFile image =
          await ImagePicker().getImage(source: imageSource, imageQuality: 85);
      if (image != null) {
        cropPickedImage(image.path);
      }
    } catch (e) {
      print(e);
    }
  }

  getImageFromString(String imageUrl) {
    Uint8List bytes = base64Decode(imageUrl);
    return bytes;
  }

  cropPickedImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Get.theme.accentColor,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
        ),
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    if (croppedImage != null) {
      addBlogController.updateImageFile(croppedImage);
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.blue,
                      ),
                      title: new Text(
                        'Photo Library',
                      ),
                      onTap: () async {
                        final status = await Permission.storage.request();
                        if (status.isGranted) {
                          _imagePickerCallBack(ImageSource.gallery);
                          Navigator.of(context).pop();
                        } else if (status.isPermanentlyDenied) {
                          openAppSettings();
                        } else {
                          print('Permission denied.');
                        }
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.blue,
                    ),
                    title: new Text(
                      'Camera',
                    ),
                    onTap: () async {
                      final status = await Permission.storage.request();
                      if (status.isGranted) {
                        _imagePickerCallBack(ImageSource.camera);
                        Navigator.of(context).pop();
                      } else if (status.isPermanentlyDenied) {
                        openAppSettings();
                      } else {
                        print('Permission denied.');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

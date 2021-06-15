import 'dart:convert';
import 'dart:io';

import 'package:blog_app/blog.dart';
import 'package:blog_app/custom_snackbar.dart';
import 'package:blog_app/database_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddBlogController extends GetxController {
  
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String _errorMessage = '';
  int _id;
  String _date;
  String _imageData;
  DatabaseHelper databaseHelper = DatabaseHelper();
  
  int count = 0;
  File _imageFile;

  
  TextEditingController get titleController => _titleController;
  TextEditingController get contentController => _contentController;
  String get errorMessage => _errorMessage;
  String get image => _imageData;

  setErrorMessage(String message) {
    _errorMessage = message;
    update();
  }

  updateImageFile(File image) async{
    _imageFile = image;
    _imageData = await getImageString(_imageFile);
    update();
  }

  bool validate() {
    String title = _titleController.text;
    String content = _contentController.text;
    print('title is $title');
    print('Content is $content');

    if (_imageData == null) {
      setErrorMessage('Please select an image.');
      return false;
    } else if (title == null || title.length == 0) {
      setErrorMessage(' please enter a title');
      return false;
    } else if (content == null || content.length == 0) {
      setErrorMessage('Please enter content.');
      return false;
    } else {
      return true;
    }
  }

  initializeBlogForEdit(Blog blog) {
    _id = blog.id;
    titleController.text = blog.title;
    contentController.text = blog.content;
    _imageData = blog.image;
    _date = blog.date;
    update();
  }

  Future<bool> saveToDatabase() async {
    String title = titleController.text;
    String content = contentController.text;
    String imageString = _imageData;
    DateTime now = DateTime.now();
    if(_date == null) {
      _date = DateFormat('yyyy/MM/dd').format(now);
    }

    print('title==== $title');
    print('Content==== $content');
    print('id is==== $_id');

    
    var result;
    if (_id == null) {
      Blog blog = Blog(title, content, imageString, _date);
      result = await databaseHelper.insertBlog(blog);
      if (result != 0) {
      return true;
    } else {
      return false;
    }
      
    } else {
      Blog blog = Blog.withId(_id, title, content, imageString, _date);
      result = await databaseHelper.updateBlog(blog);
      if (result != 0) {
      return true;
    } else {
      return false;
    }
    }
    
  }

  Future<String> getImageString(File file) async {
    List<int> imageBytes = await file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}

import 'package:blog_app/add_blog_screen.dart';
import 'package:blog_app/all_blog_controller.dart';
import 'package:blog_app/all_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AllBlogController allBlogController = Get.put(AllBlogController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            callAddPage();
          },
        ),
        body: AllBlogsScreen(),
      ),
    );
  }

  callAddPage() async {
    final result = await Get.to(AddBlogScreen());
    if (result != null && result != false) {
      allBlogController.getBlogList();
    }
  }
}

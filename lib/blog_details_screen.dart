import 'dart:convert';
import 'dart:typed_data';

import 'package:blog_app/add_blog_screen.dart';
import 'package:blog_app/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'blog.dart';

class BlogDetailsScreen extends StatefulWidget {
  Blog blog;

  BlogDetailsScreen(this.blog);

  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  bool edited = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (edited) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.memory(getImageFromString(widget.blog.image)),
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.blog.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue),
                            ),
                            Text(
                              'Posted on: ${widget.blog.date}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(widget.blog.content),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final result =
                              await Get.to(AddBlogScreen(blog: widget.blog));
                          if (result != null && result != false) {
                            DatabaseHelper databaseHelper = DatabaseHelper();
                            Blog newBlog =
                                await databaseHelper.getBlog(widget.blog.id);
                            setState(() {
                              edited = true;
                              widget.blog = newBlog;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          DatabaseHelper databaseHelper = DatabaseHelper();
                          var result =
                              databaseHelper.deleteBlog(widget.blog.id);
                          if (result != 0) {
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          String title = widget.blog.title.toString();
                          String content = widget.blog.content.toString();
                          final Uri _emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: '',
                              queryParameters: {
                                'subject':
                                    title,
                                    'body': content
                              });
                              launch(_emailLaunchUri.toString());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getImageFromString(String imageUrl) {
    Uint8List bytes = base64Decode(imageUrl);
    return bytes;
  }
}

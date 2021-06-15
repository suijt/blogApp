import 'dart:convert';
import 'dart:typed_data';

import 'package:blog_app/all_blog_controller.dart';
import 'package:blog_app/blog_details_screen.dart';
import 'package:blog_app/blog_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'blog.dart';
import 'database_helper.dart';

class AllBlogsScreen extends StatefulWidget {
  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<AllBlogsScreen> {
  AllBlogController allBlogController = Get.find();
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Blogger'),),
          body: SafeArea(
        child: GetBuilder<AllBlogController>(
          builder: (myController) {
            switch (myController.blogState) {
              case BlogState.LOADING:
                return Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                );

              case BlogState.EMPTY:
                return Center(
                  child: Text('There are no blogs. You can add one.'),
                );

              case BlogState.LOADED:
                return Column(
                  children: [
                    SizedBox(height: 8),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: TextField(
                        style: Get.textTheme.bodyText2,
                        onChanged: (input) => allBlogController.searchData(input),
                        decoration: InputDecoration(
                          hintText: 'Search Blog...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    allBlogController.checkedBlogList.length > 0? GestureDetector(
                      onTap: () {
                        allBlogController.deleteCheckedBlogs();
                      },
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(right: 8, bottom: 16),
                            color: Colors.blue,
                            child: Row(
                              children: [
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.delete, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ): Container(),
                    Expanded(
                      child: myController.blogList.length == 0? Center(
                        child: Text('No blogs found.'),
                      ): ListView.builder(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              callBlogDetailPage(myController.blogList[index]);
                            },
                            child: ListItem(
                              blog: myController.blogList[index],
                              onChanged: (value) {
                                myController.blogList[index].setChecked(
                                    !myController.blogList[index].checked);
                                setState(() {});
                                if (myController.blogList[index].checked) {
                                  myController.checkedBlogList
                                      .add(myController.blogList[index]);
                                } else {
                                  myController.checkedBlogList
                                      .remove(myController.blogList[index]);
                                }
                                print(
                                    'Length of checked bloglist==== ${myController.checkedBlogList.length}');
                              },
                            ),
                          );
                        },
                        itemCount: myController.blogList.length,
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  Future<int> databaseCount() async {
    int count = await databaseHelper.getCount();
    return count;
  }

  callBlogDetailPage(Blog blog) async {
    final result = await Get.to(BlogDetailsScreen(blog));
    if (result != null && result != false) {
      allBlogController.getBlogList();
    }
  }
}

class ListItem extends StatelessWidget {
  final Blog blog;
  final Function onChanged;

  ListItem({this.blog, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.memory(
                    getImageFromString(blog.image),
                    height: Get.width * 0.2,
                    width: Get.width * 0.2,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(blog.title,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            )),
                        SizedBox(height: 4),
                        Text(
                          blog.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          blog.date,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Checkbox(
          value: blog.checked,
          onChanged: onChanged,
        ),
      ],
    );
  }

  getImageFromString(String imageUrl) {
    Uint8List bytes = base64Decode(imageUrl);
    return bytes;
  }
}

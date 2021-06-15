import 'package:blog_app/blog_state.dart';
import 'package:blog_app/custom_snackbar.dart';
import 'package:blog_app/database_helper.dart';
import 'package:get/get.dart';

import 'blog.dart';

class AllBlogController extends GetxController {
  List<Blog> _blogList;
  List<Blog> _filteredBlogList = [];
  DatabaseHelper _databaseHelper;
  BlogState _blogState = BlogState.LOADING;
  bool _checkStatus = false;
  List<Blog> checkedBlogList = [];

  @override
  void onInit() {
    _databaseHelper = DatabaseHelper();
    getBlogList();
    super.onInit();
  }

  List<Blog> get blogList => _filteredBlogList;
  BlogState get blogState => _blogState;
  bool get checkStatus => _checkStatus;

  getBlogList() async {
    updateBlogState(BlogState.LOADING);
    await _databaseHelper.getBlogList().then((value) {
      if (value.length == 0) {
        updateBlogState(BlogState.EMPTY);
      } else {
        updateBlogList(value);
        updateBlogState(BlogState.LOADED);
      }
    });
  }

  updateBlogState(BlogState state) {
    _blogState = state;
    update();
  }

  updateBlogList(List<Blog> blogList) {
    _blogList = blogList;
    _filteredBlogList = blogList;
    update();
  }

  searchData(String input) {
    if (input == null || input == '' || input.length == 0) {
      _filteredBlogList = _blogList;
      update();
      return;
    }
    _filteredBlogList = [];
    for (Blog blog in _blogList) {
      if (blog.title.contains(input)) {
        _filteredBlogList.add(blog);
      }
    }
    update();
  }

  deleteCheckedBlogs() async{
    print('I am here====');
    for(Blog blog in checkedBlogList) {
      var result = await _databaseHelper.deleteBlog(blog.id);
      if(result != 0) {

      } else {
        CustomSnackbar.showCusotmSnackBar(message: 'An error occured');
      }
    }
    checkedBlogList = [];
    getBlogList();

  }
}

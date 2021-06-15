class Blog {

  int _id;
  String _title;
  String _content;
  String _image;
  String _date;
  bool _checked = false;

  Blog(this._title, this._content, this._image, this._date);

  Blog.withId(this._id, this._title, this._content, this._image, this._date);

  int get id => _id;
  String get title => _title;
  String get content => _content;
  String get image => _image;
  String get date => _date; 
  bool get checked => _checked;

  set id(int newId) => this._id = newId;
  set title(String newTitle) => this._title = newTitle;
  set content(String newContent) => this._content = newContent;
  set image(String newImage) => this._image = newImage;
  set date(String newDate) => this._date = newDate;
  void setChecked(bool newChecked) => this._checked = newChecked;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['content'] = _content;
    map['image'] = _image;
    map['date'] = _date;

    return map;

  }

  Blog.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._content = map['content'];
    this._image = map['image'];
    this._date = map['date'];
  }


}
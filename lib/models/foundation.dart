import 'package:flutter/foundation.dart';
import 'package:welfare_app/main.dart';
import 'package:flutter/material.dart';

class BookmarkModel extends ChangeNotifier {
  final List<TextCardInfo> bookmarks = [];

  bool isBookmarked(TextCardInfo info) {
    return bookmarks.any((element) => element.text == info.text);
  }

  void addBookmark(TextCardInfo info) {
    bookmarks.add(info);
    notifyListeners();
  }

  void removeBookmark(TextCardInfo info) {
    bookmarks.removeWhere((element) => element.text == info.text);
    notifyListeners();
  }
}



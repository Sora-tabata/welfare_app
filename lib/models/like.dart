import 'package:flutter/material.dart';

class LikeModel extends ChangeNotifier {
  Map<String, bool> _likeStatus = {};

  bool isLiked(String id) => _likeStatus[id] ?? false;

  void toggleLikeStatus(String id) {
    _likeStatus[id] = !isLiked(id);
    notifyListeners();
  }
}

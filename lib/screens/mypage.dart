import 'package:provider/provider.dart';
import 'package:welfare_app/widgets/horizontal_listview.dart';
import 'package:welfare_app/models/foundation.dart'; // BookmarkModelがここで定義されていると仮定
import 'package:flutter/material.dart';
import 'package:welfare_app/main.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookmarks = Provider.of<BookmarkModel>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('ブックマークしたページ'),
          ListView(
            children: bookmarks.bookmarks.map((info) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => info.createPage(),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Image.asset(info.imagePath), // 画像
                    title: Text(info.text), // タイトル
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

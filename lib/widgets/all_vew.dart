import 'package:flutter/material.dart';

class AllPage extends StatelessWidget {
  final List<Widget> children;
  final String title;

  AllPage({required this.children, required this.title});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int crossAxisCount = (width / 200).floor();  // 200は各アイテムの目標幅です

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        iconTheme: IconThemeData(color: Colors.black), // 戻る矢印の色を黒に設定
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),  // グリッド全体のパディングを追加
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10.0,  // アイテム間の横スペースを設定
          mainAxisSpacing: 10.0,  // アイテム間の縦スペースを設定
        ),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return Material(
            elevation: 5.0,  // 影の深さを設定
            borderRadius: BorderRadius.circular(4.0),  // 角の丸みを設定
            child: Container(
              alignment: Alignment.center,
              child: children[index],
            ),
          );
        },
      ),
    );
  }
}

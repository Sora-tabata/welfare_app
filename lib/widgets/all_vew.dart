// all.dart
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
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.0,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return Container(
              alignment: Alignment.center,
              width: 200,  // 明示的な幅
              height: 200,  // 明示的な高さ
              child: children[index],
          );
        },
      ),
    );
  }
}

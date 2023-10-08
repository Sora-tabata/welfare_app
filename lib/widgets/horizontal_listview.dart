import 'package:flutter/material.dart';
import 'package:welfare_app/widgets/all_vew.dart';

class HorizontalListView extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget Function(List<Widget>, String) allPageBuilder;

  HorizontalListView({
    required this.title,
    required this.children,
    required this.allPageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => allPageBuilder(children, title),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemCount: children.length,
            itemBuilder: (_, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: children[index],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
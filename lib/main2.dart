import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:welfare_app/widgets/horizontal_listview.dart';
import 'package:welfare_app/widgets/image_urls.dart';
import 'package:welfare_app/screens/mypage.dart';
import 'package:welfare_app/screens/settings.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    MyPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'MyPage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('福利厚生'),
          ),
          SliverList(
              delegate: SliverChildListDelegate(
                [
                  HorizontalListView(
                    title: '人気',
                    children: _topGourmet,
                  ),
                  HorizontalListView(
                    title: '子育て・介護',
                    children: _topGourmet.reversed.toList(),
                  ),
                  HorizontalListView(
                    title: '住宅',
                    children: _topGourmet,
                  ),
                  HorizontalListView(
                    title: '通勤',
                    children: _topGourmet,
                  ),
                  HorizontalListView(
                    title: '食事',
                    children: _topGourmet,
                  ),
                  HorizontalListView(
                    title: '健康・ヘルスケア',
                    children: _topGourmet,
                  ),
                  HorizontalListView(
                    title: '慶弔・災害',
                    children: _topGourmet,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: ImageUrls.top.length,
                    itemBuilder: (_, int index) {
                      return Card(
                        child: Image.network(
                          ImageUrls.top[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  List<Widget> get _topGourmet => List.generate(
      ImageUrls.top.length,
          (index) => Image.network(
        ImageUrls.top[index],
        fit: BoxFit.cover,
      ));
}


class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('MyPage'),
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings'),
    );
  }
}

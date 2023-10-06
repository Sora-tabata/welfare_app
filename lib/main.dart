import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:welfare_app/widgets/horizontal_listview.dart';
import 'package:welfare_app/widgets/image_urls.dart';
import 'package:welfare_app/screens/detail_page.dart';
import 'package:welfare_app/screens/detail/property.dart';
import 'package:welfare_app/screens/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:welfare_app/login_parts/login.dart';
import 'package:welfare_app/login_parts/registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return MyHomePage();  // ログイン済みなら、MyHomePageを表示
            } else {
              return LoginPage();  // 未ログインなら、LoginPageを表示
            }
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    MyPage(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            largeTitle: Text('福利厚生一覧'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // 全てのカテゴリを表示
                HorizontalListView(
                  title: '人気',
                  children: popularItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '財産形成',
                  children: propertyItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '食事補助・健康管理',
                  children: mealItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '休暇',
                  children: vacationItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '余暇・レクリエーション',
                  children: recreationItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '自己啓発',
                  children: developmentItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '慶弔・災害',
                  children: disasterItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '住宅補助',
                  children: housingItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '働き方',
                  children: workingItems,
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '育児・介護',
                  children: transportationItems,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> popularItems = [
    TextCard("文章1", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("文章2", () => DetailPage2()),  // DetailPage2 に遷移
    // 他のアイテム
  ];

  List<Widget> propertyItems = [
    TextCard("財形貯蓄制度", () => ProPage1()),  // DetailPage1 に遷移
    TextCard("社内預金制度", () => DetailPage2()),  // DetailPage2 に遷移
    TextCard("社内貸付制度", () => DetailPage2()),
    TextCard("ストックオプション制度", () => DetailPage2()),
    TextCard("セミナー制度", () => DetailPage2()),// 他のアイテム
  ];
  List<Widget> mealItems = [
    TextCard("社員食堂", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("食事手当", () => DetailPage2()),
    TextCard("メンタルヘルスケア", () => DetailPage2()),
    TextCard("人間ドック", () => DetailPage2()),
    TextCard("提携飲食店・ジム", () => DetailPage2()),// DetailPage2 に遷移
    // 他のアイテム
  ];
  List<Widget> vacationItems = [
    TextCard("リフレッシュ休暇", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("ボランティア休暇", () => DetailPage2()),  // DetailPage2 に遷移
    TextCard("アニバーサリー休暇", () => DetailPage2()),
    TextCard("特別有給制度", () => DetailPage2()),// 他のアイテム
  ];
  List<Widget> recreationItems = [
    TextCard("社員旅行", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("社内部活・サークル活動", () => DetailPage2()),
    TextCard("交流会・親睦会", () => DetailPage2()),// DetailPage2 に遷移
    // 他のアイテム
  ];
  List<Widget> developmentItems = [
    TextCard("資格取得支援", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("自己啓発セミナー参加費補助", () => DetailPage2()),
    TextCard("本の購入補助", () => DetailPage2()),
    TextCard("留学・海外研修の補助", () => DetailPage2()),// DetailPage2 に遷移
    // 他のアイテム
  ];
  List<Widget> disasterItems = [
    TextCard("慶弔見舞い金制度", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("傷病・災害見舞金", () => DetailPage2()),  // DetailPage2 に遷移
    TextCard("開店・開業祝い", () => DetailPage2()),
    TextCard("永年勤続表彰", () => DetailPage2()),// 他のアイテム
  ];
  List<Widget> housingItems = [
    TextCard("家賃・住宅手当", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("社員寮・住宅", () => DetailPage2()),
    TextCard("住宅ローン補助", () => DetailPage2()),// DetailPage2 に遷移
    // 他のアイテム
  ];
  List<Widget> workingItems = [
    TextCard("フレックスタイム制度", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("時差出勤制度", () => DetailPage2()),
    TextCard("短時間勤務", () => DetailPage2()),
    TextCard("プレミアムフライデー", () => DetailPage2()),
    TextCard("ノー残業デー", () => DetailPage2()),// DetailPage2 に遷移
    // 他のアイテム
  ];
  List<Widget> transportationItems = [
    TextCard("通勤手当", () => DetailPage1()),  // DetailPage1 に遷移
    TextCard("駐車場の補助", () => DetailPage2()),  // DetailPage2 に遷移
    // 他のアイテム
  ];
}

class TextCard extends StatefulWidget {
  final String text;
  final Widget Function() createPage;  // 遷移先のページを生成する関数

  TextCard(this.text, this.createPage);

  @override
  _TextCardState createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = ColorTween(begin: Colors.teal, end: Colors.teal[700]).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.createPage(),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Card(
            elevation: 5,  // カードに影をつける
            child: Container(
              width: 100,
              height: 100,
              color: _animation.value,  // アニメーションの色
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,  // より高級感のある色
                    fontFamily: 'Serif',  // 高級感のあるフォント
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// HorizontalListView の定義はそのまま


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



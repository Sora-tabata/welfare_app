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
import 'package:welfare_app/firebase_options.dart';
import 'package:welfare_app/widgets/all_vew.dart';

import 'package:provider/provider.dart';
import 'package:welfare_app/models/foundation.dart';
import 'package:welfare_app/screens/mypage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookmarkModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welfare App',
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
              return RegistrationPage();  // 未ログインなら、LoginPageを表示
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

  String _email = '';
  String _password = '';
  String _searchText = '';
  String? getUserNameFromEmail(String? email) {
    if (email == null) {
      return null;
    }
    return email.split('@').first;  // @で区切って最初の部分を取得
  }

  List<TextCardInfo> searchResults = [];


  Future<void> _registerUser() async {
    try {
      final User? user = (await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password))
          .user;
      if (user != null) {
        print("ユーザを登録しました: ${user.email}, ${user.uid}");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userName = getUserNameFromEmail(currentUser?.email);

    return Scaffold(
      appBar: AppBar(
        title: userName != null
            ? Text('$userName様')  // ユーザ名が取得できた場合
            : Text('WELFARE APP'),  // ユーザ名が取得できなかった場合
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                print("ログアウトしました");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                print("ログアウトに失敗しました: $e");
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 検索バーの追加
          TextField(
            onChanged: (text) {
              setState(() {
                _searchText = text;
                searchResults = searchInTextCards(_searchText);  // 検索処理を追加
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          // 検索結果の表示
          if (searchResults.isNotEmpty)  // 検索結果があれば表示
            Column(
              children: searchResults.map((info) => TextCard(info.text, info.imagePath, info.createPage)).toList(),
            ),
          // その他のコンテンツ
          Expanded(
            child: _children[_currentIndex],
          ),
        ],
      ),
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
List<TextCardInfo> searchInTextCards(String query) {
  List<TextCardInfo> allItems = []..addAll(popularItemsInfo)
    ..addAll(propertyItemsInfo)
    ..addAll(mealItemsInfo)
    ..addAll(vacationItemsInfo)
    ..addAll(recreationItemsInfo)
    ..addAll(developmentItemsInfo)
    ..addAll(disasterItemsInfo)
    ..addAll(housingItemsInfo)
    ..addAll(workingItemsInfo)
    ..addAll(helpingItemsInfo)
    ..addAll(transportationItemsInfo);

  return allItems.where((item) => item.text.toLowerCase().contains(query.toLowerCase())).toList();
}
// 人気の項目
List<TextCardInfo> popularItemsInfo = [
  TextCardInfo(text: "家賃・住宅手当", imagePath: "material/img/thumbnail/004_icon_007_housing.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "フレックスタイム制度", imagePath: "material/img/thumbnail/004_icon_008_working.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "人間ドック", imagePath: "material/img/thumbnail/004_icon_002_meal.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "社員食堂", imagePath: "material/img/thumbnail/004_icon_002_meal.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "通勤手当", imagePath: "material/img/thumbnail/004_icon_010_transportation.png", createPage: () => DetailPage1()),
];

// 財産形成の項目
List<TextCardInfo> propertyItemsInfo = [
  TextCardInfo(text: "財形貯蓄制度", imagePath: "material/img/thumbnail/004_icon_001_property.png", createPage: () => ProPage1()),
  TextCardInfo(text: "社内預金制度", imagePath: "material/img/thumbnail/004_icon_001_property.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "社内貸付制度", imagePath: "material/img/thumbnail/004_icon_001_property.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "ストックオプション制度", imagePath: "material/img/thumbnail/004_icon_001_property.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "セミナー制度", imagePath: "material/img/thumbnail/004_icon_001_property.png", createPage: () => DetailPage2()),
];

// 食事・健康の項目
List<TextCardInfo> mealItemsInfo = [
  TextCardInfo(text: "社員食堂", imagePath: "material/img/thumbnail/004_icon_002_meal.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "食事手当", imagePath: "material/img/thumbnail/004_icon_002_meal.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "メンタルヘルスケア", imagePath: "material/img/thumbnail/004_icon_002_meal.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "人間ドック", imagePath: "material/img/thumbnail/004_icon_002_meal.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "提携飲食店・ジム", imagePath: "material/img/thumbnail/004_icon_002_meal.png", createPage: () => DetailPage2()),
];


// 休暇の項目
List<TextCardInfo> vacationItemsInfo = [
  TextCardInfo(text: "リフレッシュ休暇", imagePath: "material/img/thumbnail/004_icon_003_vacation.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "ボランティア休暇", imagePath: "material/img/thumbnail/004_icon_003_vacation.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "アニバーサリー休暇", imagePath: "material/img/thumbnail/004_icon_003_vacation.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "特別有給制度", imagePath: "material/img/thumbnail/004_icon_003_vacation.png", createPage: () => DetailPage2()),
];


// 余暇・レクリエーションの項目
List<TextCardInfo> recreationItemsInfo = [
  TextCardInfo(text: "社員旅行", imagePath: "material/img/thumbnail/004_icon_004_recreation.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "社内部活・サークル活動", imagePath: "material/img/thumbnail/004_icon_004_recreation.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "交流会・親睦会", imagePath: "material/img/thumbnail/004_icon_004_recreation.png", createPage: () => DetailPage2()),
];

// 自己啓発の項目
List<TextCardInfo> developmentItemsInfo = [
  TextCardInfo(text: "資格取得支援", imagePath: "material/img/thumbnail/004_icon_005_development.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "自己啓発セミナー参加費補助", imagePath: "material/img/thumbnail/004_icon_005_development.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "本の購入補助", imagePath: "material/img/thumbnail/004_icon_005_development.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "留学・海外研修の補助", imagePath: "material/img/thumbnail/004_icon_005_development.png", createPage: () => DetailPage2()),
];


// 慶弔・災害の項目
List<TextCardInfo> disasterItemsInfo = [
  TextCardInfo(text: "慶弔見舞い金制度", imagePath: "material/img/thumbnail/004_icon_006_disaster.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "傷病・災害見舞金", imagePath: "material/img/thumbnail/004_icon_006_disaster.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "開店・開業祝い", imagePath: "material/img/thumbnail/004_icon_006_disaster.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "永年勤続表彰", imagePath: "material/img/thumbnail/004_icon_006_disaster.png", createPage: () => DetailPage2()),
];

// 住宅補助の項目
List<TextCardInfo> housingItemsInfo = [
  TextCardInfo(text: "家賃・住宅手当", imagePath: "material/img/thumbnail/004_icon_007_housing.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "社員寮・住宅", imagePath: "material/img/thumbnail/004_icon_007_housing.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "住宅ローン補助", imagePath: "material/img/thumbnail/004_icon_007_housing.png", createPage: () => DetailPage2()),
  // 他の項目を追加できます
];


// 働き方の項目
List<TextCardInfo> workingItemsInfo = [
  TextCardInfo(text: "フレックスタイム制度", imagePath: "material/img/thumbnail/004_icon_008_working.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "時差出勤制度", imagePath: "material/img/thumbnail/004_icon_008_working.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "短時間勤務", imagePath: "material/img/thumbnail/004_icon_008_working.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "プレミアムフライデー", imagePath: "material/img/thumbnail/004_icon_008_working.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "ノー残業デー", imagePath: "material/img/thumbnail/004_icon_008_working.png", createPage: () => DetailPage2()),
];

// 育児・介護の項目
List<TextCardInfo> helpingItemsInfo = [
  TextCardInfo(text: "育児休業の延長制度", imagePath: "material/img/thumbnail/004_icon_009_helping.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "社内保育園・託児所", imagePath: "material/img/thumbnail/004_icon_009_helping.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "ベビーシッター補助金", imagePath: "material/img/thumbnail/004_icon_009_helping.png", createPage: () => DetailPage2()),
  TextCardInfo(text: "介護費用補助", imagePath: "material/img/thumbnail/004_icon_009_helping.png", createPage: () => DetailPage2()),
];

// 交通関連の項目
List<TextCardInfo> transportationItemsInfo = [
  TextCardInfo(text: "通勤手当", imagePath: "material/img/thumbnail/004_icon_010_transportation.png", createPage: () => DetailPage1()),
  TextCardInfo(text: "駐車場の補助", imagePath: "material/img/thumbnail/004_icon_010_transportation.png", createPage: () => DetailPage2()),
  // 他の項目を追加できます
];
TextCard createTextCardFromInfo(TextCardInfo info) {
  return TextCard(info.text, info.imagePath, info.createPage);
}


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //CupertinoSliverNavigationBar(
          //  largeTitle: Text('福利厚生'),
          //),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // 全てのカテゴリを表示
                HorizontalListView(
                  title: '人気',
                  children: popularItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '財産形成',
                  children: propertyItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '食事補助・健康管理',
                  children: mealItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '休暇',
                  children: vacationItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '余暇・レクリエーション',
                  children: recreationItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '自己啓発',
                  children: developmentItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '慶弔・災害',
                  children: disasterItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '住宅補助',
                  children: housingItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '働き方',
                  children: workingItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '育児・介護',
                  children: helpingItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '交通関連',
                  children: transportationItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> popularItems = popularItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> propertyItems = propertyItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> mealItems = mealItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> vacationItems = vacationItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> recreationItems = recreationItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> developmentItems = developmentItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> disasterItems = disasterItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> housingItems = housingItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> workingItems = workingItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> helpingItems = helpingItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> transportationItems = transportationItemsInfo.map(createTextCardFromInfo).toList();

}

class TextCardInfo {
  final String text;
  final String imagePath;
  final Widget Function() createPage;

  TextCardInfo({required this.text, required this.imagePath, required this.createPage});
}




class TextCard extends StatefulWidget {
  final String text;
  final String imagePath;
  final Widget Function() createPage;  // 遷移先のページを生成する関数

  TextCard(this.text, this.imagePath, this.createPage);

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
          return Container(
            width: 180,  // 明示的に幅を設定
            height: 180,  // 明示的に高さを設定
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.3,
                  child: widget.imagePath.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),  // 角を丸くする
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      width: 200,  // Containerと同じサイズ
                      height: 200,  // Containerと同じサイズ
                    ),
                  )
                      : Container(),
                ),
                // テキストを中央に配置
                Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


// HorizontalListView の定義はそのまま




class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings'),
    );
  }
}



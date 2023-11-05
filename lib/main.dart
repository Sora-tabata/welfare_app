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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TextCardInfoModel()),
        // 他のプロバイダー
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welfare App',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // AppBarの背景色を白に設定
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
      ),
      //primarySwatch: Colors.teal,

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
    WorkPage(),
    LifePage(),
    MyPage(),
    SettingsPage(),
  ];

  String _email = '';
  String _password = '';
  //String _searchText = '';
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
  String _companyName = ''; // 会社名を保持するための変数
  String _userName = ''; // ユーザ名を保持するための変数


  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // ユーザーのメールアドレスを基にFirestoreからユーザー情報を取得する
    final userDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: currentUser.email)
        .get();

    if (userDocumentSnapshot.docs.isNotEmpty) {
      final userData = userDocumentSnapshot.docs.first.data();
      final companyCode = userData['companyCode'] as String? ?? '';
      final name = userData['name'] as String? ?? '';
      setState(() {
        _userName = name; // ユーザ名を設定
        if (companyCode == '0000') {
          _companyName = "株式会社与和's";
        } else {
          // companyCodeが'0000'でない場合の処理をここに記述
        }
      });
    } else {
      // ユーザー情報が見つからない場合の処理をここに記述
    }
  }

  @override
  Widget build(BuildContext context) {

    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userName = getUserNameFromEmail(currentUser?.email);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(

                userName != null ? '$_userName様 ' : 'WELFARE APP', // ユーザ名が取得できた場合
                overflow: TextOverflow.ellipsis, // 長すぎるテキストを省略
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
            Flexible(
              child: Text(
                _companyName, // companyCodeに基づいた会社名を表示
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis, // 長すぎるテキストを省略
              ),
            ),
          ],
        ),

        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.grey,
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                print(e); // エラーをコンソールに出力
              }
            },
          ),
        ],
      ),
      // Scaffoldのその他のプロパティ
      body: Column(
        children: [
          // 検索バーの追加
          /*
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
              children: searchResults.map((info) => TextCard(info.text, info.imagePath, info.pageID)).toList(),
            ),
            */

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
        unselectedItemColor: Colors.grey, // 選択されていないアイテムの色
        selectedItemColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Work（働き方）',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlife_rounded),
            label: 'Life（生活）',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}

List<TextCardInfo> searchInTextCards(String query) {
  List<TextCardInfo> allItems = []..addAll(workingtypeItemsInfo)
    ..addAll(vacationItemsInfo)
    ..addAll(assistanceItemsInfo)
    ..addAll(workskillItemsInfo)
    ..addAll(consultationItemsInfo)
    ..addAll(assetItemsInfo)
    ..addAll(healthItemsInfo)
    ..addAll(lifeskillItemsInfo)
    ..addAll(lifestyleItemsInfo);

  return allItems.where((item) => item.text.toLowerCase().contains(query.toLowerCase())).toList();
}
// 人気の項目

// 財産形成の項目
List<TextCardInfo> lifeskillItemsInfo = [
  TextCardInfo(text: "自己啓発補助", imagePath: "material/img/thumbnail/0801.png", pageID:"ProPage1"),
];

// 食事・健康の項目
List<TextCardInfo> healthItemsInfo = [
  TextCardInfo(text: "人間ドック補助", imagePath: "material/img/thumbnail/0701.png", pageID:"ProPage1"),
  TextCardInfo(text: "ストレスチェック", imagePath: "material/img/thumbnail/0702.png", pageID:"ProPage1"),
  TextCardInfo(text: "メンタルヘルスケア", imagePath: "material/img/thumbnail/0703.png", pageID:"ProPage1"),
  TextCardInfo(text: "健康相談", imagePath: "material/img/thumbnail/0704.png", pageID:"ProPage1"),
  TextCardInfo(text: "育児・介護相談", imagePath: "material/img/thumbnail/0705.png", pageID:"ProPage1"),
  TextCardInfo(text: "予防歯科推進", imagePath: "material/img/thumbnail/0706.png", pageID:"ProPage1"),
];


// 休暇の項目
List<TextCardInfo> assetItemsInfo = [
  TextCardInfo(text: "401K制度", imagePath: "material/img/thumbnail/0601.png", pageID:"ProPage1"),
  TextCardInfo(text: "金融相談（投資・ローン・保険）", imagePath: "material/img/thumbnail/0602.png", pageID:"ProPage1"),
];


// 余暇・レクリエーションの項目
List<TextCardInfo> consultationItemsInfo = [
  TextCardInfo(text: "社内通報制度", imagePath: "material/img/thumbnail/0501.png", pageID:"ProPage1"),
  TextCardInfo(text: "育児・介護相談（業務上）", imagePath: "material/img/thumbnail/0502.png", pageID:"ProPage1"),
  TextCardInfo(text: "健康相談（業務上）", imagePath: "material/img/thumbnail/0503.png", pageID:"ProPage1"),
];

// 自己啓発の項目
List<TextCardInfo> workskillItemsInfo = [
  TextCardInfo(text: "資格取得支援制度", imagePath: "material/img/thumbnail/0401.png", pageID:"ProPage1"),
];


// 慶弔・災害の項目
List<TextCardInfo> lifestyleItemsInfo = [
  TextCardInfo(text: "弔慰金（1親等）", imagePath: "material/img/thumbnail/0901.png", pageID:"ProPage1"),
  TextCardInfo(text: "長期療養時給与サポート", imagePath: "material/img/thumbnail/0902.jpeg", pageID:"ProPage1"),
  TextCardInfo(text: "入院見舞金", imagePath: "material/img/thumbnail/0903.jpeg", pageID:"ProPage1"),
];



// 働き方の項目
List<TextCardInfo> workingtypeItemsInfo = [
  TextCardInfo(text: "フレックス勤務", imagePath: "material/img/thumbnail/0101.png", pageID:"ProPage1"),
  TextCardInfo(text: "在宅勤務", imagePath: "material/img/thumbnail/0102.png", pageID:"ProPage1"),
  TextCardInfo(text: "時差出勤制度", imagePath: "material/img/thumbnail/0103.png", pageID:"ProPage1"),
];

// 育児・介護の項目
List<TextCardInfo> vacationItemsInfo = [
  TextCardInfo(text: "時間休制度", imagePath: "material/img/thumbnail/0201.png", pageID:"ProPage1"),
  TextCardInfo(text: "傷病休暇", imagePath: "material/img/thumbnail/0202.png", pageID:"ProPage1"),
  TextCardInfo(text: "リフレッシュ休暇", imagePath: "material/img/thumbnail/0203.png", pageID:"ProPage1"),
  TextCardInfo(text: "忌引き休暇", imagePath: "material/img/thumbnail/0204.png", pageID:"ProPage1"),
  TextCardInfo(text: "介護休業（延長）", imagePath: "material/img/thumbnail/0205.png", pageID:"ProPage1"),
  TextCardInfo(text: "育児休業（延長）", imagePath: "material/img/thumbnail/0206.png", pageID:"ProPage1"),
  TextCardInfo(text: "キャリアアップ休業", imagePath: "material/img/thumbnail/0207.png", pageID:"ProPage1"),
];

// 交通関連の項目
List<TextCardInfo> assistanceItemsInfo = [
  TextCardInfo(text: "通勤手当", imagePath: "material/img/thumbnail/0301.jpeg", pageID:"ProPage1"),
  TextCardInfo(text: "出張手当", imagePath: "material/img/thumbnail/0302.jpeg", pageID:"ProPage1"),
  TextCardInfo(text: "ベビーシッター補助", imagePath: "material/img/thumbnail/0303.jpeg", pageID:"ProPage1"),
  TextCardInfo(text: "ヘルパー補助", imagePath: "material/img/thumbnail/0304.png", pageID:"ProPage1"),
  // 他の項目を追加できます
];
TextCard createTextCardFromInfo(TextCardInfo info) {
  return TextCard(info.text, info.imagePath, info.pageID);
}


class WorkPage extends StatelessWidget {
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

                HorizontalListView(
                  title: '　　勤務形態',
                  children: workingtypeItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　休暇',
                  children: vacationItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　手当・補助',
                  children: assistanceItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　スキルアップ',
                  children: workskillItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　相談窓口',
                  children: consultationItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> workingtypeItems = workingtypeItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> vacationItems = vacationItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> assistanceItems = assistanceItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> workskillItems = workskillItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> consultationItems = consultationItemsInfo.map(createTextCardFromInfo).toList();
}

class LifePage extends StatelessWidget {
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
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　資産形成支援',
                  children: assetItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　健康支援',
                  children: healthItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　スキルアップ支援',
                  children: lifeskillItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
                Divider(height: 1, color: Colors.grey[400], thickness: 2),
                HorizontalListView(
                  title: '　　ライフスタイル',
                  children: lifestyleItems,
                  allPageBuilder: (children, title) => AllPage(children: children, title: title),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  List<Widget> assetItems = assetItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> healthItems = healthItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> lifeskillItems = lifeskillItemsInfo.map(createTextCardFromInfo).toList();
  List<Widget> lifestyleItems = lifestyleItemsInfo.map(createTextCardFromInfo).toList();
}

class TextCardInfo {
  final String text;
  final String imagePath;
  //final Widget Function() createPage;
  final String pageID;

  TextCardInfo({required this.text, required this.imagePath, required this.pageID});
  factory TextCardInfo.fromMap(Map<String, dynamic> data) {
    return TextCardInfo(
      text: data['text'] ?? '',
      imagePath: data['imagePath'] ?? '',
      pageID: data['pageID'], // または適切なページ
    );
  }
}




class TextCard extends StatefulWidget {
  final String text;
  final String imagePath;
  //final Widget Function() createPage;  // 遷移先のページを生成する関数
  final String pageID;

  TextCard(this.text, this.imagePath, this.pageID);

  @override
  _TextCardState createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation _animation;
  bool isLiked = false; //いいねされているかどうかの状態

  Future<void> toggleLike() async{
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("User not logged in");
      return;
    }
    // Firestoreに保存する一意のドキュメントIDを生成（この例ではユーザーIDとテキストで）
    String docId = "${currentUser.uid}_${widget.text}";
    // Firestoreのインスタンスを取得
    final firestore = FirebaseFirestore.instance;

    // いいねの状態をトグル
    if (isLiked) {
      // いいねを取り消す（ドキュメントを削除）
      await firestore.collection('likes').doc(docId).delete();
    } else {
      // いいねをする（ドキュメントを追加）
      await firestore.collection('likes').doc(docId).set({
        'userId': currentUser.uid,
        'text': widget.text,
        'imagePath': widget.imagePath,
        'pageID': widget.pageID,
      });

    }
    // 状態を更新
    setState(() {
      isLiked = !isLiked;
    });


  }
  // Firestoreから「いいね」の状態を取得
  void checkLikeStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }
    String docId = "${currentUser.uid}_${widget.text}";
    final doc = await FirebaseFirestore.instance.collection('likes').doc(docId).get();
    setState(() {
      isLiked = doc.exists;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween(begin: 1.0, end: 0.9).animate(_controller);
    // ... 他の初期化コード
    checkLikeStatus();
  }
  Widget createPage() {
    switch (widget.pageID) {  // widget.pageId を参照
      case 'ProPage1':
        return ProPage1(text: widget.text);
      case 'DetailPage2':
        return DetailPage2();
    // 他のページIDに対する処理を追加
      default:
        return DetailPage1();  // デフォルトページ
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => createPage(),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Material(
            elevation: 4.0,  // ウィジェット全体に影を追加
            borderRadius: BorderRadius.circular(1), // 角を丸くしない
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 2, // 画像が全体の 2/3 の高さを占めるようにします
                        child: Opacity(
                          opacity: 0.5, // 画像の透明度を少し上げる
                          child: widget.imagePath.isNotEmpty
                              ? Image.asset(
                            widget.imagePath,
                            fit: BoxFit.cover,
                            width: 200,  // Containerと同じサイズ
                            height: 180,  // 全体の 2/3 のサイズ
                          )
                              : Container(),
                        ),
                      ),
                      Expanded(
                        flex: 1, // テキストが全体の 1/3 の高さを占めるようにします
                        child: Container(
                          color: Colors.white,  // 下半分を白色に設定
                          child: Center(
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
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        isLiked ? Icons.bookmark : Icons.bookmark_outline_rounded,
                        color: isLiked ? Colors.green : null,
                      ),
                      onPressed: toggleLike,
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


class TextCardInfoModel extends ChangeNotifier {
  List<TextCardInfo> _textCardInfoList = [];

  List<TextCardInfo> get textCardInfoList => _textCardInfoList;

  void setTextCardInfoList(List<TextCardInfo> list) {
    _textCardInfoList = list;
    notifyListeners();
  }

  String _imagePath = 'default_path';
  Widget Function() _createPage = () => DetailPage1(); // デフォルト値


  String get imagePath => _imagePath;
  Widget Function() get createPage => _createPage;

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  void setCreatePage(Widget Function() page) {
    _createPage = page;
    notifyListeners();
  }
}
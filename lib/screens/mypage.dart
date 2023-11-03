import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:welfare_app/main.dart';
import 'package:provider/provider.dart';
import 'package:welfare_app/screens/detail_page.dart';
import 'package:welfare_app/screens/detail/property.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  User? currentUser;
  late Stream<QuerySnapshot> likedItemsStream;
  Stream<QuerySnapshot>? userDataStream;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;

    likedItemsStream = FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: currentUser?.uid)
        .snapshots();

    if (currentUser != null) {
      userDataStream = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser!.email)
          .snapshots();
    }
  }

  Widget createPageFromPageID(String pageID) {
    switch (pageID) {
      case 'ProPage1':
        return ProPage1();
      case 'DetailPage2':
        return DetailPage2();
    // 他のpageIDに対する処理をここに追加
      default:
        return DetailPage1();  // デフォルトの遷移先
    }
  }

  @override
  Widget build(BuildContext context) {
    // モデルを取得
    TextCardInfoModel textCardInfoModel = Provider.of<TextCardInfoModel>(context);

    // モデルからTextCardInfoリストを取得
    List<TextCardInfo> textCardInfoList = textCardInfoModel.textCardInfoList;

    return Scaffold(
      body: Column( // CenterからColumnに変更
        mainAxisSize: MainAxisSize.min, // 子ウィジェットに必要な最小限のスペースを使用
        mainAxisAlignment: MainAxisAlignment.start, // 子ウィジェットを上に詰める
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ユーザーの登録情報を表示するStreamBuilder
          if (currentUser != null)
            StreamBuilder<QuerySnapshot>(
              stream: userDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return Text('ユーザーデータがありません');
                }
                var userData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text('登録情報'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('名前: ${userData['name']}'),
                      Text('社員番号: ${userData['employeeNumber']}'),
                      Text('メール: ${userData['email']}'),
                    ],
                  ),
                );
              },
            ),
          // ブックマークしたページのタイトル
          Text('ブックマークしたページ'),
          // ブックマークしたページを表示するStreamBuilder
          StreamBuilder<QuerySnapshot>(
            stream: likedItemsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snapshot.hasData) {
                return Text('データがありません');
              }
              return ListView(
                shrinkWrap: true, // ListViewが必要なスペースだけを取るように設定
                physics: NeverScrollableScrollPhysics(), // SingleChildScrollViewとの競合を防ぐ
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String pageID = data['pageID'];  // FirestoreからpageIDを取得

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => createPageFromPageID(pageID),  // pageIDに基づいて遷移
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Image.asset(data['imagePath']),  // 画像
                        title: Text(data['text']),  // タイトル
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

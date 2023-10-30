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

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    // Firestoreのlikesコレクションから、現在のユーザーIDに一致するドキュメントを取得
    likedItemsStream = FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: currentUser?.uid)
        .snapshots();
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


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('ブックマークしたページ'),
          StreamBuilder<QuerySnapshot>(
            stream: likedItemsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  return Expanded(
                    child: ListView(
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
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

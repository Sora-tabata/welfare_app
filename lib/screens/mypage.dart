import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
                        // TODO: ここで取得したデータを適切なモデルに変換する
                        // 例: TextCardInfo info = TextCardInfo.fromMap(data);
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(...);  // 遷移先を指定
                          },
                          child: Card(
                            child: ListTile(
                              // leading: Image.asset(info.imagePath),  // 画像
                              // title: Text(info.text),  // タイトル
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

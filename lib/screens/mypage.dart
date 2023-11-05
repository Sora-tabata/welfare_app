import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:welfare_app/main.dart';
import 'package:provider/provider.dart';
import 'package:welfare_app/screens/detail_page.dart';
import 'package:welfare_app/screens/detail/property.dart';
import 'package:welfare_app/widgets/all_vew.dart';

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

  Widget createPageFromPageID(String pageID, Map<String, dynamic> data) {
    switch (pageID) {
      case 'ProPage1':
        return ProPage1(text: data['text'],);
      case 'DetailPage2':
        return DetailPage2();
    // 他のpageIDに対する処理をここに追加
      default:
        return DetailPage1();  // デフォルトの遷移先
    }
  }
  void toggleLike(String docId, bool newLikeStatus) {
    final docRef = FirebaseFirestore.instance.collection('likes').doc(docId);

    if (newLikeStatus) {
      // ブックマークを追加する場合
      docRef.update({'isLiked': true}).then((_) {
        print('Bookmark added.');
      }).catchError((error) {
        print('Failed to add bookmark: $error');
      });
    } else {
      // ブックマークを解除する場合
      docRef.delete().then((_) {
        print('Bookmark removed.');
      }).catchError((error) {
        print('Failed to remove bookmark: $error');
      });
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
                  title: Text('登録情報',style: TextStyle(fontSize: 24),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('名前: ${userData['name']}',style: TextStyle(fontSize: 18),),
                      Text('社員番号: ${userData['employeeNumber']}',style: TextStyle(fontSize: 18),),
                      Text('メール: ${userData['email']}', style: TextStyle(fontSize: 18),),
                    ],
                  ),
                );
              },
            ),
          // ブックマークしたページのタイトル

          Text('ブックマークしたページ'),
          // ブックマークしたページを表示するStreamBuilder
          // Replace the existing StreamBuilder for likedItemsStream with this
          Divider(height: 5, color: Colors.grey[400], thickness: 2),
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

              return Container(
                height: 150.0,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.horizontal,

                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    String pageID = data['pageID'];
                    bool isLiked = data['isLiked'] ?? true;


                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => createPageFromPageID(pageID, data),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  flex: 2, // 画像が全体の 2/3 の高さを占めるようにします
                                  child: Opacity(
                                    opacity: 0.5, // 画像の透明度を少し上げる
                                    child: data['imagePath'].isNotEmpty
                                        ? Image.asset(
                                      data['imagePath'],
                                      fit: BoxFit.cover,
                                      width: 150,  // Containerと同じサイズ
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
                                        data['text'],
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
                                onPressed: () {
                                  toggleLike(document.id, !isLiked);
                                },
                              ),
                            ),
                          ],
                        ),
                      )

                    );
                  },
                ),
              );
            },
          ),
          Divider(height: 7, color: Colors.grey[400], thickness: 2),


        ],
      ),
    );
  }
}

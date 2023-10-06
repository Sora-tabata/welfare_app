import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignUpModel extends ChangeNotifier {
  String mail = "";
  String password = "";

  //FirebaseAuthのインスタンスを生成
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signup() async {
    if (mail.isEmpty) {
      throw "メールアドレスを入力して下さい";
    }
    if (password.isEmpty) {
      throw "パスワードを入力して下さい";
    }
    //Fire Auth に新規登録ユーザーの情報を書き込む
    final UserCredential user = await auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    );

    final email = user.user!.email;
    // FireStoreに新規登録ユーザーの情報を書き込む
    await FirebaseFirestore.instance.collection("users").add({
      "email": email,
      "password": password,
      "createAt": Timestamp.now(),
    });
  }
}

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
        ),
        body: Consumer<SignUpModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (text) {
                    model.mail = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onChanged: (text) {
                    model.password = text;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await model.signup();
                      Navigator.of(context).pushReplacementNamed('/');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  child: Text('Sign Up'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
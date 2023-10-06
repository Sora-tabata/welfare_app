import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginModel extends ChangeNotifier {
  String mail = "";
  String password = "";

  //FirebaseAuthのインスタンスを生成
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future login() async {
    if (mail.isEmpty) {
      throw "メールアドレスを入力して下さい";
    }
    if (password.isEmpty) {
      throw "パスワードを入力して下さい";
    }
    //ToDo
    final userInfo = await auth.signInWithEmailAndPassword(
      email: mail,
      password: password,
    );

    // final uid = userInfo.user!.uid;
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Consumer<LoginModel>(
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
                      await model.login();
                      Navigator.of(context).pushReplacementNamed('/');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

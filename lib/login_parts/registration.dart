import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:welfare_app/login_parts/login.dart';

class SignUpModel extends ChangeNotifier {
  String companyCode = "";
  String employeeNumber = "";
  String name = "";
  String mail = "";
  String password = "";

  //FirebaseAuthのインスタンスを生成
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signup() async {
    if (companyCode.isEmpty) {
      throw "企業コードを入力してください";
    }
    if (employeeNumber.isEmpty) {
      throw "社員番号を入力してください";
    }
    if (name.isEmpty) {
      throw "氏名を入力してください";
    }
    if (mail.isEmpty) {
      throw "メールアドレスを入力してください";
    }
    if (password.isEmpty) {
      throw "パスワードを入力してください";
    }

    // Fire Auth に新規登録ユーザーの情報を書き込む
    final UserCredential user = await auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    );

    final email = user.user!.email;
    // FireStoreに新規登録ユーザーの情報を書き込む
    await FirebaseFirestore.instance.collection("users").add({
      "companyCode": companyCode,
      "employeeNumber": employeeNumber,
      "name": name,
      "email": email,
      "password": password, // パスワードをFirestoreに保存することはセキュリティリスクがあるため推奨されません。
      "createdAt": Timestamp.now(),
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
            return SingleChildScrollView( // 入力フォームが多いのでスクロール可能にする
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Company Code'),
                    onChanged: (text) {
                      model.companyCode = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Employee Number'),
                    onChanged: (text) {
                      model.employeeNumber = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onChanged: (text) {
                      model.name = text;
                    },
                  ),
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Go to Login Page'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

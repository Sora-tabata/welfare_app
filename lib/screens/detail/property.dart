import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ProPage1 extends StatelessWidget {
  final String text;
  ProPage1({required this.text});
  final String googleFormUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLSdGsZFt751pP3K9HwhzpIapS68bFhf1ABLu25XoRCc1h9yFdw/viewform";

  Future<Map<String, dynamic>> loadContent() async {
    String jsonString = await rootBundle.loadString('material/contents_of_welfare.json'); // ファイル名を修正しました
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    if (jsonMap.containsKey(text)) {
      return jsonMap[text];
    } else {
      throw 'Key not found: $text';
    }
  }
  

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Makes AppBar's leading buttons black
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.black45,
            fontFamily: 'Serif',
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.white,
        // Changed to a more sophisticated color
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSection('概要', data['概要']),
                  Divider(color: Colors.black54),
                  buildSection('利用方法', data['利用方法']),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _launchURL(googleFormUrl),
                    child: Text(
                      '申請ページへ（Googleフォーム）',
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black54, // Match the AppBar color
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black87, // Changed to match the AppBar color
              fontFamily: 'Serif',
            ),
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 20,
              height: 1.5,
              color: Colors.black87,
              fontFamily: 'Serif',
            ),
          ),
        ],
      ),
    );
  }
}

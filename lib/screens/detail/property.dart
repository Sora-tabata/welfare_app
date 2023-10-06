import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class ProPage1 extends StatelessWidget {
  final String googleFormUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLSdGsZFt751pP3K9HwhzpIapS68bFhf1ABLu25XoRCc1h9yFdw/viewform";

  Future<Map<String, dynamic>> loadContent() async {
    String jsonString = await rootBundle.loadString('material/property.json');
    return json.decode(jsonString)['formalsaving'];
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
        title: Text(
          '財形貯蓄制度',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Serif',
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> content = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSection('財形貯蓄制度とは？', content['introduction']),
                  Divider(color: Colors.teal),
                  buildSection('メリット', content['merits']),
                  Divider(color: Colors.teal),
                  buildSection('デメリット', content['demerits']),
                  Divider(color: Colors.teal),
                  buildSection('こんな方におすすめ', content['recommended']),
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
                      primary: Colors.teal,
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
              color: Colors.teal,
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

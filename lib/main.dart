import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

Future<ShibaPic> fetchShibaPic() async {
  final response = await http.get(Uri.parse(
      'http://shibe.online/api/shibes?count=[1]&urls=[false]&httpsUrls=[true]'));
  if (response.statusCode == 200) {
    print(response.body);
    return ShibaPic.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('柴犬画像取得できず');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ShibaPic> futurePic;

  @override
  void initState() {
    super.initState();
    futurePic = fetchShibaPic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("shiba"),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
          children: <Widget>[
            FutureBuilder<ShibaPic>(
                future: futurePic,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (!snapshot.hasData) {
                      return Text("データが見つかりません");
                    }
                    // データ表示
                    return Image(
                        image: NetworkImage(
                            'https://cdn.shibe.online/shibes/${snapshot.data!.picId}.jpg'));
                  } else {
                    // 処理中の表示
                    return const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator());
                  }
                }),
            ElevatedButton(
              child: const Text('柴犬'),
              onPressed: () async {
                futurePic = fetchShibaPic();
                setState(() {});
              },
            ),
          ],
        ))));
  }
}

///
/// 柴犬の画像クラス
///
class ShibaPic {
  final String picId;

  const ShibaPic({required this.picId});

  factory ShibaPic.fromJson(List<dynamic> json) {
    return ShibaPic(picId: json[0] as String);
  }
}

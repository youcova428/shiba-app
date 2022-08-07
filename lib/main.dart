import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loop_page_view/loop_page_view.dart';
import 'package:spring/spring.dart';

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
  late Future<ShibaPic> _futurePic;
  final int _itemCount = 1;
  final LoopPageController _controller = LoopPageController();
  bool _isIconShown = false;

  @override
  void initState() {
    super.initState();
    _futurePic = fetchShibaPic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: const Text("shiba"),
        ),
        body: Center(
          child: FutureBuilder<ShibaPic>(
              future: _futurePic,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  if (!snapshot.hasData) {
                    return Text("データが見つかりません");
                  }
                  // データ表示
                  return GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _isIconShown = !_isIconShown;
                        });
                        // 1秒後削除
                        Future.delayed(const Duration(milliseconds: 1200), () {
                          setState(() {
                            if (_isIconShown) {
                              _isIconShown = false;
                            }
                          });
                        });
                      },
                      child: Stack(
                        children: [
                          LoopPageView.builder(
                            controller: _controller,
                            itemCount: _itemCount,
                            itemBuilder: (_, index) {
                              return Image(
                                  image: NetworkImage(
                                      'https://cdn.shibe.online/shibes/${snapshot.data!.picId}.jpg'));
                            },
                            onPageChanged: (value) {
                              _futurePic = fetchShibaPic();
                              setState(() {
                                if (_isIconShown) _isIconShown = false;
                              });
                            },
                          ),
                          Center(
                            child: Spring.bubbleButton(
                              bubbleStart: .5,
                              bubbleEnd: 1.0,
                              onTap: () {},
                              delay: const Duration(milliseconds: 0),
                              animDuration: const Duration(milliseconds: 1000),
                              child: Visibility(
                                visible: _isIconShown,
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 120,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                } else {
                  // 処理中の表示
                  return const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator());
                }
              }),
        ));
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

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loop_page_view/loop_page_view.dart';
import 'package:shiba_app/favorite_page.dart';
import 'package:spring/spring.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

Future<List<String>> fetchShibaPic() async {
  final response = await http.get(Uri.parse(
      'http://shibe.online/api/shibes?count=100&urls=[false]&httpsUrls=[true]'));
  if (response.statusCode == 200) {
    print(response.body);
    List<dynamic> jsonArray = json.decode(response.body);
    List<String> picIdList = jsonArray.map((e) => e.toString()).toList();
    return picIdList;
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
  late Future<List<String>> _futurePic;
  final LoopPageController _controller = LoopPageController();
  bool _isIconShown = false;
  List<String> favArray = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _futurePic = fetchShibaPic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.brown),
                  child: Text(
                    'Shiba',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('HOME'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('お気に入り'),
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FavoritePage(favArray: favArray)))
                        .then((value) {
                      favArray = value;
                    });
                  },
                ),
              ],
            ),
          ),
          // backgroundColor: Colors.black12,
          appBar: AppBar(
            title: const Text("HOME"),
            backgroundColor: Colors.brown,
            centerTitle: true,
          ),
          body: Center(
            child: FutureBuilder<List<String>>(
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
                          favArray.add(snapshot.data![_currentPage]);
                          print("お気に入りリスト");
                          for (String picId in favArray) {
                            print(picId);
                          }
                          setState(() {
                            _isIconShown = !_isIconShown;
                          });
                          // 1秒後削除
                          Future.delayed(const Duration(milliseconds: 1200),
                              () {
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
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) {
                                return Image(
                                    image: NetworkImage(
                                        'https://cdn.shibe.online/shibes/${snapshot.data![index]}.jpg'));
                              },
                              onPageChanged: (page) {
                                if (page == snapshot.data!.length - 1) {
                                  _futurePic = fetchShibaPic();
                                }
                                setState(() {
                                  if (_isIconShown) _isIconShown = false;
                                  _currentPage = page;
                                });
                              },
                            ),
                            Center(
                              child: Spring.bubbleButton(
                                bubbleStart: .5,
                                bubbleEnd: 1.0,
                                onTap: () {},
                                delay: const Duration(milliseconds: 0),
                                animDuration:
                                    const Duration(milliseconds: 1000),
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
          )),
    );
  }
}

///
/// 柴犬の画像クラス
///
class ShibaPic {
  final List<String> picIds;

  const ShibaPic({required this.picIds});

  // DesignPattern Factory
  factory ShibaPic.fromJson(List<dynamic> json) =>
      ShibaPic(picIds: json as List<String>);
}

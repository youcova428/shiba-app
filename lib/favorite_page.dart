import 'package:flutter/material.dart';
import 'package:shiba_app/detail_page.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key, required this.favArray}) : super(key: key);
  List<String> favArray;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  static const double favIconSize = 30;
  static const double shadowValue = 15;
  bool _deleteMode = false;
  List<FavPic> _favPicList = [];

  @override
  initState() {
    super.initState();
    List<FavPic> favoriteList = [];
    widget.favArray.forEach((picId) {
      favoriteList.add(FavPic(picId: picId, isSelected: false));
    });

    print('お気に入りリスト');
    for (int i = 0; i < favoriteList.length; i++) {
      print("$i番目 ${favoriteList[i].picId}");
    }
    _favPicList = favoriteList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text("お気に入り"),
          actions: [
            IconButton(
                onPressed: () {
                  if (_deleteMode) {
                    showDialog<void>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text('削除'),
                            content: const Text('選択した画像を削除しますか。'),
                            actions: <Widget>[
                              GestureDetector(
                                child: const Text('いいえ'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              GestureDetector(
                                child: const Text('はい'),
                                onTap: () {
                                  for (int i = 0; i < _favPicList.length; i++) {
                                    print(
                                        "index:$i picId:${_favPicList[i].picId} isSelected:${_favPicList[i].isSelected}");
                                    if (_favPicList[i].isSelected) {
                                      _favPicList.removeAt(i);
                                      --i;
                                    }
                                  }
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                  setState(() {
                    _deleteMode = !_deleteMode;
                  });
                },
                icon: Icon(Icons.delete,
                    color: _deleteMode ? Colors.indigo : Colors.white))
          ],
          backgroundColor: Colors.brown,
          centerTitle: true,
        ),
        body: GridView.builder(
            itemCount: _favPicList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    print('タップされたindex:$index');
                    if (_deleteMode) {
                      setState(() {
                        if (_favPicList[index].isSelected) {
                          _favPicList[index].isSelected = false;
                        } else {
                          _favPicList[index].isSelected = true;
                        }
                      });
                      print('isSelected:${_favPicList[index].isSelected}');
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  favPicList: _favPicList, index: index)));
                    }
                  },
                  onLongPress: () {
                    _favPicList.removeAt(index);
                    setState(() {});
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn.shibe.online/shibes/${_favPicList[index].picId}.jpg"),
                                fit: BoxFit.cover)),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              activeColor: Colors.green,
                              value: _favPicList[index].isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (_deleteMode) {
                                    _favPicList[index].isSelected
                                        ? _favPicList[index].isSelected = false
                                        : _favPicList[index].isSelected = true;
                                  }
                                });
                              }),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: favIconSize,
                          shadows: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: shadowValue,
                            )
                          ],
                        ),
                      )
                    ],
                  ));
            }),
      ),
    );
  }
}

class FavPic {
  String picId;
  bool isSelected;

  FavPic({required this.picId, required this.isSelected});
}

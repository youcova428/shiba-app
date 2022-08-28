import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiba_app/detail_page.dart';
import 'package:shiba_app/main.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key, required this.favArray}) : super(key: key);
  List<String> favArray;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  static const double favIconSize = 30;
  static const double shadowValue = 15;
  List<FavPic> _favPicList = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const String favArrayKey = 'favArray';

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
      home: GetX<Controller>(
        builder: (c) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                  onPressed: () => Get.back()),
              title: const Text("お気に入り"),
              actions: [
                IconButton(
                    onPressed: () {
                      if (c.deleteMode.value && isSelectedCheck(_favPicList)) {
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
                                      Get.back();
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
                                      _setFavArray(convertList(_favPicList));
                                      setState(() {});
                                      Get.back();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                      if (!(c.deleteMode.value &&
                          isSelectedCheck(_favPicList))) {
                        c.isDeleteMode(!c.deleteMode.value);
                      }
                    },
                    icon: Icon(Icons.delete_outline_sharp,
                        color: c.deleteMode.value
                            ? Colors.blueAccent[700]
                            : Colors.white))
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
                        if (c.deleteMode.value) {
                          setState(() {
                            if (_favPicList[index].isSelected) {
                              _favPicList[index].isSelected = false;
                            } else {
                              _favPicList[index].isSelected = true;
                            }
                          });
                          print('isSelected:${_favPicList[index].isSelected}');
                        } else {
                          Get.to(DetailPage(favPicList: _favPicList, index: index));
                        }
                      },
                      onLongPress: () {
                        _favPicList.removeAt(index);
                        _setFavArray(convertList(_favPicList));
                        setState(() {});
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                              imageUrl:
                              "https://cdn.shibe.online/shibes/${_favPicList[index].picId}.jpg",
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )),
                              )),
                          GestureDetector(
                            onTap: () {},
                            child: Align(
                              alignment: const Alignment(1.25, 1.25),
                              child: c.deleteMode.value
                                  ? Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      activeColor: Colors.blueAccent[700],
                                      value: _favPicList[index].isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          if (c.deleteMode.value) {
                                            _favPicList[index].isSelected
                                                ? _favPicList[index]
                                                .isSelected = false
                                                : _favPicList[index]
                                                .isSelected = true;
                                          }
                                        });
                                      }))
                                  : Container(),
                            ),
                          ),
                          c.deleteMode.value
                              ? const Icon(null)
                              : const Align(
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
                              ))
                        ],
                      ));
                }),
          );
        },
      )
    );
  }

  /// お気に入りリスト削除選択されているかどうか確認するチェックメソッド。
  bool isSelectedCheck(List<FavPic> favList) {
    for (FavPic favPic in favList) {
      if (favPic.isSelected) return true;
    }
    return false;
  }

  /// List<FavPic> -> List<String> 変換　メソッド
  List<String> convertList(List<FavPic> favPicList) {
    List<String> favList = [];
    favPicList.forEach((favPic) {
      favList.add(favPic.picId);
    });
    return favList;
  }

  Future<void> _setFavArray(List<String> favList) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList(favArrayKey, favList);
  }
}

class FavPic {
  String picId;
  bool isSelected;

  FavPic({required this.picId, required this.isSelected});
}

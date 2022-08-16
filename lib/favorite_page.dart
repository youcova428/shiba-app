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
  bool deleteMode = false;
  List<String> selectedList = [];

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
                  if (!deleteMode) selectedList = [];
                  if (deleteMode && selectedList.isNotEmpty) {
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
                                  for (int i = 0;
                                      i < selectedList.length;
                                      i++) {
                                    for (int j = 0;
                                        j < widget.favArray.length;
                                        j++) {
                                      if (selectedList[i] ==
                                          widget.favArray[j]) {
                                        widget.favArray.removeAt(j);
                                      }
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
                    deleteMode = !deleteMode;
                  });
                },
                icon: Icon(Icons.delete,
                    color: deleteMode ? Colors.indigo : Colors.white))
          ],
          backgroundColor: Colors.brown,
          centerTitle: true,
        ),
        body: GridView.builder(
            itemCount: widget.favArray.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    if (deleteMode) {
                      selectedList.add(widget.favArray[index]);
                      print("削除するリスト");
                      for (String id in selectedList) {
                        print(id);
                      }
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                  favArray: widget.favArray, index: index)));
                    }
                  },
                  onLongPress: () {
                    widget.favArray.removeAt(index);
                    setState(() {});
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn.shibe.online/shibes/${widget.favArray[index]}.jpg"),
                                fit: BoxFit.cover)),
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

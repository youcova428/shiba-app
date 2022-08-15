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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("お気に入り"),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                              favArray: widget.favArray, index: index)));
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
    );
  }
}

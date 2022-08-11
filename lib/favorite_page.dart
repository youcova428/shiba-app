import 'package:flutter/material.dart';
import 'package:shiba_app/detail_page.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key, required this.favArray}) : super(key: key);
  List<String> favArray;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
              child: Image(
                  image: NetworkImage(
                      "https://cdn.shibe.online/shibes/${widget.favArray[index]}.jpg"),
                  fit: BoxFit.cover),
            );
          }),
    );
  }
}

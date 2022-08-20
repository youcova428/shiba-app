import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:shiba_app/favorite_page.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.favPicList, required this.index})
      : super(key: key);
  List<FavPic> favPicList;
  int index;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final LoopPageController _controller = LoopPageController();
  bool pageFlag = true;

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
              title: const Text("画像詳細"),
              backgroundColor: Colors.brown,
              centerTitle: true,
            ),
            body: LoopPageView.builder(
              controller: _controller,
              itemCount: widget.favPicList.length,
              itemBuilder: (_, index) {
                return Center(
                  child: Image(
                      image: NetworkImage(
                          "https://cdn.shibe.online/shibes/${widget.favPicList[widget.index].picId}.jpg")),
                );
              },
              onPageChanged: (int page) {
                if (pageFlag) {
                  pageFlag = false;
                  // fixme 左右スワイプ可能にさせる。
                  print("page: $page");
                  print("widget.index : ${widget.index}");
                  print("_controller.page : ${_controller.page}");
                  setState(() {
                    widget.index = page;
                  });
                  print("after setState page: $page");
                  print("after setState widget.index : ${widget.index}");
                }
                _controller
                    .nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInBack)
                    .whenComplete(() {
                  pageFlag = true;
                });
              },
            )));
  }
}

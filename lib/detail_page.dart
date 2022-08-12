import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.favArray, required this.index})
      : super(key: key);
  List<String> favArray;
  int index;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final LoopPageController _controller = LoopPageController();
  bool pageFlag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          title: const Text("画像詳細"),
          backgroundColor: Colors.brown,
          centerTitle: true,
        ),
        body: LoopPageView.builder(
          controller: _controller,
          itemCount: widget.favArray.length,
          itemBuilder: (_, index) {
            return Center(
              child: Image(
                  image: NetworkImage(
                      "https://cdn.shibe.online/shibes/${widget.favArray[widget.index]}.jpg")),
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
        ));
  }
}

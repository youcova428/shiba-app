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
          itemCount: widget.favArray.length,
          itemBuilder: (_, index) {
            return Center(
              child: Image(
                  image: NetworkImage(
                      "https://cdn.shibe.online/shibes/${widget.favArray[widget.index]}.jpg")),
            );
          },
          onPageChanged: (value) {
            // todo 一度だけ呼ばれるようにする
            widget.index == widget.favArray.length - 1
                ? widget.index = 0
                : widget.index += 1;
            setState(() {});
          },
        ));
  }
}

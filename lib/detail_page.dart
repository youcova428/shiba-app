import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
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
  PageController?  _controller;
  bool pageFlag = true;

  @override
  void initState() {
    super.initState();
   _controller = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () =>  Get.back()),
              title: const Text("画像詳細"),
              backgroundColor: Colors.brown,
              centerTitle: true,
            ),
            body: PhotoViewGallery.builder(
              // todo 背景テーマ対応させる
              itemCount: widget.favPicList.length,
              pageController: _controller,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                        "https://cdn.shibe.online/shibes/${widget.favPicList[widget.index].picId}.jpg"));
              },
              onPageChanged: onPageChanged,
            )));
  }

  void onPageChanged(int index) {
    // todo getX observable パラメータ
    setState(() {
      widget.index = index;
    });
  }
}

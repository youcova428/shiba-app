import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';
import 'package:shiba_app/favorite_page.dart';

import 'main.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.favPicList, required this.index})
      : super(key: key);
  List<FavPic> favPicList;
  int index;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  PageController? _controller;
  bool pageFlag = true;
  final List<String> _popMenuList = ['ダウンロード', '共有'];

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
    Controller c = Get.find();
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () => Get.back()),
              title: const Text("画像詳細"),
              backgroundColor: Colors.brown,
              centerTitle: true,
              actions: [
                PopupMenuButton(
                    icon: const Icon(Icons.share),
                    initialValue: '',
                    onSelected: (String s) {
                      c.selectedItem.value = s;
                      switch (c.selectedItem.value) {
                        case 'ダウンロード':
                          break;
                        case '共有':
                          _sharePicture();
                          break;
                      }
                      print('${c.selectedItem.value}が押下されました。');
                    },
                    itemBuilder: (context) {
                      return _popMenuList.map((String s) {
                        return PopupMenuItem(
                          value: s,
                          child: Text(s),
                        );
                      }).toList();
                    })
              ],
            ),
            body: PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? const Color.fromRGBO(48, 48, 48, 1.0)
                      : const Color.fromRGBO(250, 250, 250, 1.0)),
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

  void _sharePicture() {
    Share.share('この写真を共有しますか');
  }
}

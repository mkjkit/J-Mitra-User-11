import 'package:flutter/material.dart';

class ViewLargeImage extends StatefulWidget {
  final String imageUrl;
  const ViewLargeImage({Key key, @required this.imageUrl}) : super(key: key);

  @override
  State<ViewLargeImage> createState() => _ViewLargeImageState();
}

class _ViewLargeImageState extends State<ViewLargeImage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Image(
          image: NetworkImage(widget.imageUrl),
        ),
      ),
    );
  }
}

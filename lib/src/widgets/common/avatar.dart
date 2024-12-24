import 'package:api/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImggenUserAvatar extends StatefulWidget {
  const ImggenUserAvatar(
      {super.key, required this.avatar, this.size = 48.0, this.isHero = true});

  final Avatar avatar;

  final double size;

  final bool isHero;

  @override
  State<ImggenUserAvatar> createState() => _ImggenUserAvatarState();
}

class _ImggenUserAvatarState extends State<ImggenUserAvatar> {
  @override
  Widget build(BuildContext context) {
    Widget child;

    if (widget.avatar.isData) {
      child = Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: MemoryImage(widget.avatar.data), fit: BoxFit.cover),
        ),
      );
    } else if (widget.avatar.isColors) {
      child = Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: widget.avatar.hslColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    } else {
      child = Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: CachedNetworkImageProvider(widget.avatar.value)),
        ),
      );
    }

    if (widget.isHero) {
      return Hero(
        key: Key(widget.avatar.toString()),
        tag: widget.avatar,
        child: child,
      );
    }

    return child;
  }
}

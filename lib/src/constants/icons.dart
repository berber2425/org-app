import 'package:org_app/src/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

mixin ImgGenIconNames {
  static const google = "assets/icons/google.svg";
  static const apple = "assets/icons/apple.svg";
  static const email = "assets/icons/email.svg";
  static const back = "assets/icons/back.svg";

  // newly added
  static const notVisible = "assets/icons/notvisiable.svg";
  static const visible = "assets/icons/visiable.svg";
  static const close = "assets/icons/close.svg";

  static const next = "assets/icons/forward.svg";

  // static const visible = "assets/icons/svg/visiable.svg";
  //
  // static const aiPortrait = "assets/icons/svg/ai_portrait.svg";
  //
  //
  //
  //
  // static const oneCoin = "assets/icons/svg/1Coin.svg";
  // static const twoCoin = "assets/icons/svg/2Coins.svg";
  // static const threeCoin = "assets/icons/svg/3Coins.svg";
  // static const fourCoin = "assets/icons/svg/4Coins.svg";
  // static const share = 'assets/icons/svg/share.svg';
  // static const token = 'assets/icons/svg/token.svg';
  // static const settings = 'assets/icons/svg/Settings.svg';
  // static const location = 'assets/icons/svg/location.svg';
  // static const visiable = 'assets/icons/svg/visiable.svg';
  // static const tutorial = 'assets/icons/svg/tutorial.svg';
  // static const aiCamera = "assets/icons/svg/camera.svg";
  // static const dropDown = 'assets/icons/svg/dropdown.svg';
  // static const lightBulb = 'assets/icons/svg/lightbulb.svg';
  // static const generate = 'assets/icons/svg/generate.svg';
  // static const camera = 'assets/icons/svg/camera.svg';
  // static const gallery = 'assets/icons/svg/gallery.svg';
  // static const edit = 'assets/icons/svg/edit.svg';
  // static const crop = 'assets/icons/svg/crop.svg';
  // static const delete = 'assets/icons/svg/delete.svg';
  // static const add = 'assets/icons/svg/add.svg';
  // static const success = 'assets/icons/svg/success.svg';
  // static const lock = 'assets/icons/svg/lock.svg';
  // static const download = 'assets/icons/svg/download.svg';
  // static const upload = "assets/icons/svg/Image Upload.svg";
  // static const menu = "assets/icons/svg/menu.svg";
  // static const filter = "assets/icons/svg/filter.svg";
  // static const sort = "assets/icons/svg/sort.svg";
  // static const forward = "assets/icons/svg/forward.svg";
  // static const info = "assets/icons/svg/info.svg";
  // static const randomRegenerate = "assets/icons/svg/random_regenerate.svg";
}

mixin ImgGenIcons {
  static ColorFilter? _color(BuildContext context, Color? color) {
    return ColorFilter.mode(
      color ??
          IconTheme.of(context).color ??
          DefaultTextStyle.of(context).style.color ??
          AppColors.brandPrimary,
      BlendMode.srcIn,
    );
  }

  static Widget name(String name, {double? size, Color? color}) =>
      _widget(name, size: size, color: color);

  static Widget _widget(String name, {double? size, Color? color}) => Builder(
    key: ValueKey(name),
    builder: (context) {
      final s = size ?? IconTheme.of(context).size ?? 20;
      return SvgPicture.asset(
        name,
        width: s,
        height: s,
        colorFilter: _color(context, color),
      );
    },
  );

  // static Widget next({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.next);

  static Widget pwdVisibility(bool visible, {double? size, Color? color}) =>
      _widget(visible ? ImgGenIconNames.visible : ImgGenIconNames.notVisible);

  // static Widget aiPortrait({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.aiPortrait, size: size, color: color);

  static Widget close({double? size, Color? color}) =>
      _widget(ImgGenIconNames.close, size: size, color: color);

  // static Widget back({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.back, size: size, color: color);

  // static Widget favoriteEmpty({double? size, Color? color}) =>
  //     _widget('assets/icons/svg/Like_lined.svg', size: size, color: color);

  // static Widget favoriteFilled({double? size, Color? color}) =>
  //     _widget('assets/icons/svg/Like_filled.svg', size: size, color: color);

  // static Widget oneCoin({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.oneCoin, size: size, color: color);

  // static Widget twoCoin({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.twoCoin, size: size, color: color);

  // static Widget threeCoin({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.threeCoin, size: size, color: color);

  // static Widget fourCoin({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.fourCoin, size: size, color: color);

  // static Widget share({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.share, size: size, color: color);

  // static Widget token({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.token, size: size, color: color);

  // static Widget settings({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.settings, size: size, color: color);

  // static Widget location({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.location, size: size, color: color);

  // static Widget visiable({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.visiable, size: size, color: color);

  // static Widget tutorial({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.tutorial, size: size, color: color);

  // static Widget aiCamera({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.aiCamera, size: size, color: color);

  // static Widget dropDown({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.dropDown, size: size, color: color);

  // static Widget lightBulb({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.lightBulb, size: size, color: color);

  // static Widget generate({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.generate, size: size, color: color);

  // static Widget camera({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.camera, size: size, color: color);

  // static Widget gallery({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.gallery, size: size, color: color);

  // static Widget edit({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.edit, size: size, color: color);

  // static Widget crop({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.crop, size: size, color: color);

  // static Widget delete({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.delete, size: size, color: color);

  // static Widget add({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.add, size: size, color: color);

  // static Widget success({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.success, size: size, color: color);

  // static Widget lock({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.lock, size: size, color: color);

  // static Widget download({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.download, size: size, color: color);

  // static Widget upload({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.upload, size: size, color: color);

  // static Widget menu({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.menu, size: size, color: color);

  // static Widget filter({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.filter, size: size, color: color);

  // static Widget sort({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.sort, size: size, color: color);

  // static Widget forward({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.forward, size: size, color: color);

  // static Widget info({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.info, size: size, color: color);

  // static Widget randomRegenerate({double? size, Color? color}) =>
  //     _widget(ImgGenIconNames.randomRegenerate, size: size, color: color);
}

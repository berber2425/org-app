import 'dart:math';
import 'package:org_app/src/utils/auth.dart';
import 'package:org_app/src/utils/extensions.dart';
import 'package:org_app/src/utils/organization.dart';
import 'package:org_app/src/widgets/common/avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';

class _ScaffoldState extends InheritedWidget {
  const _ScaffoldState({required this.scaffoldKey, required super.child});

  final GlobalKey<ScaffoldState> scaffoldKey;

  static GlobalKey<ScaffoldState>? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ScaffoldState>()!
        .scaffoldKey;
  }

  @override
  bool updateShouldNotify(_ScaffoldState oldWidget) {
    return oldWidget.scaffoldKey != scaffoldKey;
  }
}

class BerberScaffold extends StatefulWidget {
  const BerberScaffold({super.key, this.appBar, this.body});

  final Widget? appBar;
  final Widget? body;

  @override
  State<BerberScaffold> createState() => _BerberScaffoldState();
}

class _BerberScaffoldState extends State<BerberScaffold> {
  bool get orgSelected => OrganizationController().isSelected;

  final key = GlobalKey<ScaffoldState>();

  final menus = [
    ("Home", "/"),
    ("Members", "/members"),
    ("Settings", "/settings"),
  ];

  bool onRoute(int index) {
    final route =
        GoRouter.of(context).routerDelegate.currentConfiguration.matches[0];

    final item = menus[index];

    if (index == 0) {
      return route.matchedLocation == "/";
    }

    return route.matchedLocation.startsWith(item.$2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer:
          !orgSelected
              ? null
              : Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: [
                          ImggenUserAvatar(
                            avatar: OrganizationController().org.avatar,
                            size: 64,
                          ),
                          Text(OrganizationController().org.name),
                        ],
                      ),
                    ),

                    for (var menu in menus)
                      Builder(
                        builder: (context) {
                          final isOnRoute = onRoute(menus.indexOf(menu));
                          return ListTile(
                            title: Text(
                              menu.$1,
                              style: TextStyle(
                                color:
                                    isOnRoute
                                        ? AppColors.supportBlack
                                        : AppColors.supportDarkGrey,
                              ),
                            ),
                            onTap: () {
                              if (isOnRoute) {
                                context.pop();
                              } else {
                                context.go(menu.$2);
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
      appBar:
          widget.appBar != null
              ? PreferredSize(
                preferredSize: Size.fromHeight(56),
                child: _ScaffoldState(scaffoldKey: key, child: widget.appBar!),
              )
              : null,
      body: widget.body,
    );
  }
}

class BerberAppBar extends StatefulWidget {
  const BerberAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBack,
  });

  final Widget? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  State<BerberAppBar> createState() => _BerberAppBarState();
}

class _BerberAppBarState extends State<BerberAppBar> {
  final auth = AuthController();
  final orgController = OrganizationController();

  bool get orgSelected => orgController.isSelected;

  bool get isAuth => auth.isAuthenticated;

  double get leftPadding {
    if (orgSelected) {
      return 72;
    }
    return 0;
  }

  double get rightPadding {
    if (isAuth) {
      return 48;
    }
    return 0;
  }

  double get titlePadding {
    return max(leftPadding, rightPadding);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.supportWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.supportBlack.op(0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      height: 56,
      width: double.infinity,
      child: Row(
        children: [
          if (orgSelected &&
              (_ScaffoldState.of(context)!.currentState?.hasDrawer ?? false))
            IconButton(
              onPressed: () {
                _ScaffoldState.of(context)!.currentState!.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),

          if ((widget.showBackButton && context.canPop()) ||
              widget.onBack != null)
            IconButton(
              onPressed: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                } else {
                  context.pop();
                }
              },
              icon: Icon(Icons.arrow_back),
            ),

          if (widget.title != null)
            Expanded(child: Center(child: widget.title!)),

          if (widget.actions != null) ...widget.actions!,

          if (isAuth) ImggenUserAvatar(avatar: auth.user.avatar, size: 36),
        ],
      ),
    );
  }
}

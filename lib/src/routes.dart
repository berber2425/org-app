import 'dart:async';

import 'package:org_app/src/pages/auth/sign_up_main_screen.dart';
import 'package:org_app/src/pages/org/org_home.dart';
import 'package:org_app/src/pages/members/org_members.dart';
import 'package:org_app/src/pages/org/org_select.dart';
import 'package:org_app/src/pages/showcase/theme_showcase.dart';
import 'package:org_app/src/utils/device.dart';
import 'package:org_app/src/utils/organization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:org_data/org_data.dart';

import 'pages/members/member_page.dart';
import 'pages/org/org_create.dart';
import 'pages/splash.dart';
import 'utils/auth.dart';

/// Rotalar 3 kategoriye ayrılır:
///
/// 1 - Auth gerektirmeyen ama auth ise redirect edenler
/// 2 - Auth olup olmaması fark etmeyenler
/// 3 - Kalanları ise auth gerektirenler

const notAuthRequired = ["/auth"];

const doesNotMatter = ["/feedback", "/welcome", "/theme"];

const orgNotRequired = [
  "/welcome",
  "/auth",
  "/feedback",
  "/organizations",
  "/create_org",
  "/theme",
];

typedef Middleware<T> = FutureOr<T?> Function(String value);

typedef RouteDef =
    ({
      Widget Function({Key? key}) builder,
      Map<String, Middleware> middlewares,
    });

final Map<String, RouteDef> routes = {
  "/auth": (builder: SignUpMainScreen.new, middlewares: {}),
  "/": (builder: OrganizationHomePage.new, middlewares: {}),
  "/organizations": (builder: OrganizationSelectPage.new, middlewares: {}),
  "/create_org": (builder: OrgCreatePage.new, middlewares: {}),
  "/members": (builder: OrgMembers.new, middlewares: {}),
  "/theme": (builder: ThemeShowcase.new, middlewares: {}),
  "/members/:member_id": (
    builder: MemberPage.new,
    middlewares: {
      "member_id": (value) async {
        final res = await Api.query.getMember(value);
        return res;
      },
    },
  ),
};

FutureOr<String?> splashLoad(String location) {
  if (location == "/welcome") {
    return null;
  }

  FutureOr<String?> orgInit() {
    if (notAuthRequired.contains(location)) {
      return "/";
    }

    if (orgNotRequired.contains(location)) {
      return null;
    }

    return Future(() async {
      final orgController = OrganizationController();
      if (!orgController.initialized) {
        await orgController.initialize();
      }

      if (orgController.isSelected) {
        return null;
      } else {
        return "/organizations";
      }
    });
  }

  FutureOr<String?> init() {
    if (AuthController().initialized) {
      return orgInit();
    }

    if (notAuthRequired.contains(location)) {
      return null;
    }

    return Future(() async {
      await AuthController().init();

      if (doesNotMatter.contains(location)) {
        return null;
      }

      if (AuthController().isAuthenticated) {
        return orgInit();
      }

      return "/auth";
    });
  }

  if (!DeviceController().initialized) {
    return Future(() async {
      await DeviceController().init();
      return init();
    });
  }

  return init();
}

final router = GoRouter(
  initialLocation: "/welcome",
  routes:
      [
        GoRoute(
          path: "/welcome",
          builder: (context, state) => const SplashScreen(),
        ),
        ...routes.entries.map(
          (e) => GoRoute(
            redirect: (context, state) {
              return splashLoad(e.key);
            },
            path: e.key,
            builder: (context, state) {
              final resolvedParameters = ParametersHolder();
              final parameters = <String, String>{};
              for (final parameter in e.key.split("/").skip(1)) {
                if (!parameter.startsWith(":")) {
                  continue;
                }

                final parameterName = parameter.substring(1);

                parameters[parameterName] =
                    state.pathParameters[parameterName]!;
              }

              final resolvers = <FutureOr>[];

              for (final parameter in parameters.entries) {
                final resolver = e.value.middlewares[parameter.key];

                if (state.extra != null) {
                  resolvedParameters.set(
                    parameter.key,
                    (state.extra as Map<String, dynamic>)[parameter.key]!,
                  );
                } else if (resolver != null) {
                  resolvers.add(
                    (() {
                      final res = resolver(parameter.value);
                      if (res is Future) {
                        return Future(() async {
                          final waitedRes = await res;
                          resolvedParameters.set(parameter.key, waitedRes);
                          return waitedRes;
                        });
                      }
                      resolvedParameters.set(parameter.key, res);
                      return res;
                    })(),
                  );
                }
              }

              final child = _ParametersHolder(
                parameters: resolvedParameters,
                child: e.value.builder(),
              );

              if (resolvers.isNotEmpty) {
                if (resolvers.any((e) => e is Future)) {
                  return _Loader(
                    resolver: Future.wait(
                      resolvers.map((e) {
                        if (e is Future) {
                          return e;
                        }
                        return Future.value(e);
                      }),
                    ),
                    builder: () {
                      Future.wait(
                        resolvers.map((e) {
                          if (e is Future) {
                            return e;
                          }
                          return Future.value(e);
                        }),
                      ).then((value) {});
                      return child;
                    },
                  );
                }
              }

              return child;
            },
          ),
        ),
      ].toList(),
);

extension Routes on BuildContext {
  T parameterValue<T>() {
    return _ParametersHolder.of(this).find<T>()!;
  }

  T parameterValueByName<T>(String name) {
    return _ParametersHolder.of(this).get<T>(name);
  }

  void goSplash() {
    return go("/welcome");
  }

  Future<void> pushSplash() {
    return push("/welcome");
  }

  void goAuth() {
    return go("/auth");
  }

  Future<void> pushAuth() {
    return push("/auth");
  }

  void goHome() {
    return go("/");
  }

  void goMember(Fragment$Member member) {
    return go("/members/${member.id}", extra: {"member_id": member});
  }

  Future<void> pushMember(Fragment$Member member) {
    return push("/members/${member.id}", extra: {"member_id": member});
  }

  void goOrgSelect() {
    return go("/organizations");
  }

  void goOrgCreate() {
    return go("/create_org");
  }

  void goMembers() {
    return go("/members");
  }

  void goTheme() {
    return go("/theme");
  }

  Future<void> pushTheme() {
    return push("/theme");
  }
}

class ParametersHolder {
  final Map<String, dynamic> parameters = {};

  void set<T>(String key, T value) {
    parameters[key] = value;
  }

  T get<T>(String key) {
    return parameters[key] as T;
  }

  T? find<T>() {
    for (final parameter in parameters.entries) {
      if (parameter.value is T) {
        return parameter.value as T;
      }
    }
    return null;
  }
}

class _Loader extends StatefulWidget {
  const _Loader({required this.resolver, required this.builder});

  final Future resolver;
  final Widget Function() builder;

  @override
  State<_Loader> createState() => __LoaderState();
}

class __LoaderState extends State<_Loader> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.resolver,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const SizedBox.shrink();
          case ConnectionState.waiting:
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          case ConnectionState.active:
            return widget.builder();
          case ConnectionState.done:
            return widget.builder();
        }
      },
    );
  }
}

class _ParametersHolder extends InheritedWidget {
  const _ParametersHolder({required super.child, required this.parameters});

  final ParametersHolder parameters;

  static ParametersHolder of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ParametersHolder>()!
        .parameters;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

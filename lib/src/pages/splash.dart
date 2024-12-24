import 'package:org_app/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.settings});
  final RouteSettings? settings;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      final r = await splashLoad("/");
      if (mounted) {
        if (r != null) {
          context.go(r);
        } else {
          context.go("/");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.settings?.name ?? 'Splash')),
    );
  }
}

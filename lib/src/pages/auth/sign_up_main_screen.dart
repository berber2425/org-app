import 'package:org_app/src/scaffolds/auth_scaffold.dart';
import 'package:flutter/material.dart';

import 'auth_scaffold.dart';

class SignUpMainScreen extends StatelessWidget {
  const SignUpMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(
      title: "Welcome to",
      children: [SocialMediaIcons()],
    );
  }
}

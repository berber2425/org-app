import 'package:org_app/src/scaffolds/index.dart';
import 'package:org_app/src/utils/organization.dart';
import 'package:flutter/material.dart';

class OrganizationHomePage extends StatefulWidget {
  const OrganizationHomePage({super.key});

  @override
  State<OrganizationHomePage> createState() => _OrganizationHomePageState();
}

class _OrganizationHomePageState extends State<OrganizationHomePage> {
  final orgController = OrganizationController();

  @override
  Widget build(BuildContext context) {
    if (!orgController.isSelected) {
      return const Center(child: Text("No organization selected"));
    }

    return AppScaffold(
      title: "Home",
      body: Center(child: Text(orgController.org.name)),
    );
  }
}

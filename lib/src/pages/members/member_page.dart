import 'package:flutter/cupertino.dart';
import 'package:org_app/src/routes.dart';
import 'package:org_app/src/scaffolds/app_scaffold.dart';
import 'package:org_data/org_data.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Member ${context.parameterValue<Fragment$Member>().user!.name}",
      body: Column(
        children: [
          Text(
            "Member ${context.parameterValue<Fragment$Member>().user!.name}",
          ),
          Text("Role: ${context.parameterValue<Fragment$Member>().role.name}"),
        ],
      ),
    );
  }
}

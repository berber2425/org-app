import 'package:api/api.dart';
import 'package:org_app/src/routes.dart';
import 'package:org_app/src/scaffolds/index.dart';
import 'package:org_app/src/utils/auth.dart';
import 'package:org_app/src/widgets/common/avatar.dart';
import 'package:flutter/material.dart';
import 'package:org_data/org_data.dart';

class OrgMembers extends StatefulWidget {
  const OrgMembers({super.key});

  @override
  State<OrgMembers> createState() => _OrgMembersState();
}

class _OrgMembersState extends State<OrgMembers> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Members",
      body: PaginationMembers(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (member) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.goMember(member);
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ImggenUserAvatar(
                      avatar: member.user?.avatar ?? Avatar(value: "10,10,10"),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.user?.name ?? "Unknown",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            member.role.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (AuthController().user.id == member.user?.id)
                      const Text("You"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

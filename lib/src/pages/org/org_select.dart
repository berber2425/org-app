import 'package:api/api.dart';
import 'package:org_app/src/constants/icons.dart';
import 'package:org_app/src/routes.dart';
import 'package:org_app/src/widgets/common/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:org_data/org_data.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../utils/organization.dart';
import '../../widgets/components/organization_card.dart';

class OrganizationSelectPage extends StatefulWidget {
  const OrganizationSelectPage({super.key});

  @override
  State<OrganizationSelectPage> createState() => _OrganizationSelectPageState();
}

class _OrganizationSelectPageState extends State<OrganizationSelectPage> {
  @override
  Widget build(BuildContext context) {
    return BerberScaffold(
      appBar: BerberAppBar(title: Text("Select Organization")),
      body: Center(
        child: PaginationMyMemberships(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          itemBuilder:
              (data) => InkWell(
                onTap: () async {
                  final controller = OrganizationController();
                  await controller.select(data.organization.id);

                  if (controller.isSelected) {
                    if (context.mounted) context.goHome();
                  }
                },
                child: OrganizationCard(membership: data),
              ),
          additionalWidgets: [
            InkWell(
              onTap: () => context.goOrgCreate(),
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 8,
                    children: [
                      ImgGenIcons.close(size: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Create new organization")],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          loadingBuilder:
              (data) => Skeletonizer(
                enabled: true,
                child: ListView(
                  children: [
                    OrganizationCard(
                      fake: true,
                      membership: Fragment$TempMembership(
                        id: "id",
                        status: Enum$MemberStatus.ACTIVE,
                        organization: Fragment$TempMembership$organization(
                          id: "id",
                          name: "My Organization",
                          avatar: Avatar(value: "10,20,30"),
                        ),
                        role: Fragment$TempMembership$role(
                          id: "id",
                          name: "Owner",
                        ),
                        branch: Fragment$TempMembership$branch(
                          id: "id",
                          name: "My Branch",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          separatorBuilder: (data, index) => const SizedBox(height: 16),
        ),
      ),
    );
  }
}

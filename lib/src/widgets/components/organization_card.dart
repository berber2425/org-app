import 'package:org_app/src/widgets/common/avatar.dart';
import 'package:flutter/material.dart';
import 'package:org_data/org_data.dart';

class OrganizationCard extends StatefulWidget {
  const OrganizationCard({
    super.key,
    required this.membership,
    this.fake = false,
  });

  final Fragment$TempMembership membership;
  final bool fake;

  @override
  State<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<OrganizationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8,
          children: [
            if (widget.fake)
              Icon(Icons.business, size: 48)
            else
              ImggenUserAvatar(
                isHero: false,
                avatar: widget.membership.organization.avatar,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.membership.organization.name),
                  Text(widget.membership.role.name),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

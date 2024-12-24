import 'package:api/api.dart';
import 'package:org_app/src/components/buttons/app_button.dart';
import 'package:org_app/src/components/inputs/app_form_field.dart';
import 'package:org_app/src/utils/auth.dart';
import 'package:org_app/src/utils/organization.dart';
import 'package:org_app/src/utils/random.dart';
import 'package:org_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:org_data/org_data.dart';
import 'package:sign_flutter/sign_flutter.dart';

import '../../widgets/common/select_avatar.dart';
import '../../widgets/components/address_input.dart';

enum OrgCreateType {
  singleBranch(
    title: "Tek Şube",
    description: "Tek şubeli bir organizasyon oluşturun",
    icon: Icons.home,
  ),
  multiBranch(
    title: "Çok Şube",
    description: "Çok şubeli bir organizasyon oluşturun",
    icon: Icons.home,
  ),
  freelance(
    title: "Serbest",
    description: "Yalnızca kendiniz için bir organizasyon oluşturun",
    icon: Icons.person,
  );

  const OrgCreateType({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  Enum$OrganizationType get type {
    switch (this) {
      case OrgCreateType.singleBranch:
        return Enum$OrganizationType.SINGLE_BRANCH;
      case OrgCreateType.multiBranch:
        return Enum$OrganizationType.MULTI_BRANCH;
      case OrgCreateType.freelance:
        return Enum$OrganizationType.FREELANCER;
    }
  }

  static OrgCreateType fromServer(Enum$OrganizationType type) {
    switch (type) {
      case Enum$OrganizationType.SINGLE_BRANCH:
        return OrgCreateType.singleBranch;
      case Enum$OrganizationType.MULTI_BRANCH:
        return OrgCreateType.multiBranch;
      case Enum$OrganizationType.FREELANCER:
        return OrgCreateType.freelance;
      case Enum$OrganizationType.$unknown:
        throw Exception("Unknown organization type");
    }
  }
}

class OrgCreateController extends VoidSignal with Slot {
  final name = "".signal;
  final avatar = Avatar.fromString(randomColor()).signal;
  final type = (null as OrgCreateType?).signal;
  final valid = false.signal;
  final mainBranch = (null as String?).signal;
  final address = Signal<Input$AddressInput?>(null);
  final mainBranchAddress = Signal<Input$AddressInput?>(null);

  OrgCreateController({
    String? name,
    OrgCreateType? type,
    dynamic avatar,
    String? mainBranch,
    Input$AddressInput? address,
    Input$AddressInput? mainBranchAddress,
  }) {
    if (name != null) {
      this.name.value = name;
    }

    if (type != null) {
      this.type.value = type;
    }

    if (avatar != null) {
      this.avatar.value = avatar;
    }

    if (mainBranch != null) {
      this.mainBranch.value = mainBranch;
    }

    if (address != null) {
      this.address.value = address;
    }

    if (mainBranchAddress != null) {
      this.mainBranchAddress.value = mainBranchAddress;
    }

    this.name.addSlot(this);
    this.type.addSlot(this);
    this.avatar.addSlot(this);
    this.mainBranch.addSlot(this);
    this.address.addSlot(this);
    this.mainBranchAddress.addSlot(this);
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "İsim boş olamaz";
    }
    if (value.length < 3) {
      return "İsim en az 3 karakter olmalıdır";
    }

    if (value.length > 50) {
      return "İsim en fazla 50 karakter olmalıdır";
    }

    return null;
  }

  void checkValid() {
    if (type.value == null) {
      valid.value = false;
      return;
    }

    final nameError = nameValidator(name.value);
    if (nameError != null) {
      valid.value = false;
      return;
    }

    final mainBranchError = nameValidator(mainBranch.value);
    if (mainBranchError != null) {
      valid.value = false;
      return;
    }

    if (address.value == null) {
      valid.value = false;
      return;
    }

    if (mainBranchAddress.value == null) {
      valid.value = false;
      return;
    }

    valid.value = true;
  }

  @override
  void onValue(value) {
    checkValid();
    emit();
  }
}

class OrgCreatePage extends StatefulWidget {
  const OrgCreatePage({super.key});

  @override
  State<OrgCreatePage> createState() => _OrgCreatePageState();
}

class _OrgCreatePageState extends State<OrgCreatePage> {
  final controller = OrgCreateController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildFreelance() {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: double.infinity),
        ...[
          SizedBox(
            width: double.infinity,
            child: Text(
              "Serbest çalışan olarak markanızı yaratın",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start,
            ),
          ),
          Divider(),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Marka Bilgilerin",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          AppTextFormField(
            onChanged: (value) {
              controller.name.value = value;
              controller.mainBranch.value = value;
            },
            label: "Marka İsmi",
            initialValue: controller.name.value,
          ),
          SelectAvatar(avatar: controller.avatar),
          Divider(),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Ofis/Menajer Adresiniz",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Bu adres, sizinle iletişim için kullanılacak, açık olarak görünmeyecektir.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          AddressInput(
            address: controller.address.value,
            onChanged: (value) {
              controller.address.value = value;
              controller.mainBranchAddress.value = value;
            },
          ),
        ].map(
          (e) => ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, minWidth: 200),
            child: e,
          ),
        ),
      ],
    );
  }

  Widget _buildSingleBranch() {
    return Column(children: [Text("Create single branch organization")]);
  }

  Widget _buildMultiBranch() {
    return Column(children: [Text("Create multi branch organization")]);
  }

  Widget buildSecond() {
    return controller.type.value == OrgCreateType.freelance
        ? _buildFreelance()
        : controller.type.value == OrgCreateType.singleBranch
        ? _buildSingleBranch()
        : _buildMultiBranch();
  }

  final formKey = GlobalKey<AppFormState>();

  @override
  Widget build(BuildContext context) {
    return controller.type.builder((v) {
      return BerberScaffold(
        appBar: BerberAppBar(
          onBack:
              controller.type.value != null
                  ? () {
                    controller.type.value = null;
                  }
                  : null,
          title: Text("Markanı Yarat"),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedCrossFade(
                    firstChild: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Center(
                        child: Column(
                          spacing: 16,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Markanızın/Şirketinizin tipini seçiniz",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            ...OrgCreateType.values.map(
                              (e) => InkWell(
                                onTap: () {
                                  switch (e) {
                                    case OrgCreateType.freelance:
                                      final n = AuthController().user.name;
                                      controller.name.value = n;
                                      controller.mainBranch.value = n;
                                      break;
                                    case OrgCreateType.singleBranch:
                                      break;
                                    case OrgCreateType.multiBranch:
                                      break;
                                  }

                                  controller.type.value = e;
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      Icon(e.icon, size: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.title,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                            ),
                                            Text(
                                              e.description,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondChild: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Center(
                        child: AppForm(
                          key: formKey,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 120,
                            ),
                            child: buildSecond(),
                          ),
                        ),
                      ),
                    ),
                    crossFadeState:
                        controller.type.value == null
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                    duration: kThemeAnimationDuration,
                  );
                },
              ),
            ),
            [controller.valid].multiSignal.builder((value) {
              return AnimatedPositioned(
                bottom:
                    16 +
                    MediaQuery.of(context).padding.bottom +
                    (controller.type.value == null ? -200 : 0),
                left: 16,
                right: 16,
                duration: kThemeAnimationDuration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.valid.builder((valid) {
                      return AppButton(
                        isActive: valid,
                        onInactivePressed: () {
                          formKey.currentState?.validate();
                        },
                        onPressed: () async {
                          final res = await Api.mutation.createOrg(
                            Input$CreateOrgInput(
                              address: controller.address.value!,
                              mainBranch: Input$MainBranchInput(
                                name: controller.mainBranch.value!,
                                address: controller.mainBranchAddress.value!,
                              ),
                              name: controller.name.value,
                              type: controller.type.value!.type,
                              avatar: controller.avatar.value.asDataInput,
                              hslAvatar: controller.avatar.value.asHslInput,
                              cp_template:
                                  Enum$CancellationPolicyTemplate.DEFAULT,
                            ),
                          );

                          await OrganizationController().select(res);

                          if (context.mounted) context.go("/");
                        },
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text("Markanı Yarat"),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

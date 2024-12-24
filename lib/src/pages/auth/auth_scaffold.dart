import 'package:org_app/src/components/buttons/app_button.dart';
import 'package:org_app/src/constants/app_colors.dart';
import 'package:org_app/src/constants/icons.dart';
import 'package:org_app/src/pages/auth/sign_up_with_mail_screen.dart';
import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_textstyle.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: () {},
      title: Row(
        spacing: 8,
        children: [
          SvgPicture.asset(ImgGenIconNames.google),
          const Text("Continue With Google"),
        ],
      ),
      customBackgroundDecoration: BoxDecoration(
        color: AppColors.supportWhite,
        borderRadius: BorderRadius.circular(1000.0),
      ),
    );
  }
}

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: () {},
      title: Row(
        spacing: 8,
        children: [
          SvgPicture.asset(
            ImgGenIconNames.apple,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const Text("Continue With Apple"),
        ],
      ),
      customBackgroundDecoration: BoxDecoration(
        color: AppColors.surfacePrimary.op(1),
        borderRadius: BorderRadius.circular(1000.0),
      ),
      customTextStyle: textTheme(
        context,
      ).buttonLarge.copyWith(color: AppColors.supportWhite.op(1)),
      customIconSize: 30.0,
      customIconTheme: const IconThemeData(
        color: AppColors.supportWhite,
        size: 24.0,
      ),
    );
  }
}

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        const GoogleSignInButton(),
        const AppleSignInButton(),
        AppButton(
          onPressed: () async {
            // await Get.toNamed(RouteNames.signUpWithMailScreen,
            //     parameters: Get.parameters as Map<String, String>?);
            // Get.back();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignUpWithMailScreen(),
              ),
            );
            if (context.mounted) Navigator.of(context).pop();
          },
          title: Row(
            spacing: 8,
            children: [
              ImgGenIcons.name(ImgGenIconNames.email),
              const Text("Continue With Email"),
            ],
          ),
        ),
      ],
    );
  }
}

// class AuthScaffold extends StatelessWidget {
//   const AuthScaffold({
//     super.key,
//     required this.title,
//     this.backgroundImage = "",
//     required this.children,
//   });

//   final String backgroundImage;
//   final List<Widget> children;
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         bottom: false,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               bottom: 0,
//               // height: MediaQuery.of(context).size.height -
//               //     MediaQuery.of(context).padding.top,
//               child: SizedBox.fromSize(
//                 size: MediaQuery.of(context).size,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   fit: StackFit.expand,
//                   children: [
//                     SizedBox.fromSize(size: MediaQuery.of(context).size),
//                     Positioned(
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height,
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(200),
//                           ),
//                           image: DecorationImage(
//                             image: CachedNetworkImageProvider(backgroundImage),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     AnimatedPositioned(
//                       duration: const Duration(milliseconds: 60),
//                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         width: double.infinity,
//                         constraints: BoxConstraints(
//                           maxHeight: MediaQuery.of(context).size.height * 0.6,
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32.0,
//                           vertical: 0.0,
//                         ),
//                         child: SingleChildScrollView(
//                           padding: const EdgeInsets.symmetric(vertical: 24.0),
//                           child: Column(
//                             spacing: 16,
//                             children: [
//                               GradientText(
//                                 title,
//                                 gradient: AppColors.primaryGradient,
//                                 style: textTheme(context).headlineSmall.bold,
//                               ),
//                               const SizedBox(height: 1),
//                               const Brand(),
//                               ...children,
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (Navigator.of(context).canPop())
//               Positioned(
//                 top: 10,
//                 left: 10,
//                 child: AppButton(
//                   key: const Key("back"),
//                   variant: AppButtonVariant.outlined,
//                   title: ImgGenIcons.name(ImgGenIconNames.back),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

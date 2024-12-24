import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../components/buttons/app_button.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.children,
    this.onBackPressed,
    this.showBackButton = true,
  });

  /// Sayfanın başlığı
  final String title;

  /// Sayfa içeriği
  final List<Widget> children;

  /// Geri butonu tıklandığında çalışacak fonksiyon
  final VoidCallback? onBackPressed;

  /// Geri butonunun gösterilip gösterilmeyeceği
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arkaplan şekilleri
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: AppColors.highlightGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.highlightShadow.op(0.2),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: AppColors.highlightGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.highlightShadow.op(0.1),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          // Ana içerik
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Geri butonu ve başlık
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showBackButton &&
                            Navigator.of(context).canPop()) ...[
                          AppButton(
                            variant: AppButtonVariant.text,
                            title: const Icon(Icons.arrow_back),
                            onPressed:
                                onBackPressed ??
                                () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                        Text(
                          title,
                          style: AppTypography.displaySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // İçerik
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xl,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ...children,
                      // Klavye açıldığında bottom padding
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

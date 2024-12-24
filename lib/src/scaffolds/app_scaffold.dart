import 'package:org_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:org_data/org_data.dart';
import '../theme/theme.dart';
import '../components/buttons/app_button.dart';
import '../utils/organization.dart';
import '../utils/auth.dart';
import '../utils/extensions.dart';

class MenuItem {
  const MenuItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final IconData icon;
  final String route;
}

class AppScaffold extends StatefulWidget {
  AppScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
  }) : super(key: Key("page_scaffold_$title"));

  /// Sayfanın başlığı
  final String title;

  /// Sayfa içeriği
  final Widget body;

  /// AppBar'daki aksiyonlar
  final List<Widget>? actions;

  /// Geri butonunun gösterilip gösterilmeyeceği
  final bool showBackButton;

  /// Geri butonu tıklandığında çalışacak fonksiyon
  final VoidCallback? onBackPressed;

  /// Floating action button
  final Widget? floatingActionButton;

  /// Floating action button konumu
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Bottom navigation bar
  final Widget? bottomNavigationBar;

  static const List<MenuItem> menuItems = [
    MenuItem(title: 'Ana Sayfa', icon: Icons.home_outlined, route: '/'),
    MenuItem(title: 'Üyeler', icon: Icons.people_outline, route: '/members'),
    MenuItem(
      title: 'Randevular',
      icon: Icons.calendar_today_outlined,
      route: '/appointments',
    ),
    MenuItem(
      title: 'Ayarlar',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
  ];

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drawerController;

  late final Animation<double> _drawerSlide = CurvedAnimation(
    parent: _drawerController,
    curve: Curves.easeInOut,
  );

  bool _isDrawerOpen = false;

  bool get _isOrgSelected => OrganizationController().isSelected;
  bool get isWideScreen => MediaQuery.of(context).size.width > 600;

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _drawerController.forward();
      } else {
        _drawerController.reverse();
      }
    });
  }

  @override
  void initState() {
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  Fragment$MeOrganization get org => OrganizationController().org;

  Widget buildMenuItem(MenuItem item) {
    final isSelected =
        currentRoute == item.route ||
        (item.route != '/' && currentRoute.startsWith(item.route));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        onTap: () {
          if (!isWideScreen) {
            _toggleDrawer();
          }
          if (currentRoute != item.route) {
            context.go(item.route);
          }
        },
        child: Container(
          height: 48,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.op(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              if (isWideScreen || _isDrawerOpen)
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTypography.labelLarge.copyWith(
                      color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border(
          bottom: BorderSide(color: Colors.white.op(0.1), width: 1),
        ),
      ),
      child: Column(
        children: [
          ImggenUserAvatar(avatar: org.avatar, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(
            org.name,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            variant: AppButtonVariant.text,
            size: AppButtonSize.small,
            title: Text(
              "Değiştir",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildSideMenu() {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.op(0.1),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          buildDrawerHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                children: [
                  for (final item in AppScaffold.menuItems) buildMenuItem(item),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.op(0.1),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!_isOrgSelected || !isWideScreen)
            if (widget.showBackButton && context.canPop())
              AppButton(
                variant: AppButtonVariant.text,
                title: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: AppColors.primary,
                ),
                onPressed: widget.onBackPressed ?? () => context.pop(),
              )
            else if (_isOrgSelected)
              AppButton(
                variant: AppButtonVariant.text,
                title: Icon(Icons.menu, size: 20, color: AppColors.primary),
                onPressed: _toggleDrawer,
              ),
          const SizedBox(width: AppSpacing.md),
          Text(
            widget.title,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          if (widget.actions != null) ...widget.actions!,
          const SizedBox(width: AppSpacing.md),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Text(
              user.name.substring(0, 1).toUpperCase(),
              style: AppTypography.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get currentRoute =>
      GoRouter.of(
        context,
      ).routerDelegate.currentConfiguration.matches.first.matchedLocation;

  Fragment$PublicUser get user => AuthController().user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ana içerik
          Positioned.fill(
            child: Column(
              children: [
                buildAppBar(),
                Expanded(
                  child: Row(
                    children: [
                      if (isWideScreen && _isOrgSelected) buildSideMenu(),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(AppSpacing.lg),
                          child: widget.body,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.bottomNavigationBar != null)
                  widget.bottomNavigationBar!,
              ],
            ),
          ),

          // Menü paneli (dar ekran)
          if (!isWideScreen && _isOrgSelected)
            AnimatedBuilder(
              animation: _drawerSlide,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Karartma
                    if (_isDrawerOpen)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: _toggleDrawer,
                          child: Container(
                            color: Colors.black.op(0.3 * _drawerSlide.value),
                          ),
                        ),
                      ),

                    // Menü
                    Positioned(
                      left: -280 * (1 - _drawerSlide.value),
                      top: 0,
                      bottom: 0,
                      width: 280,
                      child: buildSideMenu(),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}

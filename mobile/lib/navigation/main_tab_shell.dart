import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/glass_theme.dart';
import '../core/constants/app_sizes.dart';
import '../widgets/glass/glass_bottom_nav.dart';
import '../widgets/buttons/sos_button.dart';
import '../screens/home/home_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/sos/sos_confirmation_sheet.dart';

class MainTabShell extends StatefulWidget {
  const MainTabShell({super.key});

  @override
  State<MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<MainTabShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    MapScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  Future<void> _onSosPressed() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SosConfirmationSheet(
        eventType: 'MANUAL',
        isTest: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: GlassTheme.backgroundGradient(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingMd,
            0,
            AppSizes.paddingMd,
            AppSizes.paddingMd,
          ),
          child: GlassBottomNav(
            currentIndex: _currentIndex,
            onTabSelected: _onTabTapped,
            onSosPressed: _onSosPressed,
          ),
        ),
      ),
    );
  }
}
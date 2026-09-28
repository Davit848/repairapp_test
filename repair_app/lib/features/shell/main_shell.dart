import 'package:flutter/material.dart';

import '../manage/manage_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';
import '../services/services_screen.dart';
import '../store/store_screen.dart';
import 'app_bottom_nav.dart';

enum AppTab {
  map('Map', Icons.explore_outlined),
  services('Services', Icons.home_repair_service_outlined),
  store('Store', Icons.shopping_bag_outlined),
  manage('Manage', Icons.build_outlined),
  profile('Profile', Icons.account_circle_outlined);

  const AppTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Persistent 5-tab navigation shell. Tabs keep their state while switching.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialTab = AppTab.map});

  final AppTab initialTab;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late AppTab _tab = widget.initialTab;

  void _select(AppTab tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab.index,
        children: [
          MapScreen(onViewShop: () => _select(AppTab.services)),
          const ServicesScreen(),
          const StoreScreen(),
          const ManageScreen(),
          ProfileScreen(onManageInventory: () => _select(AppTab.manage)),
        ],
      ),
      bottomNavigationBar: AppBottomNav(tabs: AppTab.values, selected: _tab, onSelected: _select),
    );
  }
}

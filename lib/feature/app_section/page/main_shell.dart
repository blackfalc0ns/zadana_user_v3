import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:zadana_user_v3/core/services/category_navigation_service.dart';
import 'package:zadana_user_v3/feature/app_section/widget/custom_bottom_nav_bar.dart';
import 'package:zadana_user_v3/feature/app_section/widget/tab_config_builder.dart';

final GlobalKey<MainShellState> mainShellKey = GlobalKey<MainShellState>();

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (_controller.index == 1) {
      Future.delayed(const Duration(milliseconds: 50), () {
        CategoryNavigationService().notifyTabChanged();
      });
    }
  }

  void jumpToTab(int index) {
    _controller.jumpToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: TabConfigBuilder.buildTabs(context),
      navBarBuilder: (navBarConfig) => CustomBottomNavBar(navBarConfig: navBarConfig),
    );
  }
}

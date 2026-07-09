import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'favorites_screen.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem(this.icon, this.selectedIcon, this.label);
}

const _navItems = [
  _NavItem(Icons.home_outlined, Icons.home, "Home"),
  _NavItem(Icons.favorite_border, Icons.favorite, "Favorites"),
  _NavItem(Icons.quiz_outlined, Icons.quiz, "Game"),
  _NavItem(Icons.person_outline, Icons.person, "Profile"),
];

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    FavoritesScreen(),
    GameScreen(),
    ProfileScreen(),
  ];

  void _select(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= Breakpoints.tablet;

        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: _select,
                  destinations: _navItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: pages[currentIndex]),
              ],
            ),
          );
        }

        return Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: _select,
            destinations: _navItems
                .map(
                  (item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: item.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

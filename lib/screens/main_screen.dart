import 'package:flutter/material.dart';
import 'package:foodball_app/const.dart';
import 'package:foodball_app/screens/home_screen.dart';
import 'package:foodball_app/screens/calender_screen.dart';
import 'package:foodball_app/screens/standing_screen.dart';
import 'package:foodball_app/screens/account_screen.dart';
import 'package:iconsax/iconsax.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const StandingScreen(),
    const AccountScreen(),
  ];
  final icons = [
    Iconsax.home,
    Iconsax.calendar_1,
    Iconsax.chart,
    Icons.person_outline,
  ];
  final titles = ["Home", "Calendar", "Standing", "Account"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.015),
              blurRadius: 8,
              spreadRadius: 5,
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            return MyBottomNavBarItem(
              title: titles[index],
              icon: icons[index],
              isActive: currentTab == index,
              onTab: () {
                setState(() {
                  currentTab = index;
                });
              },
            );
          }),
        ),
      ),
      body: screens[currentTab],
    );
  }
}

class MyBottomNavBarItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function() onTab;
  final IconData icon;
  const MyBottomNavBarItem({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTab,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? kprimarycolor : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.grey.shade400),
            if (isActive)
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}

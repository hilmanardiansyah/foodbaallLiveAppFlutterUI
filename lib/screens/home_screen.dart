// ...existing code...
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:foodball_app/const.dart';
import 'package:foodball_app/Model/live_match_model.dart';
import 'package:foodball_app/Model/up_coming_model.dart';
import 'package:foodball_app/screens/match_detail_screen.dart';
import 'package:foodball_app/Widgets/live_match.dart';
import 'package:foodball_app/Widgets/up_coming_match.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerParts(),
      body: Column(
        children: [
          liveMatchText(),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: liveMatches.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 20),
              itemBuilder: (context, index) {
                final live = liveMatches[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchDetailScreen(liveMatch: live),
                      ),
                    );
                  },
                  child: LiveMatchData(live: live),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Upcoming Matches",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.black54,
                    letterSpacing: -1.5,
                  ),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: kprimarycolor),
                  onPressed: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: upcomingMatches.length,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final upMatch = upcomingMatches[index];
                  return UpComingMatches(upMatch: upMatch);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding liveMatchText() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Text(
            "Live Matches",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.black54,
              letterSpacing: -1.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black12.withOpacity(0.08),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset("assets/football/p1.png", width: 30, height: 30),
                const SizedBox(width: 3),
                const Text(
                  "Premier League",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.keyboard_arrow_down_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar headerParts() {
    return AppBar(
      backgroundColor: Colors.white,
      actions: [
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            elevation: 0.2,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Iconsax.category),
            ),
          ),
        ),
        const Spacer(),
        const Row(
          children: [
            Text(
              "S",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                letterSpacing: -2,
              ),
            ),
            Icon(Icons.sports_soccer, color: kprimarycolor, size: 25),
            Text(
              "ccer",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: -2,
              ),
            ),
            Text(
              " Nerds",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: kprimarycolor,
                letterSpacing: -2,
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            elevation: 0.2,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: const Stack(
                children: [
                  Icon(Iconsax.notification),
                  Positioned(
                    right: 4,
                    top: 0,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: kprimarycolor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}

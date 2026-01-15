import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import 'package:foodball_app/const.dart';
import 'package:foodball_app/state/providers.dart';
import 'package:foodball_app/Widgets/live_match_api.dart';
import 'package:foodball_app/Widgets/upcoming_match_api.dart';
import 'package:foodball_app/screens/upcoming_all_screen.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(liveMatchesProvider);
    final upcomingAsync = ref.watch(upcomingMatchesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerParts(),
      body: Column(
        children: [
          liveMatchText(),

          // ======= LIVE (horizontal) =======
          SizedBox(
            height: 230,
            child: liveAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error live: $e")),
              data: (matches) {
                if (matches.isEmpty) {
                  return const Center(child: Text("No live matches right now"));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: matches.length,
                  padding: const EdgeInsets.only(left: 20),
                  itemBuilder: (context, index) {
                    final m = matches[index];
                    return LiveMatchCardApi(match: m);
                  },
                );
              },
            ),
          ),

          // ======= UPCOMING header =======
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
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
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UpcomingAllScreen()),
                  );
                },
                  child: const Text(
                    "See All",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // ======= UPCOMING (vertical) =======
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: upcomingAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error upcoming: $e")),
                data: (matches) => ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final m = matches[index];
                    return UpcomingMatchTileApi(match: m);
                  },
                ),
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
            Text("S", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, letterSpacing: -2)),
            Icon(Icons.sports_soccer, color: kprimarycolor, size: 25),
            Text("ccer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: -2)),
            Text(" Live", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: kprimarycolor, letterSpacing: -2)),
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
                    child: CircleAvatar(radius: 5, backgroundColor: kprimarycolor),
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

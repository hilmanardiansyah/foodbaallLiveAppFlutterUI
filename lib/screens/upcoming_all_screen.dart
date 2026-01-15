import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodball_app/state/providers.dart';
import 'package:foodball_app/widgets/upcoming_match_tile_api.dart';

class UpcomingAllScreen extends ConsumerWidget {
  const UpcomingAllScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingAsync = ref.watch(upcomingMatchesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Upcoming Matches",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.5,
            color: Colors.black,
          ),
        ),
      ),
      body: upcomingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (matches) {
          if (matches.isEmpty) {
            return const Center(child: Text("No upcoming matches"));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: matches.length,
            itemBuilder: (context, i) {
              final m = matches[i];
              return UpcomingMatchTileApi(match: m);
            },
          );
        },
      ),
    );
  }
}

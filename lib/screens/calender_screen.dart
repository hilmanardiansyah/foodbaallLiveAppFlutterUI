import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodball_app/state/providers.dart';
import 'package:foodball_app/const.dart';
import 'package:foodball_app/widgets/team_badge.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

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
          "Match Calendar",
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

          // group by date (yyyy-mm-dd)
          final Map<String, List<dynamic>> grouped = {};
          for (final m in matches) {
            final local = m.utcDate.toLocal();
            final key = DateFormat("yyyy-MM-dd").format(local);
            grouped.putIfAbsent(key, () => []).add(m);
          }

          // sort date keys
          final keys = grouped.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final list = grouped[key]!;
              final date = DateTime.parse(key);

              return _DaySection(
                date: date,
                matches: list,
              );
            },
          );
        },
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.date,
    required this.matches,
  });

  final DateTime date;
  final List matches;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);

    String title;
    if (d == today) {
      title = "Today";
    } else if (d == today.add(const Duration(days: 1))) {
      title = "Tomorrow";
    } else {
      title = DateFormat("EEE, dd MMM yyyy").format(date);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // date header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: kprimarycolor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${matches.length} matches",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kprimarycolor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // list matches
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final m = matches[i];

            final local = m.utcDate.toLocal();
            final time = DateFormat("HH:mm").format(local);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Home
                  TeamBadge(teamName: m.homeName, crestUrl: m.homeCrest, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      m.homeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),

                  // time + VS
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        "vs",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),

                  // Away
                  Expanded(
                    child: Text(
                      m.awayName,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TeamBadge(teamName: m.awayName, crestUrl: m.awayCrest, size: 28),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 18),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodball_app/const.dart';
import 'package:foodball_app/model/match_item.dart';
import 'package:foodball_app/state/providers.dart';
import 'package:foodball_app/widgets/team_badge.dart';
import 'package:intl/intl.dart';

class UpcomingMatchTileApi extends ConsumerWidget {
  const UpcomingMatchTileApi({super.key, required this.match});

  final MatchItem match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favState = ref.watch(favoritesProvider);
    final favCtrl = ref.read(favoritesProvider.notifier);

    // biar rebuild pasti pas data favorites berubah
    final isFav = favState.maybeWhen(
      data: (list) => list.any((x) => x.matchId == match.id),
      orElse: () => false,
    );

    final dt = match.utcDate.toLocal();
    final time = DateFormat("HH:mm").format(dt);
    final date = DateFormat("dd MMM").format(dt);

    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -5),
            color: isFav ? kprimarycolor : Colors.black12.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: Row(
        children: [
          // Home badge
          TeamBadge(teamName: match.homeName, crestUrl: match.homeCrest, size: 34),
          const SizedBox(width: 8),

          // Home name
          Expanded(
            child: Text(
              match.homeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.5,
                letterSpacing: -1,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // time + date
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  letterSpacing: -1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(date, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),

          const SizedBox(width: 10),

          // Away name + badge (anti overflow)
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      match.awayName,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        letterSpacing: -1,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TeamBadge(
                    teamName: match.awayName,
                    crestUrl: match.awayCrest,
                    size: 34,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ⭐ favorite toggle
          IconButton(
            onPressed: favState.isLoading
                ? null
                : () async {
                    await favCtrl.toggle(match);
                  },
            icon: Icon(
              Icons.star,
              color: isFav ? kprimarycolor : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}

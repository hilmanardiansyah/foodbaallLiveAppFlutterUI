import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodball_app/const.dart';
import 'package:foodball_app/model/match_item.dart';
import 'package:foodball_app/state/providers.dart';
import 'package:intl/intl.dart';
import 'package:foodball_app/widgets/team_badge.dart';

class UpcomingMatchTileApi extends ConsumerWidget {
  const UpcomingMatchTileApi({super.key, required this.match});

  final MatchItem match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favState = ref.watch(favoritesProvider);
    final favCtrl = ref.read(favoritesProvider.notifier);

    // ✅ hitung isFav dari data yang di-watch, biar rebuild pasti
    final isFav = favState.maybeWhen(
      data: (list) => list.any((x) => x.matchId == match.id),
      orElse: () => false,
    );

    final dt = match.utcDate.toLocal();
    final time = DateFormat("HH:mm").format(dt);
    final date = DateFormat("dd MMM").format(dt);

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -5),
            color: isFav ? kprimarycolor : Colors.black12.withOpacity(0.15),
          ),
        ],
      ),
      child: Row(
        children: [
          TeamBadge(
            teamName: match.homeName,
            crestUrl: match.homeCrest,
            size: 36,
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              match.homeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.5,
                letterSpacing: -1,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 18,
                  letterSpacing: -1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(date, style: const TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(width: 10),

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
              fontSize: 16.5,
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
          size: 36,
        ),
      ],
    ),
  ),
),

          const SizedBox(width: 8),

          // ⭐ Toggle Favorite (Create/Delete)
          IconButton(
            onPressed: favState.isLoading
                ? null
                : () async {
                    await favCtrl.toggle(match); // ✅
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

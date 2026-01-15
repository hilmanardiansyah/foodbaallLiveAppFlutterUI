import 'package:flutter/material.dart';
import 'package:foodball_app/const.dart';
import 'package:foodball_app/model/match_item.dart';
import 'package:intl/intl.dart';
import 'package:foodball_app/widgets/team_badge.dart';

class LiveMatchCardApi extends StatelessWidget {
  const LiveMatchCardApi({super.key, required this.match});

  final MatchItem match;

  @override
  Widget build(BuildContext context) {
    final dt = match.utcDate.toLocal();
    final timeText = DateFormat("dd MMM • HH:mm").format(dt);

    final homeScore = match.homeScore?.toString() ?? "-";
    final awayScore = match.awayScore?.toString() ?? "-";

    final isLive = match.status == "IN_PLAY";

    return Container(
      height: 230,
      width: 340,
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        children: [
          const Text(
            "Premier League",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          Text(
            isLive ? "LIVE" : timeText,
            style: TextStyle(
              color: isLive ? kprimarycolor : Colors.white70,
              letterSpacing: -1,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HOME
              Column(
                children: [
                  TeamBadge(
                    teamName: match.homeName,
                    crestUrl: match.homeCrest,
                    size: 70,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 110,
                    child: Text(
                      match.homeName.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const Text(
                    "Home",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),

              const Spacer(),

              // SCORE
              Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      match.status,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$homeScore : ",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: kprimarycolor,
                          ),
                        ),
                        TextSpan(
                          text: awayScore,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // AWAY
              Column(
                children: [
                  TeamBadge(
                    teamName: match.awayName,
                    crestUrl: match.awayCrest,
                    size: 70,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 110,
                    child: Text(
                      match.awayName.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const Text(
                    "Away",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

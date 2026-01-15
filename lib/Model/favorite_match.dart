import 'package:foodball_app/model/match_item.dart';

class FavoriteMatch {
  final int matchId;
  final String homeName;
  final String awayName;
  final String status;
  final DateTime utcDate;

  final String? homeCrest;
  final String? awayCrest;

  final int? homeScore;
  final int? awayScore;

  FavoriteMatch({
    required this.matchId,
    required this.homeName,
    required this.awayName,
    required this.status,
    required this.utcDate,
    this.homeCrest,
    this.awayCrest,
    this.homeScore,
    this.awayScore,
  });

  factory FavoriteMatch.fromMatchItem(MatchItem m) {
    return FavoriteMatch(
      matchId: m.id, 
      homeName: m.homeName,
      awayName: m.awayName,
      status: m.status,
      utcDate: m.utcDate,
      homeCrest: m.homeCrest,
      awayCrest: m.awayCrest,
      homeScore: m.homeScore,
      awayScore: m.awayScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'match_id': matchId,
      'home_name': homeName,
      'away_name': awayName,
      'status': status,
      'utc_date': utcDate.toIso8601String(),
      'home_crest': homeCrest,
      'away_crest': awayCrest,
      'home_score': homeScore,
      'away_score': awayScore,
    };
  }

  factory FavoriteMatch.fromMap(Map<String, dynamic> map) {
    return FavoriteMatch(
      matchId: map['match_id'] as int,
      homeName: (map['home_name'] as String?) ?? '-',
      awayName: (map['away_name'] as String?) ?? '-',
      status: (map['status'] as String?) ?? '-',
      utcDate: DateTime.parse(map['utc_date'] as String),
      homeCrest: map['home_crest'] as String?,
      awayCrest: map['away_crest'] as String?,
      homeScore: map['home_score'] as int?,
      awayScore: map['away_score'] as int?,
    );
  }
}

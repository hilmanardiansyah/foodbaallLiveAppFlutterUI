class MatchItem {
  final int id;
  final DateTime utcDate;
  final String status;
  final String homeName;
  final String awayName;
  final String? homeCrest;
  final String? awayCrest;
  final int? homeScore;
  final int? awayScore;

  MatchItem({
    required this.id,
    required this.utcDate,
    required this.status,
    required this.homeName,
    required this.awayName,
    this.homeCrest,
    this.awayCrest,
    this.homeScore,
    this.awayScore,
  });

  factory MatchItem.fromJson(Map<String, dynamic> json) {
    final homeTeam = json['homeTeam'] ?? {};
    final awayTeam = json['awayTeam'] ?? {};
    final score = json['score'] ?? {};
    final fullTime = score['fullTime'] ?? {};

    return MatchItem(
      id: json['id'] as int,
      utcDate: DateTime.parse(json['utcDate'] as String),
      status: (json['status'] as String?) ?? '-',
      homeName: (homeTeam['name'] as String?) ?? '-',
      awayName: (awayTeam['name'] as String?) ?? '-',
      homeCrest: homeTeam['crest'] as String?,
      awayCrest: awayTeam['crest'] as String?,
      homeScore: fullTime['home'] as int?,
      awayScore: fullTime['away'] as int?,
    );
  }
}

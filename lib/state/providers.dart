import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodball_app/const.dart';
import 'package:foodball_app/data/football_api.dart';
import 'package:foodball_app/model/match_item.dart';
import 'package:foodball_app/model/standing_row.dart';
import 'package:foodball_app/data/favorites_repository.dart';
import 'package:foodball_app/model/favorite_match.dart';



final footballApiProvider = Provider<FootballApi>((ref) {
  return FootballApi(token: footballDataToken);
});

// ===== MATCHES =====

// Live (kalau kosong tampil "No live matches")
final liveMatchesProvider = FutureProvider<List<MatchItem>>((ref) async {
  final api = ref.read(footballApiProvider);
  final raw = await api.getMatches(
    competitionCode: defaultCompetition,
    status: 'IN_PLAY',
    limit: 20,
  );
  return raw.map((e) => MatchItem.fromJson(e as Map<String, dynamic>)).toList();
});

// Upcoming (pasti ada)
final upcomingMatchesProvider = FutureProvider<List<MatchItem>>((ref) async {
  final api = ref.read(footballApiProvider);
  final raw = await api.getMatches(
    competitionCode: defaultCompetition,
    status: 'SCHEDULED',
    limit: 20,
  );
  return raw.map((e) => MatchItem.fromJson(e as Map<String, dynamic>)).toList();
});

// ===== STANDINGS =====
final standingsProvider = FutureProvider<List<StandingRow>>((ref) async {
  final api = ref.read(footballApiProvider);
  final data = await api.getStandings(competitionCode: defaultCompetition);

  final standingsList = (data['standings'] as List?) ?? [];

  Map<String, dynamic>? totalStanding;
  for (final s in standingsList) {
    final type = (s['type'] as String?) ?? '';
    if (type == 'TOTAL') {
      totalStanding = (s as Map<String, dynamic>);
      break;
    }
  }

  totalStanding ??=
      standingsList.isNotEmpty ? (standingsList.first as Map<String, dynamic>) : null;

  final table = (totalStanding?['table'] as List?) ?? [];

  return table
      .map((e) => StandingRow.fromJson(e as Map<String, dynamic>))
      .toList();
});


final favoritesRepoProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

final favoritesProvider =
    AsyncNotifierProvider<FavoritesController, List<FavoriteMatch>>(
  () => FavoritesController(),
);

class FavoritesController extends AsyncNotifier<List<FavoriteMatch>> {
  FavoritesRepository get _repo => ref.read(favoritesRepoProvider);

  @override
  Future<List<FavoriteMatch>> build() async {
    return _repo.getAll(); // otomatis load pertama kali
  }

  bool isFavorite(int matchId) {
    final list = state.maybeWhen(
  data: (v) => v,
  orElse: () => const <FavoriteMatch>[],
);

    return list.any((x) => x.matchId == matchId);
  }

  Future<void> toggle(MatchItem match) async {
    final id = match.id;

    if (isFavorite(id)) {
      await _repo.remove(id);
    } else {
      await _repo.add(FavoriteMatch.fromMatchItem(match));
    }

    // reload
    state = const AsyncLoading();
    state = AsyncData(await _repo.getAll());
  }

  Future<void> delete(int matchId) async {
    await _repo.remove(matchId);
    state = const AsyncLoading();
    state = AsyncData(await _repo.getAll());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodball_app/state/providers.dart';
import 'package:foodball_app/widgets/team_badge.dart';
import 'package:foodball_app/const.dart';

class StandingScreen extends ConsumerWidget {
  const StandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(standingsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "League Standing",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -0.5,
            color: Colors.black,
          ),
        ),
      ),
      body: standingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (rows) {
          if (rows.isEmpty) return const Center(child: Text("No standings data"));

          final relegationStart = rows.length - 3; // 3 terbawah

          return Column(
            children: [
              // header
              _headerRow(),
              const Divider(height: 1),

              // table body (scroll horizontal kalau perlu)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 540, // lebar tabel biar kolomnya nyaman
                    child: ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final r = rows[i];

                        final isTop4 = r.position <= 4;
                        final isRelegation = i >= relegationStart;

                        final bg = isTop4
                            ? kprimarycolor.withValues(alpha: 0.12)
                            : isRelegation
                                ? Colors.red.withValues(alpha: 0.08)
                                : Colors.transparent;

                        return Container(
                          color: bg,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              _posCell(r.position),
                              const SizedBox(width: 8),

                              TeamBadge(
                                teamName: r.teamName,
                                crestUrl: r.teamCrest,
                                size: 26,
                              ),
                              const SizedBox(width: 8),

                              _clubCell(r.teamName),

                              _numCell(r.playedGames),
                              _numCell(r.won),
                              _numCell(r.draw),
                              _numCell(r.lost),
                              _numCell(r.goalDifference),
                              _numCell(r.points, bold: true),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===== HEADER =====
  Widget _headerRow() {
    const h = TextStyle(
      fontSize: 12,
      color: Colors.grey,
      fontWeight: FontWeight.w800,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 540,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: const [
              SizedBox(width: 28, child: Text("#", style: h)),
              SizedBox(width: 8),
              SizedBox(width: 26),
              SizedBox(width: 8),
              SizedBox(width: 160, child: Text("Club", style: h)),
              SizedBox(width: 32, child: Text("P", textAlign: TextAlign.center, style: h)),
              SizedBox(width: 32, child: Text("W", textAlign: TextAlign.center, style: h)),
              SizedBox(width: 32, child: Text("D", textAlign: TextAlign.center, style: h)),
              SizedBox(width: 32, child: Text("L", textAlign: TextAlign.center, style: h)),
              SizedBox(width: 40, child: Text("GD", textAlign: TextAlign.center, style: h)),
              SizedBox(width: 40, child: Text("Pts", textAlign: TextAlign.center, style: h)),
            ],
          ),
        ),
      ),
    );
  }

  // ===== CELLS =====
  Widget _posCell(int pos) {
    return SizedBox(
      width: 28,
      child: Text(
        pos.toString(),
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _clubCell(String name) {
    return SizedBox(
      width: 160,
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _numCell(int v, {bool bold = false}) {
    // GD & Pts lebih lebar biar gak kepotong
    final w = (bold || v.abs() >= 100) ? 40.0 : 32.0;

    return SizedBox(
      width: w,
      child: Text(
        v.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
        ),
      ),
    );
  }
}

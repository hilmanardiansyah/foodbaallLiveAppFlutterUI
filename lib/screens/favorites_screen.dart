import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodball_app/state/providers.dart';
import 'package:intl/intl.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final favAsync = ref.watch(favoritesProvider);
  final favCtrl = ref.read(favoritesProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
        ),
      ),
      body: favAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Belum ada favorite"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 18),
            itemBuilder: (context, i) {
              final f = list[i];
              final dt = f.utcDate.toLocal();
              final timeText = DateFormat("dd MMM • HH:mm").format(dt);

           return Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.06),
        blurRadius: 10,
      ),
    ],
  ),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${f.homeName} vs ${f.awayName}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "${f.status} • $timeText",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),

      const SizedBox(width: 10),

      // tombol delete dengan area klik lebih besar (web aman)
      TextButton.icon(
        onPressed: () async {
          await favCtrl.delete(f.matchId);
        },
        icon: const Icon(Icons.delete_outline),
        label: const Text("Hapus"),
      ),
    ],
  ),
);

            },
          );
        },
      ),
    );
  }
}

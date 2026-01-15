import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodball_app/const.dart';

class TeamBadge extends StatelessWidget {
  const TeamBadge({
    super.key,
    required this.teamName,
    required this.crestUrl,
    this.size = 36,
  });

  final String teamName;
  final String? crestUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Web sering CORS untuk crest, jadi pakai inisial saja biar aman demo
    if (kIsWeb) return _initialBadge(teamName);

    final url = crestUrl?.trim();
    if (url == null || url.isEmpty) return _initialBadge(teamName);

    final lower = url.toLowerCase();

    Widget child;
    if (lower.endsWith('.svg')) {
      child = SvgPicture.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => _initialBadge(teamName),
      );
    } else {
      child = Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _initialBadge(teamName),
      );
    }

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _initialBadge(String name) {
    final initials = _initials(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kprimarycolor.withValues(alpha: 0.18),
        border: Border.all(color: kprimarycolor.withValues(alpha: 0.35)),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: Colors.black87,
        ),
      ),
    );
  }

  String _initials(String input) {
    final parts = input
        .replaceAll(RegExp(r'[^A-Za-z ]'), '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    if (parts.isEmpty) return "FC";
    if (parts.length == 1) {
      final w = parts.first.toUpperCase();
      return w.length >= 2 ? w.substring(0, 2) : w.substring(0, 1);
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

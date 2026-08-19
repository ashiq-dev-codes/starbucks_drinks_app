import 'package:flutter/material.dart';

/// Exact byte-for-byte values from the RN reference's `constants/Colors.ts`
/// (`black`/`lightText`) — kept separate from the app-wide `AppColors` palette
/// so this port can't silently drift from the source app's colors.
class DrinkColors {
  DrinkColors._();

  static const Color black = Color(0xFF090B0D);
  static const Color lightText = Color(0xFFBBBBBB);
}

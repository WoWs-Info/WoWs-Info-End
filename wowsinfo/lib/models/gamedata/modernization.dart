import 'package:flutter/foundation.dart';
import 'package:wowsinfo/models/gamedata/modifier.dart';

@immutable
class Modernization {
  const Modernization({
    required this.slot,
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.type,
    required this.nation,
    required this.modifiers,
    required this.ships,
    required this.excludes,
  });

  final int slot;
  final int id;
  final String name;
  final String description;
  final List<int>? level;
  final List<String>? type;
  final List<String>? nation;
  final ModernizationModifiers modifiers;
  final List<int>? ships;
  final List<int>? excludes;

  bool get isUnique => ships != null && ships!.length == 1;

  factory Modernization.fromJson(Map<String, dynamic> json) => Modernization(
        slot: json['slot'],
        id: json['id'],
        name: json['name'],
        description: json['description'],
        level: json['level'] == null
            ? null
            : List<int>.from(json['level'].map((x) => x)),
        type: json['type'] == null
            ? null
            : List<String>.from(json['type'].map((x) => x)),
        nation: json['nation'] == null
            ? null
            : List<String>.from(json['nation'].map((x) => x)),
        modifiers: ModernizationModifiers.fromJson(json['modifiers']),
        ships: json['ships'] == null
            ? null
            : List<int>.from(json['ships'].map((x) => x)),
        excludes: json['excludes'] == null
            ? null
            : List<int>.from(json['excludes'].map((x) => x)),
      );
}

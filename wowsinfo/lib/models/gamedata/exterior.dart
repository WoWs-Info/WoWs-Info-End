import 'package:flutter/foundation.dart';

import 'modifier.dart';

typedef Camouflage = Exterior;
typedef Flag = Exterior;

@immutable
class Exterior {
  const Exterior({
    required this.id,
    required this.name,
    required this.icon,
    this.description,
    this.costGold,
    this.costCR,
    this.modifiers,
    required this.type,
  });

  final int id;
  final String name;
  final String icon;
  final String? description;
  final int? costGold;
  final int? costCR;
  final Modifiers? modifiers;
  final String type;

  factory Exterior.fromJson(Map<String, dynamic> json) => Exterior(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        description: json['description'],
        costGold: json['costGold'],
        costCR: json['costCR'],
        modifiers: json['modifiers'] == null
            ? null
            : Modifiers.fromJson(json['modifiers']),
        type: json['type'],
      );
}
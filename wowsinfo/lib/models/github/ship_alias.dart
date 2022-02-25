import 'dart:convert';

import 'package:wowsinfo/models/Cacheable.dart';

/// This is the `ShipAlias` class
class ShipAlias implements Cacheable {
  Map<String, Alias> alias;
  bool hasAlias(String id) => this.alias.containsKey(id);

  /// Call `hasAlias` to check if id exists first
  String getAlisa(String id) => alias[id].name;

  ShipAlias.fromJson(Map<String, dynamic> json) {
    this.alias =
        (json['alias'] as Map).map((a, b) => MapEntry(a, Alias.fromJson(b)));
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': this.alias.cast<String, dynamic>(),
    };
  }

  @override
  bool isValid() => alias.isNotEmpty;

  @override
  output() => jsonEncode(toJson());
}

/// This is the `Alias` class
class Alias {
  String name;

  Alias.fromJson(Map<String, dynamic> json) {
    this.name = json['alias'];
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': this.name,
    };
  }
}

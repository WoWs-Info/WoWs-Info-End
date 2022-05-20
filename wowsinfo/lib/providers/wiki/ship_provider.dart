import 'package:flutter/material.dart';
import 'package:wowsinfo/models/gamedata/ship.dart';
import 'package:wowsinfo/models/wowsinfo/ship_filter.dart';
import 'package:wowsinfo/repositories/game_repository.dart';
import 'package:wowsinfo/widgets/shared/filter_ship_dialog.dart';

/// Provides the entire ship list and filter it with the given [ShipFilter]
class ShipProvider with ChangeNotifier {
  final BuildContext _context;
  ShipProvider(this._context);

  final _ships = GameRepository.instance.shipList;
  List<Ship>? _filteredShips;

  List<Ship> get shipList => _filteredShips ?? _ships;
  int get shipCount => shipList.length;
  String get filterString => '-  $shipCount';

  final defaultImage = 'gamedata/app/assets/ships/_default.png';

  void resetFilter() {
    _filteredShips = null;
    notifyListeners();
  }

  void showFilter() {
    showFilterShipDialog(_context, (filter) {
      _filteredShips =
          _ships.where((ship) => filter.shouldDisplay(ship)).toList();
      notifyListeners();
    });
  }
}

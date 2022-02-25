import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wowsinfo/providers/CachedData.dart';
import 'package:wowsinfo/models/GitHub/PRData.dart';
import 'package:wowsinfo/models/WoWs/PvP.dart';
import 'package:wowsinfo/services/locale/AppLocalizationService.dart';
import 'package:wowsinfo/ui/widgets/common/TextWithCaption.dart';
import 'package:wowsinfo/extensions/NumberExtension.dart';

/// ShipAverageStatistics class, it shows ship average myStats and compare it to your myStats if provided
class ShipAverageStatistics extends StatelessWidget {
  final int shipId;
  final PvP myShip;
  ShipAverageStatistics({Key key, @required this.shipId, this.myShip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cached = Provider.of<CachedData>(context, listen: false);
    final ship = cached.getShipStats(shipId.toString());
    final lang = AppLocalizationService.of(context);
    if (ship == null) return SizedBox.shrink();
    // Make sure there is at least 1 battle, no battle no stats
    if (myShip != null && myShip.battle > 0) return buildComparison(lang, ship);
    return buildNormal(lang, ship);
  }

  /// When my ship is null
  Row buildNormal(AppLocalizationService lang, AverageStats ship) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextWithCaption(
          title: lang.localised('warship_avg_damage'),
          value: ship.averageDamageString,
        ),
        TextWithCaption(
          title: lang.localised('warship_avg_winrate'),
          value: ship.winRateString,
        ),
        TextWithCaption(
          title: lang.localised('warship_avg_frag'),
          value: ship.averageFragString,
        ),
      ],
    );
  }

  /// Only inside ship detail page
  Row buildComparison(AppLocalizationService lang, AverageStats ship) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextWithCaption(
          title: lang.localised('warship_avg_damage'),
          valueWidget: buildStatistics(
              ship.averageDamageString,
              myShip.avgDamage,
              ship.averageDamageDealt,
              (d) => d.myFixedString(0)),
        ),
        TextWithCaption(
          title: lang.localised('warship_avg_winrate'),
          valueWidget: buildStatistics(ship.winRateString, myShip.winrate,
              ship.winRate, (d) => d.myFixedString(1) + '%'),
        ),
        TextWithCaption(
          title: lang.localised('warship_avg_frag'),
          valueWidget: buildStatistics(ship.averageFragString, myShip.avgFrag,
              ship.averageFrag, (d) => d.myFixedString(2)),
        ),
      ],
    );
  }

  /// basically a wrapper around diff text
  Widget buildStatistics(String first, double mine, double expected,
      String Function(double) formatter) {
    return buildDiffText(mine - expected, formatter);
  }

  Widget buildDiffText(double value, String Function(double) formatter) {
    if (value > 0) {
      return Text('+' + formatter(value),
          style: TextStyle(color: Colors.green));
    } else if (value < 0) {
      return Text(formatter(value), style: TextStyle(color: Colors.red));
    } else {
      return Text(formatter(value));
    }
  }
}

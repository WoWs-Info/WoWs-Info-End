import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wowsinfo/providers/CachedData.dart';
import 'package:wowsinfo/models/Wiki/WikiAchievement.dart';
import 'package:wowsinfo/models/WoWs/PlayerAchievement.dart';
import 'package:wowsinfo/utils/Utils.dart';
import 'package:wowsinfo/ui/widgets/wiki/WikiItemCell.dart';

/// WikiAchievementPage class
class WikiAchievementPage extends StatelessWidget {
  /// Optional player field
  final PlayerAchievement player;
  WikiAchievementPage({Key key, this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 100 can place 4 on iPhone 11
    final itemCount = Utils.of(context).getItemCount(8, 2, 100);

    return Scaffold(
      appBar: AppBar(title: Text('WikiAchievementPage')),
      body: SafeArea(
        child: Scrollbar(
          child: buildGridView(context, itemCount),
        ),
      ),
    );
  }

  GridView buildGridView(BuildContext context, int itemCount) {
    final cached = Provider.of<CachedData>(context, listen: false);

    if (player == null) {
      final achievment = cached.sortedAchievement.toList(growable: false);
      // Display everything
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: itemCount,
            childAspectRatio: 1.0,
          ),
          itemCount: achievment.length,
          itemBuilder: (context, index) {
            final curr = achievment[index];
            return WikiItemCell(
              item: curr,
              onTap: () => curr.displayDialog(context),
            );
          });
    } else {
      // Sort player achievment by count
      final sorted = player.sorted.toList(growable: false);

      // Display whatever player has
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemCount,
          childAspectRatio: 0.96,
        ),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final key = sorted[index].key;
          final count = sorted[index].value;
          final curr = cached.getAchievement(key);
          return InkWell(
            onTap: () => curr.displayDialog(context),
            child: Tooltip(
                message: curr.name,
                child: FittedBox(child: buildPlayer(curr, count))),
          );
        },
      );
    }
  }

  Widget buildPlayer(Achievement curr, int count) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4),
          child: Image.network(curr.image),
        ),
        Text(count.toString()),
      ],
    );
  }
}

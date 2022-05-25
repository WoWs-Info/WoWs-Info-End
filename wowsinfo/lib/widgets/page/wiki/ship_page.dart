import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wowsinfo/foundation/app.dart';
import 'package:wowsinfo/foundation/helpers/utils.dart';
import 'package:wowsinfo/models/gamedata/ship.dart';
import 'package:wowsinfo/providers/wiki/ship_provider.dart';
import 'package:wowsinfo/repositories/game_repository.dart';
import 'package:wowsinfo/widgets/shared/wiki/ship_icon.dart';

import 'ship_info_page.dart';

class ShipPage extends StatefulWidget {
  const ShipPage({Key? key}) : super(key: key);

  @override
  State<ShipPage> createState() => _ShipPageState();
}

class _ShipPageState extends State<ShipPage> {
  late final _provider = ShipProvider(context);

  @override
  Widget build(BuildContext context) {
    final itemCount = Utils.of(context).getItemCount(8, 2, 150);
    return ChangeNotifierProvider.value(
      value: _provider,
      builder: (context, widget) => Scaffold(
        appBar: AppBar(
          title: const Text('Upgrade Page'),
        ),
        body: SafeArea(
          child: Scrollbar(
            child: buildGridView(itemCount),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _provider.showFilter(),
          icon: const Icon(Icons.filter_alt),
          label: Consumer<ShipProvider>(
            builder: (context, provider, child) => Text(
              provider.filterString,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget buildGridView(int itemCount) {
    // Display everything
    return Consumer<ShipProvider>(
      builder: (context, provider, child) => GridView.builder(
        padding: const EdgeInsets.only(bottom: 64),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: itemCount,
          childAspectRatio: 1.0,
        ),
        itemCount: provider.shipCount,
        itemBuilder: (context, index) {
          final curr = provider.shipList[index];
          final imageName = curr.index;
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                App.platformPageRoute(
                  builder: (_) => ShipInfoPage(ship: curr),
                ),
              );
            },
            child: FittedBox(
              child: Column(
                children: [
                  ShipIcon(name: imageName),
                  Text(
                    '${curr.tierString} ${GameRepository.instance.stringOf(curr.name) ?? ''}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

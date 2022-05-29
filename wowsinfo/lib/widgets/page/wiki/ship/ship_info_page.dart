import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wowsinfo/models/gamedata/ship.dart';
import 'package:wowsinfo/models/wowsinfo/ship_module_selection.dart';
import 'package:wowsinfo/models/wowsinfo/ship_modules.dart';
import 'package:wowsinfo/providers/wiki/ship_info_provider.dart';
import 'package:wowsinfo/repositories/localisation.dart';
import 'package:wowsinfo/widgets/page/wiki/ship/ship_module_dialog.dart';
import 'package:wowsinfo/widgets/shared/text_with_caption.dart';
import 'package:wowsinfo/widgets/shared/wiki/ship_icon.dart';

late final _logger = Logger('ShipInfoPage');

class ShipInfoPage extends StatefulWidget {
  const ShipInfoPage({
    Key? key,
    required this.ship,
  }) : super(key: key);

  final Ship ship;

  @override
  State<ShipInfoPage> createState() => _ShipInfoPageState();
}

class _ShipInfoPageState extends State<ShipInfoPage> {
  late final ShipInfoProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ShipInfoProvider(context, widget.ship);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(_provider.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ShipTitleSection(
                icon: _provider.shipIcon,
                name: _provider.shipName,
                region: _provider.region,
                type: _provider.type,
                costCR: _provider.costCR,
                costGold: _provider.costGold,
                description: _provider.description,
              ),
              if (_provider.canChangeModules)
                Consumer<ShipInfoProvider>(
                  builder: (context, value, child) => _ShipModuleButton(
                    title: 'Change Ship Modules',
                    shipModules: value.moduleList,
                    selection: value.selection,
                  ),
                ),
              if (_provider.renderHull)
                _ShipSurvivabilty(
                  health: _provider.health,
                  protection: _provider.torpedoProtection,
                ),
              if (_provider.renderMainGun) Container(),
              if (_provider.renderTorpedo) Text(_provider.torpedoName),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShipTitleSection extends StatelessWidget {
  const _ShipTitleSection({
    Key? key,
    required this.icon,
    required this.name,
    required this.region,
    required this.type,
    this.costCR,
    this.costGold,
    required this.description,
  }) : super(key: key);

  final String icon;
  final String name;
  final String region;
  final String type;
  final String? costCR;
  final String? costGold;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ShipIcon(
              name: icon,
              height: 128,
            ),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(region),
            ),
            Text(type),
            if (costCR != null) Text(costCR!),
            if (costGold != null) Text(costGold!),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShipModuleButton extends StatelessWidget {
  const _ShipModuleButton({
    Key? key,
    required this.title,
    required this.shipModules,
    required this.selection,
  }) : super(key: key);

  final String title;
  final ShipModuleMap shipModules;
  final ShipModuleSelection selection;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShipInfoProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        child: Text(title),
        onPressed: () => showShipModuleDialog(
          context,
          shipModules,
          selection,
          (selection) => provider.updateSelection(selection),
        ),
      ),
    );
  }
}

class _ShipSurvivabilty extends StatelessWidget {
  const _ShipSurvivabilty({
    Key? key,
    required this.health,
    required this.protection,
  }) : super(key: key);

  final String health;
  final String protection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            Localisation.instance.durability,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextWithCaption(
                title: Localisation.instance.health,
                value: health,
              ),
              TextWithCaption(
                title: Localisation.instance.torpedoProtection,
                value: protection,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShipMainBettery extends StatelessWidget {
  const _ShipMainBettery({
    Key? key,
    required this.reload,
    required this.range,
    required this.config,
    required this.dispersion,
    required this.rotation,
    required this.gunName,
  }) : super(key: key);

  final String reload;
  final String range;
  final String config;
  final String dispersion;
  final String rotation;

  final String gunName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Main Battery',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}

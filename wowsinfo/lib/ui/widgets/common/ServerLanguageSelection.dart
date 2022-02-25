import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wowsinfo/providers/CachedData.dart';
import 'package:wowsinfo/providers/Preference.dart';
import 'package:wowsinfo/services/locale/AppLocalizationService.dart';
import 'package:wowsinfo/ui/widgets/common/FlatFilterChip.dart';
import 'package:wowsinfo/ui/widgets/common/WrapBox.dart';

/// ServerLanguageSelection class
class ServerLanguageSelection extends StatefulWidget {
  ServerLanguageSelection({Key key}) : super(key: key);

  @override
  _ServerLanguageSelectionState createState() =>
      _ServerLanguageSelectionState();
}

class _ServerLanguageSelectionState extends State<ServerLanguageSelection> {
  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizationService.of(context);
    final cached = Provider.of<CachedData>(context, listen: false);

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              lang.localised('server_language_selection_title'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          WrapBox(
            spacing: 2,
            children: cached.serverLanguage.entries.map((e) {
              return Consumer<Preference>(
                builder: (context, pref, child) => FlatFilterChip(
                    label: Text(e.value),
                    selected: e.key == pref.serverLanguage,
                    onSelected: (_) {
                      setState(() {});
                      pref.serverLanguage = e.key;
                    }),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

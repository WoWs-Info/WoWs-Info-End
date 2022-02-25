import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wowsinfo/providers/CachedData.dart';

/// WikiGameMapPage class
class WikiGameMapPage extends StatelessWidget {
  WikiGameMapPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cached = Provider.of<CachedData>(context, listen: false);
    final maps = cached.gameMap.toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text('WikiGameMapPage')),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: maps.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(maps[index].name, textAlign: TextAlign.center),
            subtitle:
                Text(maps[index].description, textAlign: TextAlign.center),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => Theme(
                  data: ThemeData.dark(),
                  child: AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: Image.network(
                      maps[index].icon,
                      fit: BoxFit.fill,
                    ),
                    actions: [
                      FlatButton(
                          child: Text('Close'),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wowsinfo/foundation/app.dart';
import 'package:wowsinfo/foundation/helpers/utils.dart';
import 'package:wowsinfo/localisation/localisation.dart';
import 'package:wowsinfo/providers/app_provider.dart';
import 'package:wowsinfo/providers/settings_provider.dart';
import 'package:wowsinfo/repositories/user_repository.dart';
import 'package:wowsinfo/widgets/shared/max_width_box.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  late final _settings = SettingsProvider(context);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _settings,
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(Localisation.of(context).app_name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<SettingsProvider>(
                builder: (context, settings, child) => _DropdownListTile(
                  options: settings.servers,
                  title: Text(Localisation.of(context).setting_game_server),
                  value: settings.serverValue,
                  onChanged: (value) => settings.updateServer(value as int),
                ),
              ),
              const Divider(),
              Consumer<AppProvider>(
                builder: (context, app, child) => Column(
                  children: [
                    CheckboxListTile(
                      title: Text(
                        Localisation.of(context).settings_app_dark_mode,
                      ),
                      value: app.darkMode,
                      onChanged: (checked) {
                        if (checked == null) return;
                        app.updateDarkMode(checked);
                      },
                    ),
                    ListTile(
                      title: Text(
                        Localisation.of(context).settings_app_theme_colour,
                      ),
                      trailing: SizedBox(
                        height: 36,
                        width: 36,
                        // a coloured circle
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: app.themeColour,
                          ),
                        ),
                      ),
                      onTap: () => showThemeColours(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  Localisation.of(context).settings_app_send_feedback,
                ),
                subtitle: Text(
                  Localisation.of(context).settings_app_send_feedback_subtitle,
                ),
                onTap: () => App.launch(App.emailToLink),
              ),
              ListTile(
                title: Text(
                  Localisation.of(context).settings_app_report_issues,
                ),
                subtitle: const Text(App.newIssueLink),
                onTap: () => App.launch(App.newIssueLink),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  Localisation.of(context).settings_open_source_github,
                ),
                subtitle: const Text(App.githubLink),
                onTap: () => App.launch(App.githubLink),
              ),
              ListTile(
                title: Text(
                  Localisation.of(context).settings_open_source_licence,
                ),
                onTap: () {
                  showAboutDialog(context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showThemeColours() {
    final provider = Provider.of<AppProvider>(context, listen: false);

    final colours = _settings.colours;
    final count = Utils(context).getItemCount(4, 2, 300);

    // show all colours in a grid
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: MaxWidthBox(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: count,
            children: colours
                .map(
                  (e) => InkWell(
                    child: Container(color: e),
                    onTap: () {
                      provider.updateThemeColour(e);
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}

class DropdownValue<T> {
  const DropdownValue({
    required this.value,
    required this.title,
  });

  final String title;
  final T value;
}

/// A customised [ListTile] that displays a dropdown menu in the subtitle.
class _DropdownListTile<T> extends StatelessWidget {
  const _DropdownListTile({
    Key? key,
    required this.options,
    required this.value,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final List<DropdownValue<T>> options;
  final T value;
  final Widget title;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    GlobalKey? dropdownButtonKey = GlobalKey();

    void openDropdown() {
      GestureDetector? detector;

      /// Find the button that opens the dropdown
      void searchForGestureDetector(BuildContext? element) {
        element?.visitChildElements((element) {
          if (element.widget is GestureDetector) {
            detector = element.widget as GestureDetector?;
          } else {
            searchForGestureDetector(element);
          }
        });
      }

      searchForGestureDetector(dropdownButtonKey.currentContext);
      assert(detector != null, 'Dropdown button not found');

      detector?.onTap?.call();
    }

    // PopupMenuButton should be used instead
    return ListTile(
      onTap: () => openDropdown(),
      title: title,
      subtitle: AbsorbPointer(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            key: dropdownButtonKey,
            isExpanded: true,
            isDense: true, // shrink the dropdown button
            focusColor: Colors.transparent, // hides the focus within dropdown
            value: value,
            items: options
                .map((e) =>
                    DropdownMenuItem<T>(value: e.value, child: Text(e.title)))
                .toList(growable: false),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
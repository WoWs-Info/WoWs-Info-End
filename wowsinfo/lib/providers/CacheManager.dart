import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:wowsinfo/providers/Preference.dart';
import 'package:wowsinfo/models/Cacheable.dart';
import 'package:wowsinfo/models/Clan/ClanGlossary.dart';
import 'package:wowsinfo/models/GitHub/PRData.dart';
import 'package:wowsinfo/models/github/github_plugins.dart';
import 'package:wowsinfo/models/GitHub/ShipAlias.dart';
import 'package:wowsinfo/models/Wiki/WikiAchievement.dart';
import 'package:wowsinfo/models/Wiki/WikiCollection.dart';
import 'package:wowsinfo/models/Wiki/WikiCollectionItem.dart';
import 'package:wowsinfo/models/Wiki/WikiCommanderSkill.dart';
import 'package:wowsinfo/models/Wiki/WikiConsumable.dart';
import 'package:wowsinfo/models/Wiki/WikiEncyclopedia.dart';
import 'package:wowsinfo/models/Wiki/WikiGameMap.dart';
import 'package:wowsinfo/models/Wiki/WikiWarship.dart';
import 'package:wowsinfo/extensions/DateTimeExtension.dart';
import 'package:wowsinfo/utils/Utils.dart';

/// It handles cached data but mainly wiki
/// - it is usually read only
/// - it only updates when necessary
class CacheManager {

  static const BOX_NAME = 'cached_data';

  static const PERSONAL_RATING = 'personal_rating';
  static const SHIP_ALIAS = 'ship_alias';

  static const CLAN_GLOSSARY = 'clan_glossary';
  static const WIKI_ACHIEVEMENT = 'ship_achievement';
  static const WIKI_COLLECTION = 'wiki_collection';
  static const WIKI_COLLECTION_ITEM = 'wiki_collection_item';
  static const WIKI_COMMANDER_SKILL = 'wiki_commander_skill';
  static const WIKI_CONSUMABLE = 'wiki_consumable';
  static const WIKI_ENCYCLOPEDIA = 'wiki_encyclopedia';
  static const WIKI_GAME_MAP = 'wiki_game_map';
  static const WIKI_WARSHIP = 'wiki_warship';
  static const GITHUB_PLUGIN = 'github_plugin';

  ///
  /// Variables
  ///
  
  PRData _prData;
  final Preference pref;

  AverageStats getShipStats(String shipId) => _prData.ships[shipId];
  void loadPRData() => _prData = decode(PERSONAL_RATING, (j) => PRData.fromJson(j));
  void savePRData(PRData data) {
    _prData = data;
    box.put(PERSONAL_RATING, jsonEncode(data.toJson()));
  }

  ClanGlossary _clanGlossary;
  String getClanRoleName(String role) => _clanGlossary.roles[role];
  void loadClanGlossary() => _clanGlossary = decode(CLAN_GLOSSARY, (j) => ClanGlossary.fromJson(j));
  void saveClanGlossary(ClanGlossary data) {
    _clanGlossary = data;
    box.put(CLAN_GLOSSARY, jsonEncode(data.toJson()));
  }

  ShipAlias _alias;
  void loadAlias() => _alias = decode(SHIP_ALIAS, (j) => ShipAlias.fromJson(j));
  void saveAlias(ShipAlias data) {
    _alias = data;
    box.put(SHIP_ALIAS, jsonEncode(data.toJson()));
  }

  WikiAchievement _achievement;
  Iterable<Achievement> get achievement => _achievement.achievement.values;
  Iterable<Achievement> get sortedAchievement => achievement.toList(growable: false)
    ..sort((a, b) {
      if (a.hidden == b.hidden) return a.achievementId.compareTo(b.achievementId);
      return a.hidden - b.hidden;
    });
  Achievement getAchievement(String key) => _achievement.achievement[key];
  void loadAchievement() => _achievement = decode(WIKI_ACHIEVEMENT, (j) => WikiAchievement.fromJson(j));
  void saveAchievement(WikiAchievement data) {
    _achievement = data;
    box.put(WIKI_ACHIEVEMENT, jsonEncode(data.toJson()));
  }

  WikiWarship _warship;
  Map<String, Warship> get warship => _warship.ships;
  Warship getShip(int key) => warship[key.toString()] ?? _plugin.getShip(key);
  /// Sort by tier, then by type, ignore ships starts with `[`
  List<Warship> get sortedWarshipList {
    return warship.values.where((e) => !e.name.startsWith('[')).toList(growable: false)..sort((b, a) {
      // `a` first then 'd', smaller ones first
      if (a.tier == b.tier) return b.type.compareTo(a.type);
      // 10 first, larger ones first
      return a.tier - b.tier;
    });
  }
  void loadWarship() => _warship = decode(WIKI_WARSHIP, (j) => WikiWarship.fromJson(j, alias: _alias));
  void saveWarship(WikiWarship data) {
    _warship = data;
    box.put(WIKI_WARSHIP, jsonEncode(data.toJson()));
  }

  WikiCollection _collection;
  Iterable<Collection> get wikiCollections => _collection.collection.values;
  Iterable<Collection> get sortedWikiCollections => wikiCollections
    .toList(growable: false)..sort((a, b) => a.collectionId.compareTo(b.collectionId));
  void loadCollection() => _collection = decode(WIKI_COLLECTION, (j) => WikiCollection.fromJson(j));
  void saveCollection(WikiCollection data) {
    _collection = data;
    box.put(WIKI_COLLECTION, jsonEncode(data.toJson()));
  }

  WikiCollectionItem _collectionItem;
  void loadCollectionItem() => _collectionItem = decode(WIKI_COLLECTION_ITEM, (j) => WikiCollectionItem.fromJson(j));
  void saveCollectionItem(WikiCollectionItem data) {
    _collectionItem = data;
    box.put(WIKI_COLLECTION_ITEM, jsonEncode(data.toJson()));
  }

  WikiCommanderSkill _commanderSkill;
  Iterable<Skill> get commanderSkill => _commanderSkill.skill.values;
  Iterable<Skill> get sortedCommanderSkill => commanderSkill
    .toList(growable: false)..sort((a, b) {
      if (a.tier == b.tier) return a.typeId - b.typeId;
      return a.tier - b.tier;
    });
  void loadCommanderSkill() => _commanderSkill = decode(WIKI_COMMANDER_SKILL, (j) => WikiCommanderSkill.fromJson(j));
  void saveCommanderSkill(WikiCommanderSkill data) {
    _commanderSkill = data;
    box.put(WIKI_COMMANDER_SKILL, jsonEncode(data.toJson()));
  }

  WikiGameMap _gameMap;
  Iterable<GameMap> get gameMap => _gameMap.gameMap.values;
  void loadGameMap() => _gameMap = decode(WIKI_GAME_MAP, (j) => WikiGameMap.fromJson(j));
  void saveGameMap(WikiGameMap data) {
    _gameMap = data;
    box.put(WIKI_GAME_MAP, jsonEncode(data.toJson()));
  }

  WikiConsumable _consumable;
  Consumable getConsumable(int id) => getConsumableByString(id.toString());
  Consumable getConsumableByString(String id) => _consumable.consumable[id];
  Iterable<Consumable> get wikiConsumables => _consumable.consumable.values;
  Iterable<Consumable> get sortedWikiConsumables => wikiConsumables
    .toList(growable: false)..sort((a, b) {
      if (a.type == b.type) {
        if (a.priceGold == b.priceGold) return a.priceCredit - b.priceCredit;
        return a.priceGold - b.priceGold;
      }
      return a.type.compareTo(b.type);
    });
  void loadConsumable() => _consumable = decode(WIKI_CONSUMABLE, (j) => WikiConsumable.fromJson(j));
  void saveConsumable(WikiConsumable data) {
    _consumable = data;
    box.put(WIKI_CONSUMABLE, jsonEncode(data.toJson()));
  }

  WikiEncyclopedia _encyclopedia;
  /// A map with language code and its value
  Map<String, String> get serverLanguage => _encyclopedia.language;
  Map<String, String> get shipNation => _encyclopedia.shipNation;
  Iterable<String> get sortedNationKeys => shipNation.keys.toList(growable: false)..sort();
  Map<String, String> get shipType => _encyclopedia.shipType;
  Iterable<String> get sortedTypeKeys => shipType.keys.toList(growable: false)..sort();
  ShipModule get shipModule => _encyclopedia.shipModule;
  String get gameVersion => _encyclopedia.gameVersion;
  String getNationString(String code) => shipNation[code];
  String getTypeString(String code) => shipType[code];
  void loadEncyclopedia() => _encyclopedia = decode(WIKI_ENCYCLOPEDIA, (j) => WikiEncyclopedia.fromJson(j));
  void saveEncyclopedia(WikiEncyclopedia data) {
    _encyclopedia = data;
    box.put(WIKI_ENCYCLOPEDIA, jsonEncode(data.toJson()));
  }

  Plugin _plugin;
  Iterable<MapEntry<String, Modernization>> get getUpgradeList => _plugin.upgrade.entries;
  ShipWiki getExtraShipWiki(String key) => _plugin.shipWiki[key];
  ShipConsumableData getShipConsumable(ShipConsumableValue value) => _plugin.getConsumable(value);
  void loadPlugin() => _plugin = decode(GITHUB_PLUGIN, (j) => Plugin.fromJson(j));
  void savePlugin(Plugin data) {
    _plugin = data;
    box.put(GITHUB_PLUGIN, jsonEncode(data.toJson()));
  }

  ///
  /// Functions
  ///

  CachedData(this.pref);

  @override
  Future<bool> init() async {
    this.box = await Hive.openBox(BOX_NAME);
    Utils.debugPrint('$BOX_NAME box has been loaded');

    // Debug and close
    debug(keysOnly: true);
    return true;
  }

  /// Check for update and only update when game updates, app updates or it has been a week
  Future<bool> update({bool force = false}) async {
    // Open the box again if it is closed
    this.box = await Hive.openBox(BOX_NAME);
    // Load everything from storage, it is fine because if there are new data, it will be replaced
    loadAll();

    final server = pref.gameServer;
    final parser = WikiEncyclopediaGetter(server);
    final encyclopedia = parser.parse(await parser.download());

    // Either game updates, app updates or the data is too old
    if (force
      || (encyclopedia != null && encyclopedia.gameVersion != this.gameVersion)
      || pref.appVersion != AppAppConstant.APP_VERSION
      || pref.lastUpdate.dayDifference(DateTime.now()) > 10) {
      // Update data here
      List<APIParser> wows = [
        WikiAchievementGetter(server),
        WikiCollectionGetter(server),
        WikiCollectionItemGetter(server),
        WikiCommanderSkillGetter(server),
        WikiConsumableGetter(server),
        // Encyclopedia will also be updated
        // WikiEncyclopediaGetter(server),
        WikiGameMapGetter(server),
        WikiWarshipGetter(server),
        ClanGlossaryGetter(server),
      ];
      // Extra data from GitHub
      List<GitHubParser> github = [
        ShipAliasGetter(),
        PRDataGetter(),
        PluginGetter(),
      ];

      // Download from WarGaming API
      await Future.wait(wows.map((element) async {
        Cacheable data = element.parse(await element.download());
        data?.save();
      }));

      // Download from GitHub
      await Future.wait(github.map((element) async {
        Cacheable data = element.parse(await element.download());
        data?.save();
      }));

      // Only save new version here
      encyclopedia.save();
      // Attach alisa to wiki warship
      _warship.injectAlias(_alias);
      return true;
    }

    // Close the box after everything has been loadded
    return false;
  }

  /// Load all cached data into memory
  /// TODO: this can be optimised like when load when necessary
  void loadAll() {
    loadAchievement();
    loadAlias();
    loadClanGlossary();
    loadCollection();
    loadCollectionItem();
    loadConsumable();
    loadEncyclopedia();
    loadGameMap();
    loadPRData();
    loadWarship();
    loadPlugin();
    loadCommanderSkill();
  }

  /// Shorten decode process and extra check
  dynamic decode(String key, Function f) {
    final saved = box.get(key);
    if (saved == null) return null;
    return f(jsonDecode(saved));
  }

  @override
  Future close() async {
    // Clean up this box because it has quite a lot of data
    await box.compact();
    Utils.debugPrint('$BOX_NAME box has been cleaned');
    return super.close();
  }
}

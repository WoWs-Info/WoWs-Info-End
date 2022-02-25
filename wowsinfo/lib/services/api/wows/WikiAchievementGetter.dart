import 'package:wowsinfo/models/game_server.dart';
import 'package:wowsinfo/services/api/WoWsDataProvider.dart';

class WikiAchievementGetter extends WoWsDataProvider {
  WikiAchievementGetter(GameServer server) : super(server);

  @override
  String getDomainFields() => 'wows/encyclopedia/achievements/';

  @override
  String getExtraFields() =>
      '&fields=battle.hidden%2Cbattle.achievement_id%2Cbattle.name%2Cbattle.image%2Cbattle.image_inactive%2Cbattle.description';
}

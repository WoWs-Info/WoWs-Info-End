import 'package:wowsinfo/models/game_server.dart';
import 'package:wowsinfo/services/api/WoWsDataProvider.dart';

class PlayerClanTagGetter extends WoWsDataProvider {
  final int _accountId;
  PlayerClanTagGetter(GameServer server, this._accountId) : super(server);

  @override
  String getDomainFields() => 'wows/clans/accountinfo/';

  @override
  String getExtraFields() =>
      '&extra=clan&fields=clan.tag,clan.clan_id&account_id=$_accountId';
}

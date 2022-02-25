import 'package:wowsinfo/models/game_server.dart';
import 'package:wowsinfo/models/ui/WoWsDate.dart';
import 'package:wowsinfo/models/User/Player.dart';

/// This is the `ClanInfo` class
class ClanInfo {
  int membersCount;
  String name;
  String creatorName;
  int clanId;
  WoWsDate createdAt;
  int updatedAt;
  String leaderName;
  int creatorId;
  String tag;
  Map<String, Member> member;
  String oldName;
  bool isClanDisbanded;
  int renamedAt;
  String oldTag;
  int leaderId;
  String description;

  String get createdDate => createdAt.dateString;
  Iterable<Member> get members => member.values;
  Iterable<Member> get sortedMembers => members.toList(growable: false)
    ..sort((a, b) => a.joinedAt.time - b.joinedAt.time);

  ClanInfo(Map<String, dynamic> data) {
    final json = data.values.first;
    if (json != null) {
      this.membersCount = json['members_count'];
      this.name = json['name'];
      this.creatorName = json['creator_name'];
      this.clanId = json['clan_id'];
      this.createdAt = WoWsDate(json['created_at']);
      this.updatedAt = json['updated_at'];
      this.leaderName = json['leader_name'];
      this.creatorId = json['creator_id'];
      this.tag = json['tag'];
      this.member =
          (json['members'] as Map).map((a, b) => MapEntry(a, Member(b)));
      this.oldName = json['old_name'];
      this.isClanDisbanded = json['is_clan_disbanded'];
      this.renamedAt = json['renamed_at'];
      this.oldTag = json['old_tag'];
      this.leaderId = json['leader_id'];
      this.description = json['description'];
    }
  }
}

/// This is the `Member` class
class Member {
  String role;
  WoWsDate joinedAt;
  int accountId;
  String accountName;

  String get accountIdString => '$accountId';
  String get joinedDate => joinedAt.dateString;
  bool get hasRole => role != 'commissioned_officer';
  bool get isCommander => role == 'commander';
  bool get isExecutive => role == 'executive_officer';
  Player toPlayer(GameServer server) => Player(accountName, accountId, server);

  Member(Map<String, dynamic> json) {
    this.role = json['role'];
    this.joinedAt = WoWsDate(json['joined_at']);
    this.accountId = json['account_id'];
    this.accountName = json['account_name'];
  }
}

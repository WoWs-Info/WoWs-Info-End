import 'dart:convert';

import 'package:wowsinfo/models/Cacheable.dart';
import 'package:wowsinfo/services/api/APIDataProvider.dart';
import 'package:wowsinfo/utils/Utils.dart';
import 'package:http/http.dart' as http;

/// Only an url is needed for data from Github
abstract class GithubDataProvider<T extends Cacheable>
    extends APIDataProvider<T> {
  @override
  Future<T> requestData({T Function(dynamic) creator}) async {
    if (creator == null)
      throw Exception('A creator for GithubDataProvider is necessary');
    try {
      final response = await http
          .get(
            getRequestLink(),
          )
          .timeout(Duration(seconds: 8));

      // Return the body only when it is 200 all good
      if (response.statusCode == 200) {
        final body = response.body;
        if (body.isNotEmpty) return creator(jsonDecode(body));
      }

      return null;
    } catch (e) {
      Utils.debugPrint(e);
      return null;
    }
  }

  /// This is the top level link which is just my GitHub profile page
  @override
  String getBaseLink() => 'https://raw.githubusercontent.com/HenryQuan/';
}

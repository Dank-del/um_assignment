import 'dart:convert';

import 'package:http/http.dart' as http;

class GithubClient {
  Future<dynamic> get(String path) async {
    final headers = {
      'Accept': 'application/vnd.github.v3+json',
    };
    var req = await http.get(Uri.https('api.github.com', path), headers: headers);
    return jsonDecode(req.body);
  }

  Future<List<dynamic>> getUserRepos(String username) async {
    return await get('users/$username/repos') as List<dynamic>;
  }

  Future<dynamic> getCommits(String username, String repoName) async {
    return await get('repos/$username/$repoName/commits');
  }
}

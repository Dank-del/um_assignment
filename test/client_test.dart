import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:um_assignment/api/client.dart';

void main() {
  test('GithubClient should be able to make API requests', () async {
    final client = GithubClient();

    // TODO: Add test logic here

    var ok = await client.getUserRepos('Dank-del') as List<dynamic>;
    if (kDebugMode) {
      print(ok.length);
    }
    expect(ok, isNotNull);
  });
}

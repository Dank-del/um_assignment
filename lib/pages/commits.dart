import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../api/client.dart';

class LastCommitPage extends StatefulWidget {
  final String username;
  final String repoName;

  const LastCommitPage(
      {super.key, required this.username, required this.repoName});

  @override
  State<LastCommitPage> createState() => _LastCommitPageState();
}

class _LastCommitPageState extends State<LastCommitPage> {
  late Future<dynamic> _futureCommits;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureCommits =
        GithubClient().getCommits(widget.username, widget.repoName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Last Commit'),
        ),
        body: FutureBuilder<dynamic>(
          future: _futureCommits,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (kDebugMode) {
                print(snapshot.data[0]['commit']['message']);
              }
              return ListView(
                children: [
                  ListTile(
                    title: Text(snapshot.data[0]['commit']['message']),
                    subtitle:
                        Text(snapshot.data[0]['commit']['author']['name']),
                  ),
                  ExpansionTile(title: const Text("All Commits"), children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title:
                              Text(snapshot.data[index]['commit']['message']),
                          subtitle: Text(
                              snapshot.data[index]['commit']['author']['name']),
                          trailing: Text(intl.DateFormat.yMd().format(
                              DateTime.parse(snapshot.data[index]['commit']
                                  ['author']['date']))),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    )
                  ])
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

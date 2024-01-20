import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:um_assignment/pages/commits.dart';

import '../api/client.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<dynamic> _futureRepos;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _futureRepos = GithubClient().getUserRepos('Dank-del');
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<dynamic>(
        future: _futureRepos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (kDebugMode) {
              print(snapshot.data);
            }
            return ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LastCommitPage(
                                    username: snapshot.data![index]['owner']
                                        ['login'],
                                    repoName: snapshot.data![index]['name'],
                                  )));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          snapshot.data![index]['owner']['avatar_url']),
                    ),
                    title: Text(snapshot.data![index]['name']),
                    subtitle: Text(snapshot.data![index]['full_name']),
                    trailing: FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.fill,
                        child: Wrap(
                          spacing: 12,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 20, color: Colors.amber),
                                Text(
                                    snapshot.data![index]['stargazers_count']
                                        .toString(),
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.remove_red_eye,
                                    size: 20, color: Colors.blue),
                                Text(
                                    snapshot.data![index]['watchers_count']
                                        .toString(),
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        )));
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

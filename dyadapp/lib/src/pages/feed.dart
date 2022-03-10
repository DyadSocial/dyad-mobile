import 'dart:io';

import 'package:flutter/material.dart';

import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/widgets/feed_list.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_writer.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/data/protos/content.pb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/core.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    Key? key,
  }) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _postWriterActive;
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _postWriterActive = false;
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    )..addListener(_handleTabIndexChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  postWriterCloseCallback() {
    setState(() {
      _postWriterActive = false;
    });
  }

  Future<String> getFilePath(String hash) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String documentsDirectoryPath = documentsDirectory.path;
    return '$documentsDirectoryPath/$hash';
  }

  Future<void> _onFeedRefreshCallback() async {
    // setState posts
    print("Refreshing Feed..");
  }

  onWritePostCallback(postForm) async {
    var currentTime = DateTime.now();
    var postToAdd = Post(
        title: postForm.title,
        content: Content(
          text: postForm.content,
        ),
        author: await UserSession().get("username"),
        created: Timestamp.fromDateTime(currentTime),
        lastUpdated: Timestamp.fromDateTime(currentTime));

    int newPostID = await DatabaseHandler().insertPost(postToAdd);
    if (postForm.imageFile != null) {
      // Get Path
      final imageFilePath = await getFilePath(
          hash3(newPostID, postToAdd.author, currentTime.millisecondsSinceEpoch)
              .toString());
      File imageFile = File(imageFilePath);
      print(imageFile.path);
      // Write image to file
      imageFile.writeAsBytes((postForm.imageFile as File).readAsBytesSync());
      // Update Post entry with file path
      postToAdd.content.image = imageFilePath;
      await DatabaseHandler().updatePost(newPostID, postToAdd);
    }
  }

  _onPostNavigatorCallback(postId) async {
    _routeState.go('/post/$postId');
  }

  Future<List<Post>> _getPostData() async {
    await DatabaseHandler().posts().then((newPosts) {
      _posts = newPosts;
    });
    return _posts;
  }

  Future<List<Post>> _getSelfPostData() async {
    _getPostData();
    final currentUser = await UserSession().get("username");
    print(currentUser);
    return _posts.where((post) => post.author == currentUser).toList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: () {
              setState(() {
                _postWriterActive = !_postWriterActive;
              });
            },
          ),
          title: Center(child: const Text('Dyad')),
          toolbarHeight: _postWriterActive ? 50 : 60,
          bottomOpacity: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (context) =>
                        const SettingsScreen())) //Changed temporarily for inbox screen from SettingsScreen()
              },
              tooltip: 'About Dyad',
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'All',
                icon: Icon(Icons.people),
              ),
              Tab(
                text: 'Trusted Only',
                icon: Icon(Icons.favorite),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100, maxHeight: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: _postWriterActive,
                  child:
                      PostWriter(onWritePostCallback, postWriterCloseCallback),
                ),
                Container(
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          FutureBuilder<List<Post>>(
                            future: _getPostData(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? FeedList(
                                      _onFeedRefreshCallback,
                                      _onPostNavigatorCallback,
                                      snapshot.data!,
                                      onTap: _handlePostTapped,
                                    )
                                  : Center(
                                      child: new CircularProgressIndicator());
                            },
                          ),
                          FutureBuilder<List<Post>>(
                            future: _getSelfPostData(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? FeedList(
                                      _onFeedRefreshCallback,
                                      _onPostNavigatorCallback,
                                      snapshot.data!,
                                      onTap: _handlePostTapped,
                                    )
                                  : Center(
                                      child: new CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  RouteState get _routeState => RouteStateScope.of(context);

  void _handlePostTapped(Post post) {
    // TOOD: route to post
    //_routeState.go('/post/${post.id}');
  }

  void _handleTabIndexChanged() {
    switch (_tabController.index) {
      case 0:
        _routeState.go('/feed/all');
        print('going feed/all');
        break;
      case 1:
        _routeState.go('/feed');
        print('going feed');
        break;
      case 2:
        _routeState.go('/inbox');
        print('going inbox');
        break;
      default:
        _routeState.go('/feed/all');
        break;
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/widgets/feed_list.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_writer.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:path_provider/path_provider.dart';

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
      initialIndex: 1,
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

  onWritePostCallback(postForm) async {
    String? imgAsStr = null;
    if (postForm.imageFile != null)
      imgAsStr = base64Encode(postForm.imageFile.readAsBytesSync());
    DatabaseHandler().insertPost(
      Post(
        postForm.title,
        postForm.content,
        await UserSession().get("username"),
        DateTime.now(),
        imageStr: postForm.imageFile != null ? imgAsStr : null,
      ),
    );
    print(postForm.imageFile);
  }

  Future<List<Post>> _getPostData() async {
    await DatabaseHandler().getAllPosts().then((newPosts) {
      _posts = newPosts;
    });
    print("POST LENGTH: ${_posts.length}");
    return _posts;
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
                    builder: (context) => const SettingsScreen()))
              },
              tooltip: 'About Dyad',
            ),
          ],
/*           bottom: TabBar(
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
          ), */
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 0,
              child: Visibility(
                visible: _postWriterActive,
                child: PostWriter(onWritePostCallback, postWriterCloseCallback),
              ),
            ),
            Expanded(
              flex: 5,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
/*                   FeedList(
                    posts: postCacheInstance.allPosts,
                    onTap: _handlePostTapped,
                  ), */
                  FutureBuilder<List<Post>>(
                    future: _getPostData(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? FeedList(
                              posts: snapshot.data!,
                              onTap: _handlePostTapped,
                            )
                          : Center(child: new CircularProgressIndicator());
                    },
                  ),
                  FutureBuilder<List<Post>>(
                    future: _getPostData(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? FeedList(
                              posts: snapshot.data!,
                              onTap: _handlePostTapped,
                            )
                          : Center(child: new CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ],
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
      default:
        _routeState.go('/feed/all');
        break;
    }
  }
}

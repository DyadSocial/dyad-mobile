import 'package:flutter/material.dart';

import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/widgets/feed_list.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_writer.dart';

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
                child: PostWriter(postWriterCloseCallback),
              ),
            ),
            Expanded(
              flex: 5,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  FeedList(
                    posts: postCacheInstance.allPosts,
                    onTap: _handlePostTapped,
                  ),
                  FeedList(
                    // TODO: change to postCacheInstance.trustedPosts
                    posts: postCacheInstance.allPosts,
                    onTap: _handlePostTapped,
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

import 'package:flutter/material.dart';

import '../data.dart';
import '../routing.dart';
import '../widgets/feed_list.dart';
import 'settings.dart';

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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dyad'),
          toolbarHeight: 125,
          bottomOpacity: 0.8,
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
        body: TabBarView(
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

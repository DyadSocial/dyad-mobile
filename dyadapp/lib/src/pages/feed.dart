// Authors: Vincent
// Main Feed Screen
// Delegates network and database tasks to api_provider and network_handler

import 'dart:io';

import 'package:dyadapp/src/utils/api_provider.dart';
import 'package:flutter/material.dart';

import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/routing.dart';
import 'package:dyadapp/src/widgets/feed_list.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_writer.dart';
import 'package:dyadapp/src/utils/database_handler.dart';
import 'package:dyadapp/src/utils/user_session.dart';
import 'package:dyadapp/src/utils/data/protos/content.pb.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';
import 'package:dyadapp/src/utils/network_handler.dart';
import 'package:dyadapp/src/pages/map.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quiver/core.dart';

import '../utils/data/group.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    Key? key,
  }) : super(key: key);

  // Vincent
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

// Vincent
class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool _postWriterActive;
  List<Post> _posts = [];
  late final grpcClient _grpcClient;

  // Vincent
  @override
  void initState() {
    super.initState();
    _postWriterActive = false;
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    )
      ..addListener(_handleTabIndexChanged);
    _grpcClient = grpcClient();
    _onFeedRefreshCallback();
  }

  // Vincent
  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  // Vincent
  postWriterCloseCallback() {
    setState(() {
      _postWriterActive = false;
    });
  }

  // gets the filepath of the app for storing images locally
  // Vincent
  Future<String> getFilePath(String hash) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String documentsDirectoryPath = documentsDirectory.path;
    return '$documentsDirectoryPath/$hash';
  }

  // refreshes the feed
  // Vincent
  Future<void> _onFeedRefreshCallback() async {
    // setState posts
    String currentUser = await UserSession().get("username");
    //String currentCity = await UserSession().get("city");
    String? currentCity = await UserSession().get("city");
    if (currentCity != null) {
      DatabaseHandler().clearData();
      for (var post
      in await _grpcClient.runRefreshPosts(0, currentUser, currentCity)) {
        var profile = await APIProvider.getUserProfile(post.author);
        Provider.of<Group>(context, listen: false).updateUser(
            username: post.author,
            imageURL: profile['picture_URL'],
            biography: profile['Profile_Description'],
            nickname: profile['Display_name']);
        setState(() {
          DatabaseHandler().insertPost(post);
        });
      }
    }
  }

  // Updates the post at the right ID in the database and updates accordingly
  // on the backend gRPC server
  // Vincent
  Future<Post?> _onUpdatePostCallback(Post post) async {
    post.lastUpdated = Timestamp.fromDateTime(DateTime.now());
    await DatabaseHandler().updatePost(post.id, post);
    _grpcClient.runUploadPosts([post]);
    List<Post> updatedPosts = await _getPostData();
    setState(() {
      _posts = updatedPosts;
    });
    for (int i = 0; i < _posts.length; i++) {
      if (_posts[i] == post.author && _posts[i] == post.id) {
        return _posts[i];
      }
    }
  }

  // Updates downward in post list
  // Vincent
  Future<void> _onFeedQueryCallback() async {
    // Edge case
    if (_posts.isEmpty) {
      return _onFeedRefreshCallback();
    }
    // Sort chronologically
    _posts.sort((a, b) {
      if (a.lastUpdated.seconds < b.lastUpdated.seconds) {
        return -1;
      } else if (a.lastUpdated.seconds == b.lastUpdated.seconds) {
        return 0;
      } else {
        return 1;
      }
    });
    Post lastPost = _posts[_posts.length];
    String? currentCity = await UserSession().get("city");
    if (currentCity == null) {
      return;
    }
    for (var post in await _grpcClient.runQueryPosts(
        lastPost.id, lastPost.author, currentCity)) {
      setState(() {
        DatabaseHandler().insertPost(post);
      });
    }
  }

  // Vincent
  onDeletePostCallback(int id, String author) async {
    print("CALL TO DELETE $id:$author");
    if (author == await UserSession().get("username")) {
      await DatabaseHandler().deletePost(id);
      setState(() {
        _posts.removeWhere((post) => post.id == id);
      });
      String? currentCity = await UserSession().get("city");
      if (currentCity == null) {
        return;
      }
      print(await _grpcClient.runDeletePost(id, author, currentCity));
    }
  }

  // Writes a post to server
  // Vincent
  onWritePostCallback(PostForm postForm) async {
    // Create the base post (no event, image, or id)
    var currentTime = DateTime.now();
    String currentCity = await UserSession().get("city");
    String username = await UserSession().get("username");
    var postToAdd = Post(
        title: postForm.title,
        content: Content(
          text: postForm.content,
        ),
        author: username,
        created: Timestamp.fromDateTime(currentTime),
        lastUpdated: Timestamp.fromDateTime(currentTime),
        group: currentCity);

    // Get a generated ID from the local database after inserting it
    int newPostID = await DatabaseHandler().insertPost(postToAdd);

    // Add to image if it exists
    if (postForm.imageFile != null) {
      // Get Path
      final uuid = hash3(
          newPostID, postToAdd.author, currentTime.millisecondsSinceEpoch);
      final imageFilePath = await getFilePath("$uuid.png");
      File imageFile = File(imageFilePath);
      print(imageFile.path);
      // Write image to file
      await imageFile
          .writeAsBytes((postForm.imageFile as File).readAsBytesSync());
      String? imgURL = await APIProvider.uploadImageFile(
          imageFilePath, username, uuid.toString());
      // Update Post entry with file path
      //postToAdd.content.image = imageFilePath;
      if (imgURL != null) {
        postToAdd.content.image = "https://api.dyadsocial.com" + imgURL;
      }
    }

    // Add event to new post if it exists
    if (postForm.eventDateTime != null) {
      postToAdd.eventTime = Timestamp.fromDateTime(postForm.eventDateTime!);
    } else {
      postToAdd.clearEventTime();
    }

    // Update post's ID with the ID we got from local database
    postToAdd.id = newPostID;

    // Update the post with all the new content
    await DatabaseHandler().updatePost(newPostID, postToAdd);

    // Update post's we see with the post's stored on database
    var newPostList = await _getPostData();
    setState(() {
      _posts = newPostList;
    });

    // Finally upload the finalized post
    await _grpcClient.runUploadPosts([postToAdd]);
    print(postToAdd);
  }

  // Uses navigator parser to jump to the post
  // Vincent
  _onPostNavigatorCallback(postId) {
    _routeState.go('/post/$postId');
  }

  // Gets posts data from database
  // Vincent
  Future<List<Post>> _getPostData() async {
    await DatabaseHandler().posts().then((newPosts) {
      _posts = newPosts;
    });
    return _posts;
  }

  // Gets post data from database filtered by the current user's post
  // Vincent
  Future<List<Post>> _getSelfPostData() async {
    final currentUser = await UserSession().get("username");
    await DatabaseHandler().posts().then((newPosts) {
      _posts = newPosts;
    });
    return _posts.where((post) => post.author == currentUser).toList();
  }

  // Vincent
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: () {
              setState(() {
                _postWriterActive = !_postWriterActive;
              });
            },
          ),
          title: Center(
              child: Column(children: [
                TextButton(
                    child: Text("Dyad",
                        style: TextStyle(
                            fontSize: 30, color: Color(0xFFECEFF4))),
                    onPressed: () {
                      _onFeedRefreshCallback();
                    }),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: FutureBuilder<dynamic>(
                      future: UserSession().get("city"),
                      builder:
                          (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        return snapshot.hasData
                            ? Text(snapshot.data ?? "Error getting location",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFECEFF4)))
                            : Text('Loading..',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFE5E9F0)));
                      }),
                )
              ])),
          toolbarHeight: _postWriterActive ? 80 : 60,
          bottomOpacity: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () =>
              {
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
                text: 'Your Posts',
                icon: Icon(Icons.person),
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
                      // Either get all post data or get data from only self
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          FutureBuilder<List<Post>>(
                            future: _getPostData(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? FeedList(
                                _onUpdatePostCallback,
                                _onFeedRefreshCallback,
                                _onPostNavigatorCallback,
                                snapshot.data!,
                                onDeletePostCallback,
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
                                _onUpdatePostCallback,
                                _onFeedRefreshCallback,
                                _onPostNavigatorCallback,
                                snapshot.data!,
                                onDeletePostCallback,
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

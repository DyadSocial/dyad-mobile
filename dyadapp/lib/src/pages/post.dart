import 'package:flutter/material.dart';
import 'package:dyadapp/src/data.dart';
import 'package:dyadapp/src/pages/settings.dart';
import 'package:dyadapp/src/widgets/post_bar.dart';
import 'package:dyadapp/src/utils/data/post.dart';
import 'package:quiver/strings.dart';

class PostPage extends StatelessWidget {
  PostPage({Key? key,}) : super(key: key);
  final Post thisPost = postCacheInstance.allPosts.where((post) => post.author == 'primchi').first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Dyad')),
        actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {
                Navigator.of(context).push<void>(MaterialPageRoute<void>(
                    builder: (context) => const SettingsScreen()))
              },
            ),
        ],
      ),
      body: _buildPage()
    );
  }

  Widget _buildPage() {
    return Column(
      children: [
        SizedBox(height: 10),
        Row (
          children: [
            SizedBox(width: 10),
            CircleAvatar(radius: 20),
            SizedBox(width: 10),
            Text(thisPost.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]
        ),
        Padding (
          padding: const EdgeInsets.only(),
          child: Text(thisPost.author, style: const TextStyle(fontSize: 12)),
        )
        //Text(thisPost.author, style: const TextStyle(fontSize:14)
      ],
    );
  }
}



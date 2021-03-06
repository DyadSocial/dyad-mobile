// Auhtor: Vincent Pham
// Implements gRPC client which requests for posts streams and uploads
// Commented code is the standalone test script
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:typed_data';
import 'package:grpc/grpc.dart';
import 'package:dyadapp/src/utils/data/protos/content.pb.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pbgrpc.dart';
import 'package:dyadapp/src/utils/data/protos/count.pb.dart';
import 'package:dyadapp/src/utils/data/protos/count.pbgrpc.dart';
import 'package:dyadapp/src/utils/data/protos/google/protobuf/timestamp.pb.dart';

class grpcClient {
  late ActiveUsersClient activePostStub;
  late PostsSyncClient postStub;
  late ClientChannel channel;

  static final grpcClient _instance = new grpcClient._internal();

  factory grpcClient() => _instance;

  grpcClient._internal() {
    final channelCredentials = new ChannelCredentials.insecure();
    final channelOptions = new ChannelOptions(credentials: channelCredentials);
    channel = ClientChannel(
        'data.dyadsocial.com', port: 50051, options: channelOptions);
    postStub = PostsSyncClient(channel,
        options: CallOptions(timeout: Duration(minutes: 1)));
    activePostStub = ActiveUsersClient(
        channel, options: CallOptions(timeout: Duration(minutes: 1)));
  }

  Future<int> runGetActiveUsers() async {
    ActiveQuery query = ActiveQuery(requestor: "dummy");
    int sum = 0;
    await for (Count c in activePostStub.getRecentlyActive(query)) {
      sum += c.count;
    }
    return sum;
  }

  Future<List<Post>> runRefreshPosts(
      int id, String currentUser, String city) async {
    PostQuery query = PostQuery(id: id, author: currentUser, gid: city);
    List<Post> posts = [];
    await for (Post post in postStub.refreshPosts(query)) {
      posts.add(post);
    }
    return posts;
  }

  Future<List<Post>> runQueryPosts(
      int id, String currentUser, String city) async {
    PostQuery query = PostQuery(id: id, author: currentUser, gid: city);
    List<Post> posts = [];
    await for (Post post in postStub.refreshPosts(query)) {
      posts.add(post);
    }
    return posts;
  }

  Future<Map<String, dynamic>> runUploadPosts(List<Post> posts) async {
    Stream<Post> yieldList(List<Post> items) async* {
      for (var item in items) {
        yield item;
      }
    }
    print("Uploading: ${channel.host}:${channel.port}");
    final PostUploadAck ack =
        await postStub.uploadPosts(yieldList(posts));
    return ack.writeToJsonMap();
  }

  Future<Map<String, dynamic>> runDeletePost(int id, String currentUser, String city) async {
    PostQuery query = PostQuery(id: id, author: currentUser, gid: city);
    return (await postStub.deletePost(query)).writeToJsonMap();
  }
}

/* Test call to server
Future<void> main(List<String> args) async {
  final client = grpcClient();
  List<Post> posts = [];
  for (int i = 0; i < 5; i++) {
    posts.add(Post(
      id: "id$i",
      author: "author$i",
      content: Content(text: "text$i"),
      lastUpdated: Timestamp.getDefault(),
      created: Timestamp.getDefault(),
      title: "title$i",
      group: "reno",
    ));
  }
  print("Uploading posts");
  client.runUploadPosts(posts);
  print("Pulling posts");
  var queried = await client.runRefreshPosts("idk", "vncp", "reno");
  for (final post in queried) {
    print(post);
  }
}
*/


/* Old Code for Images for reference
class grpcClient {
  late PostsSyncClient postStub;
  late ClientChannel channel;

  grpcClient() {
    final channelCredentials = new ChannelCredentials.insecure();
    final channelOptions = new ChannelOptions(credentials: channelCredentials);
    channel =
        ClientChannel('data.dyadsocial.com', port: 80, options: channelOptions);

    postStub = PostsSyncClient(channel,
        options: CallOptions(timeout: Duration(seconds: 25)));
  }

  Stream<ImageChunk> _byteChunker(
      String bytes, String username, String id) async* {
    int pos = 0;
    int endOffset = pos + CHUNK_SIZE;
    print("Out: $bytes");
    while (pos < bytes.length) {
      if (endOffset < bytes.length) {
        print("Chunk: ${bytes.substring(pos, pos + CHUNK_SIZE)}");
        yield ImageChunk(
            imagedata: bytes.substring(pos, pos + CHUNK_SIZE),
            id: id,
            username: username,
            imagesize: bytes.length);
      } else {
        print("Chunk: ${bytes.substring(pos, bytes.length)}");
        yield ImageChunk(
            imagedata: bytes.substring(pos, bytes.length),
            id: id,
            username: username,
            imagesize: bytes.length);
      }
      pos += CHUNK_SIZE;
      endOffset = pos + CHUNK_SIZE;
    }
  }

  Future<Map<String, dynamic>> runUploadImage(
      Uint8List image, String username, String id) async {
    String imageBytes = base64.encode(image);
    final Ack ack =
        await imagesStub.uploadImage(_byteChunker(imageBytes, username, id));
    return ack.writeToJsonMap();
  }

  Future<Uint8List> runPullImage(String username, String id) async {
    ImageQuery query = ImageQuery(
      author: username,
      id: id,
      created: Timestamp.fromDateTime(DateTime.now()),
    );
    String imageBytes = "";
    await for (ImageChunk chunk in imagesStub.pullImage(query)) {
      print("Chunk: ${chunk.imagedata}");
      imageBytes += chunk.imagedata;
    }
    return base64.decode(imageBytes);
  }

  // Gets newer posts
  Future<List<Post>> runRefreshPosts(
      String postId, String groupId, String username) async {
    PostQuery query = PostQuery(id: postId, gid: groupId, author: username);
    List<Post> posts = [];
    await for (Post post in postStub.refreshPosts(query)) {
      posts.add(post);
    }
    return posts;
  }

  // Gets older posts
  Future<List<Post>> runQueryPosts(
      String postId, String groupId, String username) async {
    PostQuery query = PostQuery(id: postId, gid: groupId, author: username);
    List<Post> posts = [];
    await for (Post post in postStub.queryPosts(query)) {
      posts.add(post);
    }
    return posts;
  }
}

// Test function to run as an example client
Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print("Usage `dart network_handler.dart <ImageSize(bytes)>");
  }
  final client = grpcClient();
  int size = int.parse(args[0]);
  Uint8List image = Uint8List(0);
  for (int i = 0; i < size; i++) {
    image = Uint8List.fromList([...image, (i % 10)]);
  }
  print("Uploading..");
  await client.runUploadImage(image, "infuhnit", "abc123");

  print("Pulling..");
  await client.runPullImage("infuhnit", "abc123");
  print("Done");
  exit(0);
}

 */

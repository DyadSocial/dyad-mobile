import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:grpc/grpc.dart';
import 'package:dyadapp/src/utils/data/protos/image.pbgrpc.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pbgrpc.dart';
import 'package:dyadapp/src/utils/data/protos/google/protobuf/timestamp.pb.dart';

const CHUNK_SIZE = 32 * 1024; //(32Kb)

class grpcClient {
  late ImagesClient imagesStub;
  late GroupSyncClient groupStub;
  late PostsSyncClient postStub;
  late ClientChannel channel;

  grpcClient() {
    final channelCredentials = new ChannelCredentials.insecure();
    final channelOptions = new ChannelOptions(credentials: channelCredentials);
    channel =
        ClientChannel('data.dyadsocial.com', port: 80, options: channelOptions);

    imagesStub = ImagesClient(channel,
        options: CallOptions(timeout: Duration(seconds: 120)));
    groupStub = GroupSyncClient(channel,
        options: CallOptions(timeout: Duration(seconds: 25)));
    postStub = PostsSyncClient(channel,
        options: CallOptions(timeout: Duration(seconds: 25)));
  }

  Stream<ImageChunk> _byteChunker(String bytes) async* {
    int pos = 0;
    int endOffset = pos + CHUNK_SIZE;
    print("$bytes");
    while (pos < bytes.length) {
      if (endOffset < bytes.length) {
        yield ImageChunk(imagedata: bytes.substring(pos, pos + CHUNK_SIZE));
      } else {
        yield ImageChunk(imagedata: bytes.substring(pos, bytes.length));
      }
      pos += CHUNK_SIZE;
      endOffset = pos + CHUNK_SIZE;
    }
  }

  Future<Map<String, dynamic>> runUploadImage(
      Uint8List image, String username, String id) async {
    String imageBytes = base64.encode(image);

    final Ack ack = await imagesStub.uploadImage(
      _byteChunker(imageBytes),
      options: CallOptions(metadata: {
        "size": imageBytes.length.toString(),
        "username": username,
        "id": id
      }),
    );
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
      if (imageBytes.length == 0) imageBytes.padRight(chunk.imagesize, ' ');
      imageBytes = imageBytes + chunk.imagedata;
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
  await client.runUploadImage(image, "vncp", "abc123");

  await client.runPullImage("vncp", "abc123");
  print("Done");
  exit(0);
}

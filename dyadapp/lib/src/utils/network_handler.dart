import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:grpc/grpc.dart';
import 'package:dyadapp/src/utils/data/protos/image.pbgrpc.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pbgrpc.dart';
import 'package:dyadapp/src/utils/data/protos/google/protobuf/timestamp.pb.dart';

const CHUNK_SIZE = 32 * 1024; //(32Kb)

class grpcClient {
  late ImagesClient stub;
  late ClientChannel channel;

  grpcClient() {
    final channelCredentials = new ChannelCredentials.insecure();
    final channelOptions = new ChannelOptions(credentials: channelCredentials);
    channel = ClientChannel('127.0.0.1', port: 5442, options: channelOptions);

    stub = ImagesClient(channel,
        options: CallOptions(timeout: Duration(seconds: 120)));
  }

  Stream<ImageChunk> _byteChunker(Uint8List bytes) async* {
    int pos = 0;
    int endOffset = pos + CHUNK_SIZE;
    while (pos < bytes.lengthInBytes) {
      if (endOffset < bytes.lengthInBytes) {
        yield ImageChunk(imagedata: bytes.sublist(pos, pos + CHUNK_SIZE));
      } else {
        yield ImageChunk(imagedata: bytes.sublist(pos, bytes.lengthInBytes));
      }
      pos += CHUNK_SIZE;
      endOffset = pos + CHUNK_SIZE;
    }
  }

  Future<Map<String, dynamic>> runUploadImage(Uint8List imageBytes) async {
    final Ack ack = await stub.uploadImage(
      _byteChunker(imageBytes),
      options: CallOptions(metadata: {
        "size": imageBytes.lengthInBytes.toString(),
        "username": "vncp",
        "id": "abc123"
      }),
    );
    return ack.writeToJsonMap();
  }

  Future<Uint8List> runPullImage(ImageQuery query) async {
    late var imageBytes;
    var pos = 0;
    await for (ImageChunk chunk in stub.pullImage(query)) {
      if (chunk.hasSize()) {
        print(chunk.size);
        imageBytes = Uint8List(chunk.size.toInt());
      } else {
        for (int i = 0; i < chunk.imagedata.length; i++) {
          imageBytes[pos++] = chunk.imagedata[i];
        }
      }
    }
    print(imageBytes);
    return imageBytes;
  }
}

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print("Usage `dart network_handler.dart <ImageSize(bytes)>");
  }
  final client = grpcClient();
  Uint8List image = Uint8List(int.parse(args[0]));
  final random = Random(1337);
  for (int i = 0; i < image.length; i++) {
    image[i] = random.nextInt(254);
  }
  image = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
  await client.runUploadImage(image);

  final query = ImageQuery(
      author: "vncp",
      id: "abc123",
      created: Timestamp.fromDateTime(DateTime.now()));
  await client.runPullImage(query);
  print("Done");
  exit(0);
}

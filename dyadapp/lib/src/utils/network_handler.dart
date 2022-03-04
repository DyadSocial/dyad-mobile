import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:grpc/grpc.dart';
import 'package:dyadapp/src/utils/data/protos/image.pbgrpc.dart';

const CHUNK_SIZE = 32 * 1024; //(32Kb)

class grpcClient {
  late ImagesClient stub;
  late ClientChannel channel;

  grpcClient() {
    channel = ClientChannel(
      '127.0.0.1',
      port: 8080,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    stub = ImagesClient(channel,
        options: CallOptions(timeout: Duration(seconds: 120)));
  }

  Stream<ImageChunk> _byteChunker(Uint8List bytes) async* {
    int pos = 0;
    int endOffset = pos + CHUNK_SIZE;
    int chunkCount = 0;
    print("Size: ${bytes.lengthInBytes}");
    while (pos < bytes.lengthInBytes) {
      if (endOffset < bytes.lengthInBytes) {
        yield ImageChunk(imageData: bytes.sublist(pos, pos + CHUNK_SIZE));
      } else {
        yield ImageChunk(imageData: bytes.sublist(pos, bytes.lengthInBytes));
      }
      chunkCount++;
      pos += CHUNK_SIZE;
      endOffset = pos + CHUNK_SIZE;
    }
    print("Created $chunkCount chunks.");
  }

  Future<void> runUploadImage(Uint8List imageBytes) async {
    final Ack ack =
        await stub.uploadImage(_byteChunker(imageBytes), options: Meta);
    print('Upload Status: ${ack.success}');
    print('Received Image Size: ${ack.imageSize}');
  }
}

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print("Usage `dart network_handler.dart <ImageSize(bytes)>");
  }
  final client = grpcClient();
  final Uint8List image = Uint8List(int.parse(args[0]));
  final random = Random(1337);
  for (int i = 0; i < image.length; i++) {
    image[i] = random.nextInt(254);
  }
  await client.runUploadImage(image);
  print("Done");
  exit(0);
}

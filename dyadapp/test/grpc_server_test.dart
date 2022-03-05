import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:dyadapp/src/utils/data/protos/image.pbgrpc.dart';

class ImageService extends ImagesServiceBase {
  @override
  Future<Ack> uploadImage(grpc.ServiceCall call, Stream<ImageChunk> req) async {
    print('Received Request for ImageUpload');
    var chunkCount = 0;
    final timer = Stopwatch();
    int size = int.parse(call.clientMetadata!["size"]!);
    Uint8List image = Uint8List(size);
    int pos = 0;
    await for (ImageChunk chunk in req) {
      if (!timer.isRunning) timer.start();
      // Static allocation for 2 MB, dynamically copying image costs 93% of time
      for (int i = 0; i < chunk.imageData.length; i++) {
        image[pos++] = chunk.imageData[i];
      }
      chunkCount++;
    }
    timer.stop();
    print('Processing took ${timer.elapsedMicroseconds / 1000000} seconds');
    print('Received $chunkCount chunks.');
    return Ack()
      ..success = true
      ..imageSize = image.lengthInBytes.toString() + "B";
  }

  @override
  Stream<ImageChunk> pullImage(grpc.ServiceCall call, ImageQuery query) async* {
    Stream<ImageChunk> _byteChunker(Uint8List bytes) async* {
      int pos = 0;
      int chunkOffset;
      while (pos < bytes.lengthInBytes) {
        chunkOffset = pos + 32768;
        if (chunkOffset < bytes.lengthInBytes) {
          yield ImageChunk(imageData: bytes.sublist(pos, chunkOffset));
        } else {
          yield ImageChunk(imageData: bytes.sublist(pos, bytes.lengthInBytes));
        }
        pos += 32768;
      }
    }

    print("Received Request for ImagePull");
    var image = Uint8List(3145728);
    yield ImageChunk(size: (Int64(3145728)));
    int chunkNum = 0;
    await for (ImageChunk chunk in _byteChunker(image)) {
      print(chunkNum++);
      yield chunk;
    }
  }
}

Future<void> main(List<String> args) async {
  final server = grpc.Server([ImageService()]);
  await server.serve(port: 8080);
  print('Server listening on port ${server.port}..');
}

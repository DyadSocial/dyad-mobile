import 'dart:typed_data';

import 'package:grpc/grpc.dart' as grpc;
import 'package:dyadapp/src/utils/data/protos/image.pbgrpc.dart';

class ImageService extends ImagesServiceBase {
  @override
  Future<Ack> uploadImage(grpc.ServiceCall call, Stream<ImageChunk> req) async {
    print('Received Request for ImageUpload');
    var chunkCount = 0;
    final timer = Stopwatch();
    Uint8List image = Uint8List(2097152);
    int pos = 0;
    await for (ImageChunk chunk in req) {
      if (!timer.isRunning) timer.start();
      var chunkOffset = 0;
      for (int i = pos; i + 32768 < 2097152; i += 32768) {
        image[i] = chunk.imageData[chunkOffset++];
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
}

Future<void> main(List<String> args) async {
  final server = grpc.Server([ImageService()]);
  await server.serve(port: 8080);
  print('Server listening on port ${server.port}..');
}

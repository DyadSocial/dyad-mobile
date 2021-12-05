import 'package:flutter/material.dart';
// Image Packages
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class PostForm {
  final String title;
  final String content;
  final File? imageFile;

  PostForm(this.title, this.content, {this.imageFile});
}

class PostWriter extends StatefulWidget {
  final ValueChanged<PostForm> onWritePost;
  final Function() closeWriterCallback;

  PostWriter(
    onWritePost,
    closeWriterCallback, {
    Key? key,
  })  : this.onWritePost = onWritePost,
        this.closeWriterCallback = closeWriterCallback,
        super(key: key);

  @override
  _PostWriterState createState() => _PostWriterState();
}

class _PostWriterState extends State<PostWriter> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _imagePicker(ImageSource src) async {
    final XFile? image = await this._picker.pickImage(source: src);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _imageCropper() async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio4x3
      ],
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _removeImage() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                //color: Color(0xFF9A9A9A),
                ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            //color: Color(0xFFE8EDF1),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _contentController,
                      decoration: InputDecoration(labelText: 'Body'),
                      minLines: 2,
                      maxLines: 10,
                    ),
                  ),
                  Visibility(
                    visible: _imageFile != null,
                    child: _imageFile != null
                        ? Image.file(
                            _imageFile!,
                            fit: BoxFit.contain,
                            height: 250,
                            width: 250,
                          )
                        : Container(),
                  ),
                  Container(
                    height: 36,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.expand_less),
                          onPressed: () {
                            _removeImage();
                            widget.closeWriterCallback();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.photo_camera),
                          onPressed: () => _imagePicker(ImageSource.camera),
                        ),
                        IconButton(
                          icon: Icon(Icons.collections),
                          onPressed: () => _imagePicker(ImageSource.gallery),
                        ),
                        IconButton(
                          icon: Icon(Icons.crop),
                          onPressed: () => _imageCropper(),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            widget.onWritePost(PostForm(
                              _titleController.value.text,
                              _contentController.value.text,
                              imageFile: _imageFile,
                            ));
                            _removeImage();
                            widget.closeWriterCallback();
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      );
}

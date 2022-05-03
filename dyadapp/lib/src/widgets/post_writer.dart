// Author: Vincent
// A drop down widget that allows users to create posts.
// Has form for title, events times, content images, content text

import 'package:flutter/material.dart';

// Image Packages
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class PostForm {
  final String title;
  final String content;
  final File? imageFile;
  final DateTime? eventDateTime;

  PostForm(this.title, this.content, {this.imageFile, this.eventDateTime});
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
  DateTime? currentDate = null;
  TimeOfDay? currentTime = null;
  bool includesEvent = false;
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();
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
    File? cropped = await _cropper.cropImage(
      sourcePath: _imageFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
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
                        ? TextButton(
                            onPressed: () => _imageCropper(),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.contain,
                              height: 250,
                              width: 250,
                            ),
                          )
                        : Container(),
                  ),
                  Visibility(
                      visible: includesEvent,
                      child: Container(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text("EVENT DATE",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                              ),
                              currentDate != null
                                  ? Text(DateFormat('LLL dd, yyy')
                                      .format(currentDate!))
                                  : Container(),
                              // If current time is set, then so will currentDate's time to reflect it
                              currentTime != null
                                  ? Text(DateFormat('jm').format(currentDate!))
                                  : Container(),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ElevatedButton(
                                        child: Text("Choose Date"),
                                        onPressed: () async {
                                          var lastDay = DateTime.now();
                                          lastDay = lastDay
                                              .add(const Duration(days: 7));
                                          print(lastDay.toString());
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: lastDay);
                                          setState(() {
                                            // if time was set first, update the currentDate w/ time
                                            if (currentTime != null) {
                                              currentDate = new DateTime(
                                                  (pickedDate?.year)!,
                                                  (pickedDate?.month)!,
                                                  (pickedDate?.day)!,
                                                  (currentTime?.hour)!,
                                                  (currentTime?.minute)!);
                                            } else { // else just set it to pickedDate
                                              currentDate = pickedDate;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ElevatedButton(
                                          child: Text("Choose Time"),
                                          onPressed: () async {
                                            TimeOfDay? pickedTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());
                                            setState(() {
                                              currentTime = pickedTime;
                                              // If currentDate set then update it with time
                                              if (currentDate != null) {
                                                currentDate = new DateTime(
                                                    (currentDate?.year)!,
                                                    (currentDate?.month)!,
                                                    (currentDate?.day)!,
                                                    (currentTime?.hour)!,
                                                    (currentTime?.minute)!);
                                              } else {
                                                currentDate = new DateTime(
                                                    (DateTime.now().year),
                                                    (DateTime.now().month),
                                                    (DateTime.now().day),
                                                    (currentTime?.hour)!,
                                                    (currentTime?.minute)!
                                                );
                                              }
                                            });
                                          }),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ))),
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
                          icon: Icon(Icons.broken_image),
                          color: this._imageFile != null
                              ? Color(0xFF000000)
                              : Color(0xFF777777),
                          onPressed: () =>
                              this._imageFile != null ? _removeImage() : {},
                        ),
                        IconButton(
                          icon: Icon(Icons.crop),
                          onPressed: () => _imageCropper(),
                        ),
                        // Toggles Event date
                        IconButton(
                          icon: Icon(Icons.calendar_month),
                          onPressed: () {
                            setState(() {
                              includesEvent = !includesEvent;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            widget.onWritePost(PostForm(
                              _titleController.value.text,
                              _contentController.value.text,
                              imageFile: _imageFile,
                              eventDateTime: currentDate
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

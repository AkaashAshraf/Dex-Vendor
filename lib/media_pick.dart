/*
 * Copyright (c) 2019.
 *           ______             _
 *          |____  |           | |
 *  _ __ ___    / / __ ___   __| |_ __ __ _
 * | '_ ` _ \  / / '_ ` _ \ / _` | '__/ _` |
 * | | | | | |/ /| | | | | | (_| | | | (_| |
 * |_| |_| |_/_/ |_| |_| |_|\__,_|_|  \__,_|
 *
 *
 *
 *
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mplus_provider/crop_video.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:video_compress/video_compress.dart';

class MediaPickDialog extends StatefulWidget {
  @required
  final String file;

  const MediaPickDialog({Key key, this.file}) : super(key: key);

  @override
  _MediaPickDialogState createState() => _MediaPickDialogState();
}

bool compressing = false;

class _MediaPickDialogState extends State<MediaPickDialog> {
  Future<File> compress(File file) async {
    setState(() {
      compressing = true;
    });
    await VideoCompress.deleteAllCache();
    MediaInfo mediaInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
    );
    setState(() {
      compressing = false;
    });
    return mediaInfo.file;
  }

  @override
  void initState() {
    compressing = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: compressing
            ? Center(child: Load(200.0))
            : Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextResponsive('قم باختيار ملفك باستخدام'),
                      const SizedBox(
                        height: 8,
                      ),
                      ListTile(
                        onTap: () async {
                          if (widget.file != 'vid') {
                            var pickedfile = await ImagePicker().getImage(
                                source: ImageSource.camera, imageQuality: 50);
                            var result = File(pickedfile.path);
                            var lostData = await ImagePicker().getLostData();
                            if (lostData.file != null) {
                              result = File(lostData.file.path);
                            }
                            Navigator.pop(context, result);
                          } else {
                            var pickedFile = await ImagePicker()
                                .getVideo(source: ImageSource.camera);
                            var result = await compress(File(pickedFile.path));
                            var lostData = await ImagePicker().getLostData();
                            if (lostData.file != null) {
                              result = File(lostData.file.path);
                            }
                            var returnedFile = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CropVid(file: result)));
                            Navigator.pop(context, returnedFile);
                          }
                        },
                        title: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).primaryColor,
                        ),
                        trailing: Text('الكاميرا'),
                      ),
                      ListTile(
                        onTap: () async {
                          if (widget.file != 'vid') {
                            var pickedfile = await ImagePicker().getImage(
                                source: ImageSource.gallery, imageQuality: 50);
                            var result = File(pickedfile.path);
                            print(result.path);
                            var lostData = await ImagePicker().getLostData();
                            if (lostData.file != null) {
                              result = File(lostData.file.path);
                            }
                            Navigator.pop(context, result);
                          } else {
                            var pickedFile = await ImagePicker()
                                .getVideo(source: ImageSource.gallery);
                            var result = await compress(File(pickedFile.path));
                            var lostData = await ImagePicker().getLostData();
                            if (lostData.file != null) {
                              result = File(lostData.file.path);
                            }
                            var returnedFile = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CropVid(file: result)));
                            Navigator.pop(context, returnedFile);
                          }
                        },
                        title: Icon(
                          Icons.image,
                          color: Theme.of(context).primaryColor,
                        ),
                        trailing: Text('الوسائط'),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text('الغاء',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15))))
                    ],
                  ),
                )),
      ),
    );
  }
}

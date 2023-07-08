import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mplus_provider/globals.dart';
import 'package:mplus_provider/media_pick.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_player/video_player.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  VideoPlayerController controller;
  Future<void> vidFunc;
  String state = 'play';
  File _profileImage;
  String statusType = '';
  TextEditingController text = TextEditingController();
  bool loading = false;

  Future<Map> getUrl() async {
    try {
      FormData data = FormData.fromMap({
        "file":
            await MultipartFile.fromFile(_profileImage.path, filename: "video"),
      });
      Response response = await Dio().post(baseURL + 'uploadFile', data: data);

      return response.data;
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  Future addStatus(String type) async {
    try {
      setState(() {
        loading = true;
      });
      var response;
      if (type == 'photo') {
        FormData data = FormData.fromMap({
          "storyTitle": "newStory",
          "storyText": text.text,
          "puplisherName": "${shop?.name}",
          "puplisherName_ar": "${shop?.nameAr}",
          "targetedShopId": "${shop?.id}",
          "purplisherId": "${shop?.id}",
          "fileURL": "",
          "storyImage": await MultipartFile.fromFile(_profileImage.path,
              filename: "image"),
        });
        response = await Dio().post(baseURL + "addStory", data: data);
      } else {
        Map vid = await getUrl();
        if (vid['State'] == true) {
          FormData data = FormData.fromMap({
            "storyTitle": "newStory",
            "storyText": text.text,
            "puplisherName": "${shop?.name}",
            "puplisherName_ar": "${shop?.nameAr}",
            "targetedShopId": "${shop?.id}",
            "purplisherId": "${shop?.id}",
            "fileURL": vid['Data'],
            "storyImage": ""
          });
          response = await Dio().post(baseURL + 'addStory', data: data);
        } else {
          setState(() {
            loading = false;
          });
          await Fluttertoast.showToast(
            msg: 'errorRetry'.tr(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }
      }

      if (type == 'photo' && response.data['State'] == true) {
        setState(() {
          loading = false;
        });
        await Fluttertoast.showToast(
          msg: 'statusAdded'.tr(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.of(context).pop();
      } else if (type == 'vid' && response.data['State'] == true) {
        setState(() {
          loading = false;
        });
        await Fluttertoast.showToast(
          msg: 'statusAdded'.tr(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.of(context).pop();
      } else if (response.data['State'] != true) {
        await Fluttertoast.showToast(
          msg: 'errorRetry'.tr(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      setState(() {
        loading = false;
      });
    } on DioError catch (error) {
      setState(() {
        loading = false;
      });
      await Fluttertoast.showToast(
        msg: 'errorRetry'.tr(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      await Fluttertoast.showToast(
        msg: 'errorRetry'.tr(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw error;
    }
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: TextResponsive(
            'addSataus'.tr(),
            style: TextStyle(fontSize: 40, color: Colors.black),
          )),
      body: loading
          ? Center(child: Load(200.0))
          : ListView(
              children: [
                SizedBoxResponsive(height: 100),
                Center(
                  child: ContainerResponsive(
                    height: 800,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _profileImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var pickedFile = await showDialog(
                                      context: context,
                                      builder: (context) => MediaPickDialog());
                                  if (pickedFile != null)
                                    setState(() {
                                      _profileImage = pickedFile;
                                      statusType = 'photo';
                                    });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.camera_alt,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                    TextResponsive(
                                      'addPhoto'.tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(height: 20),
                              ContainerResponsive(
                                  width: 50, height: 1.5, color: Colors.white),
                              SizedBoxResponsive(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  var pickedFile = await showDialog(
                                      context: context,
                                      builder: (context) =>
                                          MediaPickDialog(file: 'vid'));
                                  if (pickedFile != null &&
                                      pickedFile.path != '') {
                                    _profileImage = pickedFile;
                                    controller = VideoPlayerController.file(
                                        _profileImage);
                                    vidFunc = controller.initialize();
                                    controller.setLooping(true);
                                    controller.setVolume(1.0);
                                    setState(() {
                                      statusType = "vid";
                                    });
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.videocam,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                    TextResponsive(
                                      'addVideo'.tr(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : statusType == 'photo'
                            ? GestureDetector(
                                onTap: () async {
                                  var pickedFile = await showDialog(
                                      context: context,
                                      builder: (context) => MediaPickDialog());
                                  if (pickedFile != null)
                                    setState(() {
                                      _profileImage = pickedFile;
                                      statusType = 'photo';
                                    });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    _profileImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : statusType == 'vid'
                                ? GestureDetector(
                                    onTap: () async {
                                      var pickedFile = await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              MediaPickDialog(file: 'vid'));
                                      if (pickedFile != null) {
                                        _profileImage = pickedFile;
                                        controller = VideoPlayerController.file(
                                            _profileImage);
                                        vidFunc = controller.initialize();
                                        controller.setLooping(true);
                                        controller.setVolume(1.0);
                                        setState(() {
                                          statusType = "vid";
                                        });
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                            child: VideoPlayer(controller)),
                                        Positioned(
                                          top: 10,
                                          left: 20,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!controller.value.isPlaying) {
                                                controller.play();
                                                state = 'pause';
                                                setState(() {});
                                              } else {
                                                controller.pause();
                                                state = 'play';
                                                setState(() {});
                                              }
                                            },
                                            child: Icon(
                                                state == 'pause'
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ))
                                : Container(),
                  ),
                ),
                SizedBoxResponsive(height: 50),
                Padding(
                  padding: EdgeInsetsResponsive.symmetric(
                      horizontal: 35, vertical: 10),
                  child: TextResponsive('addText'.tr(),
                      style: TextStyle(fontSize: 24, color: Colors.black)),
                ),
                ContainerResponsive(
                    padding: EdgeInsetsResponsive.symmetric(
                        horizontal: 35, vertical: 10),
                    child: TextField(
                      controller: text,
                    )),
                SizedBoxResponsive(height: 150),
                Center(
                    child: GestureDetector(
                  onTap: () {
                    if (_profileImage == null) {
                      Fluttertoast.showToast(
                        msg: 'addPicFirst'.tr(),
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return;
                    } else if (text.text == '' || text.text == null) {
                      Fluttertoast.showToast(
                        msg: 'addTextFirst'.tr(),
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return;
                    } else {
                      addStatus(statusType);
                    }
                  },
                  child: ContainerResponsive(
                      height: 65,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: TextResponsive('confirm'.tr(),
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                      )),
                ))
              ],
            ),
    );
  }
}

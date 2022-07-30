import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mplus_provider/ui/widgets/loading.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:video_trimmer/video_trimmer.dart';

class CropVid extends StatefulWidget {
  final File file;
  const CropVid({Key key, this.file}) : super(key: key);

  @override
  _CropVidState createState() => _CropVidState();
}

Trimmer _trimmer;

double _startValue = 0.0;
double _endValue = 0.0;

bool _isPlaying = false;
bool _saving = false;

class _CropVidState extends State<CropVid> {
  void _saveVid() async {
    setState(() {
      _saving = true;
    });
    await _trimmer
        .saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
    )
        .then((value) {
      setState(() {
        _saving = false;
      });
      Navigator.pop(context, File(value));
    });
  }

  void _loadVideo() async {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();
    _trimmer = Trimmer();
    _loadVideo();
  }

  @override
  void dispose() {
    super.dispose();

    _trimmer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text('cropVid'.tr()),
      ),
      body: _saving
          ? Center(child: Load(200.0))
          : ListView(
              children: [
                SizedBoxResponsive(height: 150),
                ContainerResponsive(
                    height: 700,
                    width: MediaQuery.of(context).size.width,
                    child: VideoViewer(trimmer: _trimmer)),
                SizedBoxResponsive(height: 50),
                ContainerResponsive(
                  width: MediaQuery.of(context).size.width,
                  child: TrimEditor(
                    trimmer: _trimmer,
                    viewerWidth: MediaQuery.of(context).size.width,
                    sideTapSize: 60,
                    maxVideoLength: Duration(seconds: 15),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                SizedBoxResponsive(
                  height: 150,
                ),
                Center(
                    child: GestureDetector(
                  onTap: () {
                    _saveVid();
                  },
                  child: ContainerResponsive(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: TextResponsive(
                        'confirm'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ))
              ],
            ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: _isPlaying
              ? Icon(
                  Icons.pause,
                  size: 20.0,
                  color: Colors.white,
                )
              : Icon(
                  Icons.play_arrow,
                  size: 20.0,
                  color: Colors.white,
                ),
          onPressed: () async {
            bool playbackState = await _trimmer.videPlaybackControl(
              startValue: _startValue,
              endValue: _endValue,
            );
            setState(() {
              _isPlaying = playbackState;
            });
          }),
    );
  }
}

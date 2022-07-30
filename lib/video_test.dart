// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:mplus_provider/globals.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:path_provider/path_provider.dart';

// class Vid extends StatefulWidget {
//   const Vid({Key key}) : super(key: key);

//   @override
//   _VidState createState() => _VidState();
// }

// class _VidState extends State<Vid> {
//   VideoPlayerController controller = VideoPlayerController.network('');
//   Uint8List thumbnail;

//   @override
//   void initState() {
//     getVidThumbnail(baseImageURL + 'customers/video1629843558.');

//     super.initState();
//   }

//   getVidThumbnail(String url) async {
//     try {
//       thumbnail = await VideoThumbnail.thumbnailData(
//         video: url,
//         // thumbnailPath: (await getTemporaryDirectory()).path,
//         imageFormat: ImageFormat.JPEG,
//         maxHeight: 64,
//         quality: 50,
//       );
//     } on Exception catch (e) {
//       print(e);
//     }
//     setState(() {});
//     await Future.delayed(Duration(seconds: 5));
//     controller = VideoPlayerController.network(url)
//       ..initialize().then((value) {
//         setState(() {});
//         controller.setLooping(true);
//         controller.play();
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         body: controller.value.isInitialized
//             ? VideoPlayer(controller)
//             : Center(
//                 child: thumbnail != null
//                     ? Stack(
//                         children: [
//                           Image.memory(
//                             thumbnail,
//                             scale: 1.0,
//                             width: 720,
//                             height: 1500,
//                           ),
//                           Center(
//                             child: CircularProgressIndicator(),
//                           )
//                         ],
//                       )
//                     : CircularProgressIndicator()));
//   }
// }

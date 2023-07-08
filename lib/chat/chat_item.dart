import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mplus_provider/models/chat_model.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

import '../globals.dart';
import '../newChat.dart';

class DeliveryChat extends StatelessWidget {
  final DeliveryChatListItem deliveryChatListItem;

  DeliveryChat({
    this.deliveryChatListItem,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      var _height = cons.maxHeight;
      var _width = cons.maxWidth;
      return GestureDetector(
        onTap: () {
          var to = deliveryChatListItem.threadId.toString()[
                      deliveryChatListItem.threadId.toString().length - 1] ==
                  '1'
              ? 'customer'
              : 'driver';
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        from: 'list',
                        status: '0',
                        targetImage: deliveryChatListItem.image.toString(),
                        to: to,
                        targetName: deliveryChatListItem.name,
                        orderId: deliveryChatListItem.threadId.toString(),
                        targetId: deliveryChatListItem.target,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  color: Colors.white54,
                  offset: Offset.fromDirection(1.5, 5))
            ],
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(
              vertical: _height * .05, horizontal: _width * .035),
          padding: EdgeInsets.symmetric(
              vertical: _height * .115, horizontal: _width * .035),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      baseImageURL + deliveryChatListItem.image.toString()),
                  onBackgroundImageError: (_, stack) =>
                      Image.asset('images/logo.png'),
                ),
                SizedBoxResponsive(width: _width * .055),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _height * .10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(deliveryChatListItem.name),
                      Container(
                        width: 200,
                        child: AutoSizeText(
                          deliveryChatListItem.body.toString() == 'new messge body' ? 'newMessageBody'.tr()  :deliveryChatListItem.body.toString(),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: _height * .10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(fixTime(
                      DateTime.parse(deliveryChatListItem.createdAt), context)),
                  AutoSizeText(
                      fixDate(DateTime.parse(deliveryChatListItem.createdAt))),
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }

  String fixDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String fixTime(DateTime time, BuildContext context) {
    var hour;
    var minute = time.minute;
    var amPm;
    if (shop.Dealer['login_phone'] != null) {
      if (shop.Dealer['login_phone'].substring(0, 4) == '+249') {
        hour = time.hour + 2;
        hour >= 12 ? amPm = 'PM' : amPm = 'AM';
      } else if (shop.Dealer['login_phone'].substring(0, 4) == '+966') {
        hour = time.hour + 3;
        hour >= 12 ? amPm = 'PM' : amPm = 'AM';
      } else if (shop.Dealer['login_phone'].substring(0, 4) == '+968') {
        hour = time.hour + 4;
        hour >= 12 ? amPm = 'PM' : amPm = 'AM';
      }
      if (context.locale == Locale('en')) {
        return '$hour:$minute $amPm';
      } else {
        return '$amPm $hour:$minute';
      }
    } else {
      return '${time.hour}:${time.minute}';
    }
  }
}

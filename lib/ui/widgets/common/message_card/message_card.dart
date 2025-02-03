import 'dart:developer';

import 'package:firebase_chat/services/apis_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../helper/dialogs.dart';
import '../../../../helper/my_date_util.dart';
import '../../../../models/message.dart';
import 'message_card_model.dart';

class MessageCardView extends StatelessWidget {
  final Message message;

  const MessageCardView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageCardModel>.reactive(
      key: UniqueKey(),
      viewModelBuilder: () => MessageCardModel(message),
      builder: (context, viewModel, child) => InkWell(
        onLongPress: () => _showBottomSheet(context, viewModel),
        child: viewModel.isMe
            ? _greenMessage(context, viewModel)
            : _blueMessage(context, viewModel),
      ),
    );
  }

  Widget _blueMessage(BuildContext context, MessageCardModel viewModel) {
    if (message.read.isEmpty) {
      ApisService.updateMessageReadStatus(message);
    }
    final mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                message.type == Type.image ? mq.width * .03 : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: message.type == Type.text
                ? Text(
                    message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
        // Time display logic
      ],
    );
  }

  Widget _greenMessage(BuildContext context, MessageCardModel viewModel) {
    final mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * .04),
            if (message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
            const SizedBox(width: 2),
            Text(
              MyDateUtil.getFormattedTime(context: context, time: message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(
                message.type == Type.image ? mq.width * .03 : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: message.type == Type.text
                ? Text(
                    message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, MessageCardModel viewModel) {
    final mq = MediaQuery.sizeOf(context);
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) =>  ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: 4,
          margin: EdgeInsets.symmetric(
              vertical: mq.height * .015, horizontal: mq.width * .4),
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(8))),
        ),

        message.type == Type.text
            ?
        _OptionItem(
            icon: const Icon(Icons.copy_all_rounded,
                color: Colors.blue, size: 26),
            name: 'Kopyala',
            onTap: (ctx) async {
              await Clipboard.setData(
                  ClipboardData(text: message.msg))
                  .then((value) {
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  Dialogs.showSnackbar(ctx, 'Koypalandı!');
                }
              });
            })
            :
        _OptionItem(
            icon: const Icon(Icons.download_rounded,
                color: Colors.blue, size: 26),
            name: 'Resmi Kaydet',
            onTap: (ctx) async {
              try {
                log('Image Url: ${message.msg}');
                await GallerySaver.saveImage(message.msg,
                    albumName: 'Chat Case APP')
                    .then((success) {
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    if (success != null && success) {
                      Dialogs.showSnackbar(
                          ctx, 'Resim başarıyla kaydedildi!');
                    }
                  }
                });
              } catch (e) {
                log('ErrorWhileSavingImg: $e');
              }
            }),
        if (viewModel.isMe)
          Divider(
            color: Colors.black54,
            endIndent: mq.width * .04,
            indent: mq.width * .04,
          ),

        if (message.type == Type.text && viewModel.isMe)
          _OptionItem(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
              name: 'Mesajı Düzenle',
              onTap: (ctx) {
                if (ctx.mounted) {
                  _showMessageUpdateDialog(ctx);
                }
              }),
        if (viewModel.isMe)
          _OptionItem(
              icon: const Icon(Icons.delete_forever,
                  color: Colors.red, size: 26),
              name: 'Mesajı Sil',
              onTap: (ctx) async {
                await ApisService.deleteMessage(message).then((value) {
                  //for hiding bottom sheet
                  if (ctx.mounted) Navigator.pop(ctx);
                });
              }),
        Divider(
          color: Colors.black54,
          endIndent: mq.width * .04,
          indent: mq.width * .04,
        ),
        _OptionItem(
            icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
            name:
            'İletildi: ${MyDateUtil.getMessageTime(time: message.sent)}',
            onTap: (_) {}),

        _OptionItem(
            icon: const Icon(Icons.remove_red_eye, color: Colors.green),
            name: message.read.isEmpty
                ? 'Görüldü: '
                : 'Görüldü: ${MyDateUtil.getMessageTime(time: message.read)}',
            onTap: (_) {}),
      ],
    ));
  }

  void _showMessageUpdateDialog(final BuildContext ctx) {
    String updatedMsg = message.msg;

    showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: const Row(
            children: [
              Icon(
                Icons.message,
                color: Colors.blue,
                size: 28,
              ),
              Text(' Mesajı Güncelle')
            ],
          ),

          //content
          content: TextFormField(
            initialValue: updatedMsg,
            maxLines: null,
            onChanged: (value) => updatedMsg = value,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )),

            //update button
            MaterialButton(
                onPressed: () {
                  ApisService.updateMessage(message, updatedMsg);
                  //hide alert dialog
                  Navigator.pop(ctx);

                  //for hiding bottom sheet
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Güncelle',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final Function(BuildContext) onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    return InkWell(
        onTap: () => onTap(context),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}

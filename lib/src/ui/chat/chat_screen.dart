import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/models/chat.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/ui/base_widgets.dart';
import 'package:twsl_flutter/src/ui/chat/chat_model.dart';
import 'package:twsl_flutter/src/ui/ui_utils.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatModel(Provider.of(context), Provider.of(context)),
      builder: (context, _) {
        var model = Provider.of<ChatModel>(context, listen: false);
        final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
        model.orderId = arguments['orderId'];
        model.getChatRoomInfo();
        return Directionality(
          textDirection: getTextDirection(context),
          child: Scaffold(
            appBar: AppBar(
              title: Consumer<ChatModel>(builder: (context, data, _) {
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: (data.chatRoomInfo?.imageLink != null
                              ? NetworkImage(data.chatRoomInfo!.imageLink!)
                              : AssetImage("assets/images/empty_profile.png"))
                          as ImageProvider<Object>?,
                      radius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 28),
                    Text(
                      data.chatRoomInfo?.receiverName ?? "",
                      style: TextStyle(color: "454F63".getColor()),
                    ),
                  ],
                );
              }),
            ),
            body: Stack(
              children: [
                Container(
                  height: double.infinity,
                  color: Colors.white,
                  child: Consumer<ChatModel>(
                    builder: (context, data, _) {
                      var messages = data.messages!.reversed.toList();
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        controller: model.scrollController,
                        padding: EdgeInsets.only(
                            bottom: LIST_BOTTOM_CLIP_PADDING, top: 16),
                        itemCount: data.messages!.length,
                        itemBuilder: (context, index) {
                          return itemChat(messages[index], index,
                              data.chatRoomInfo!.receiverName);
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, 19, 16, 24),
                    color: getColorFromHex("F3F3F3"),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: _inputMessage(context, model)),
                        const SizedBox(width: 15),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: "BD2755".getColor(),
                          ),
                          child: InkWell(
                            child: SvgPicture.asset(
                              "assets/icons/send.svg",
                            ),
                            onTap: () {
                              if (model.editTextMessageEdCon.text.isEmpty)
                                return;
                              model.sendMessage();
                              model.editTextMessageEdCon.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget itemChat(ItemChat item, int index, String? receiverName) {
    return Wrap(
      alignment: item.isMyMessage ? WrapAlignment.end : WrapAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(
            item.isMyMessage
                ? EXTRA_HORIZONTAL_PADDING
                : HORIZONTAL_PADDING_FROM_EDGE,
            0,
            item.isMyMessage
                ? HORIZONTAL_PADDING_FROM_EDGE
                : EXTRA_HORIZONTAL_PADDING,
            VERTICAL_PADDING_ITEM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: item.isMyMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              text12And400AndColor(
                "${item.isMyMessage ? "You".localize(context) : receiverName}, ${item.sendTime!.getFormattedDateTimeWithoutDateToday()}",
                "ABABAB",
              ),
              const SizedBox(height: 7),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    item.textMessage ?? "",
                  ),
                ),
                decoration: BoxDecoration(
                  color: item.isMyMessage
                      ? "F3F3F3".getColor()
                      : "E4ECFF".getColor(),
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(item.isMyMessage ? MESSAGE_CORNERS : 0),
                    topRight: Radius.circular(MESSAGE_CORNERS),
                    bottomLeft: Radius.circular(MESSAGE_CORNERS),
                    bottomRight:
                        Radius.circular(item.isMyMessage ? 0 : MESSAGE_CORNERS),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _inputMessage(BuildContext context, ChatModel model) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(EDIT_MESSAGE_CORNERS)),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: EDIT_MESSAGE_PADDING_TEXT),
        child: TextFormField(
          minLines: 1,
          maxLines: 5,
          controller: model.editTextMessageEdCon,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "New message...".localize(context),
          ),
        ),
      ),
    );
  }

  static const EDIT_MESSAGE_CORNERS = 10.0;
  static const EDIT_MESSAGE_PADDING_TEXT = 16.0;
  static const MESSAGE_CORNERS = 16.0;
  static const VERTICAL_PADDING_ITEM = 20.0;
  static const HORIZONTAL_PADDING_FROM_EDGE = 16.0;
  static const EXTRA_HORIZONTAL_PADDING = HORIZONTAL_PADDING_FROM_EDGE + 30.0;
  static const LIST_BOTTOM_CLIP_PADDING = 106.0;
}

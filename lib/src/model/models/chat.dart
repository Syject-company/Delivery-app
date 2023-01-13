class ItemChat {
  String? id;
  String? applicationUserId;
  DateTime? sendTime;
  bool isMyMessage;
  String? textMessage;

  ItemChat(this.id, this.applicationUserId, this.sendTime, this.isMyMessage,
      this.textMessage);

  factory ItemChat.fromMap(Map<String, dynamic> map) => ItemChat(
        map['id'],
        map['applicationUserId'],
        DateTime.tryParse(map['sendTime']),
        map['isMyMessage'] ?? true,
        map['text'],
      );
}

class ChatRoomInfo {
  String? chatRoomId;
  String? receiverName;
  String? receiverId;
  String? imageLink;

  ChatRoomInfo(
      this.chatRoomId, this.receiverName, this.receiverId, this.imageLink);

  factory ChatRoomInfo.fromMap(Map<String, dynamic> map) => ChatRoomInfo(
        map['chatRoomId'],
        map['receiverName'],
        map['receiverId'],
        map['imageLink'],
      );
}

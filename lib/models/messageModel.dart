class Message2 {
  Message2({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sentTime,
    required this.isSent,
    required this.sendingTime,
  });

  late final String toId;
  late final String msg;
  late final bool read;
  late final String fromId;
  late final String sentTime;
  late final Type type;
  late final bool isSent;
  late final String sendingTime;

  Message2.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'];
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
    sentTime = json['sentTime'].toString();
    isSent = json['isSent'];
    sendingTime = json['sendingTime'].toString();
    
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sentTime'] = sentTime;
    data['isSent'] = isSent;
    data['sendingTime'] = sendingTime;
    return data;
  }
}

enum Type { text, image ,audio}
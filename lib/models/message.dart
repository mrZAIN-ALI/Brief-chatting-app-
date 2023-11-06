class Messages {
  Messages({
    required this.toId,
    required this.msg,
    required this.readTime,
    required this.sentTime,
    required this.typeOfMsg,
    required this.fromId,
  });
  late final String toId;
  late final String msg;
  late final String readTime;
  late final String sentTime;
  late final msgType typeOfMsg;
  late final String fromId;
  
  Messages.fromJson(Map<String, dynamic> json){
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    readTime = json['readTime'].toString();
    sentTime = json['sentTime'].toString();
    typeOfMsg = json['typeOfMsg'] == msgType.text.toString() ? msgType.text : msgType.image;
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['toId'] = toId;
    _data['msg'] = msg;
    _data['readTime'] = readTime;
    _data['sentTime'] = sentTime;
    _data['typeOfMsg'] = typeOfMsg.toString();
    _data['fromId'] = fromId;
    return _data;
  }
}
enum msgType {text,image}
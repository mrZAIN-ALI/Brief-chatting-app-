class chatUUser_Info {
  chatUUser_Info({
    required this.image,
    required this.lastActive,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.id,
    required this.pushToken,
    required this.email,
    required this.isOnline,

  });
  late  String image;
  late  String lastActive;
  late  String name;
  late  String about;
  late  String createdAt;
  late  String id;
  String pushToken="default";
  late  String email;
  late  bool isOnline;

  
   chatUUser_Info.mapJsonToModelObject(Map<String, dynamic> json){
    image = json['image'];
    lastActive = json['lastActive'];
    name = json['name'];
    about = json['about'];
    createdAt = json['created_at'];
    id = json['id'];
    pushToken = json['push_token'];
    email = json['email'];
    isOnline = json['isOnline'];
  }

   Map<String, dynamic> getJsonFormat() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['lastActive'] = lastActive;
    _data['name'] = name;
    _data['about'] = about;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    _data['push_token'] = pushToken;
    _data['email'] = email;
    _data['isOnline'] = isOnline;
    return _data;
  }

  // static String getPushToken() {
  //   return pushToken;
  // }
}
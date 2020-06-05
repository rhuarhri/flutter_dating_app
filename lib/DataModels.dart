import 'dart:convert';

UserInfo userFromJson(String str) {
  final jsonData = json.decode(str);
  return UserInfo.fromMap(jsonData);
}

String userToJson(UserInfo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class UserInfo
{
  int id;

  String onlineLocation;
  //online location refers to the id of the firebase document that contains the user's
  //information. Having it stored on the app make it easy to find in the future.

  int age;
  String lookingFor;
  //These two values will be needed every time the app searches for people
  //and are stored in the internal database because they are used so frequently.

  UserInfo({
    this.id,
    this.onlineLocation,
  }
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "online_location": onlineLocation,
  };

  factory UserInfo.fromMap(Map<String, dynamic> json) => new UserInfo(
    id: json["id"],
    onlineLocation: json["online_location"],
  );

}

DescriptionValue descriptionValuesFromJson(String str) {
  final jsonData = json.decode(str);
  return DescriptionValue.fromMap(jsonData);
}

String descriptionValuesToJson(DescriptionValue data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class DescriptionValue
{
  int id;

  String name;
  //name of the description value

  double sentiment;
  //A value to that show how much someone like or dislikes the description value


  DescriptionValue({
    this.id,
    this.name,
    this.sentiment,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "sentiment": sentiment,
  };

  factory DescriptionValue.fromMap(Map<String, dynamic> json) => new DescriptionValue(
    id: json["id"],
    name: json["name"],
    sentiment: json["sentiment"],
  );
}


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

  String descriptionStyle;
  //this will either be formal or informal and represents how someone has written a description and not what is in it.

  //location
  double latitude;
  double longitude;

  UserInfo({
    this.id,
    this.onlineLocation,
    this.lookingFor,
    this.descriptionStyle,
    this.latitude,
    this.longitude,
  }
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "online_location": onlineLocation,
    "lookingFor": lookingFor,
    "descriptionStyle": descriptionStyle,
    "latitude": latitude,
    "longitude": longitude,
  };

  factory UserInfo.fromMap(Map<String, dynamic> json) => new UserInfo(
    id: json["id"],
    onlineLocation: json["online_location"],
    lookingFor: json["lookingFor"],
    descriptionStyle: json["descriptionStyle"],
    latitude: json["latitude"],
    longitude: json["longitude"],
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


History historyFromJson(String str) {
  final jsonData = json.decode(str);
  return History.fromMap(jsonData);
}

String historyToJson(History data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class History
{

  History({this.id, this.lastID});

  int id;

  //The app will have access to a database with a large number users. It would a bad idea to get all the
  //information from the database so the app gets it in parts. So once it has finished with one part
  //it moves on to a new one.
  //The lastId value marks where the next database chunk starts so it can be retrieve when the user reopen
  //the app.
  String lastID;

  Map<String, dynamic> toMap() => {
    "id": id,
    "lastId": lastID,
  };

  factory History.fromMap(Map<String, dynamic> json) => new History(
    id: json["id"],
    lastID: json["lastId"],
  );
}

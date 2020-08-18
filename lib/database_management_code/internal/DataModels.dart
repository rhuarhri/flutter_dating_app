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

  int minAge;
  int maxAge;
  String lookingFor;
  String gender;
  //These two values will be needed every time the app searches for people
  //and are stored in the internal database because they are used so frequently.

  String descriptionStyle;
  //this will either be formal or informal and represents how someone has written a description and not what is in it.

  //location
  double distance;

  int accuracy;

  String faceShape;

  UserInfo({
    this.id,
    this.onlineLocation,
    this.minAge,
    this.maxAge,
    this.lookingFor,
    this.gender,
    this.descriptionStyle,
    this.distance,
    this.accuracy,
    this.faceShape,
  }
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "online_location": onlineLocation,
    "minAge":minAge,
    "maxAge":maxAge,
    "lookingFor": lookingFor,
    "gender":gender,
    "descriptionStyle": descriptionStyle,
    "distance":distance,
    "accuracy":accuracy,
    "faceShape":faceShape,
  };

  factory UserInfo.fromMap(Map<String, dynamic> json) => new UserInfo(
    id: json["id"],
    onlineLocation: json["online_location"],
    minAge: json["minAge"],
    maxAge: json["maxAge"],
    lookingFor: json["lookingFor"],
    gender: json["gender"],
    descriptionStyle: json["descriptionStyle"],
    distance: json["distance"],
    accuracy: json["accuracy"],
    faceShape: json["faceShape"],
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

  int matchable;
  //Matchable is a bool value (but is an int since SQL has no bool type)
  //
  //as a bool type 1 is true 0 is false.
  //
  //It is used to determine if a value can be matched. How in the online database
  //there is a list of all the likes and hates people have. If the description value
  //matches anything in that list then it is matchable if not then it can't be matched.
  //This value exists as getting ride of the description value might be a bad idea
  //as a match for this value may appear in the future.

  int interestScore;
  //this allows the app to know how important a description value is and if that
  //value has a low interest score then it is deleted. The interest score comes from
  //the people the user matches with. If the user grades someone highly then that person's
  //likes become the user's likes. If any of these new likes gets a high enough interest
  // then the app will consider it when searching for other people. This should allow the
  // app to always have update information and adapt over time.


  DescriptionValue({
    this.id,
    this.name,
    this.sentiment,
    this.matchable,
    this.interestScore,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "sentiment": sentiment,
    "matchable": matchable,
    "interestScore": interestScore,
  };

  factory DescriptionValue.fromMap(Map<String, dynamic> json) => new DescriptionValue(
    id: json["id"],
    name: json["name"],
    sentiment: json["sentiment"],
    matchable: json["matchable"],
    interestScore: json["interestScore"],
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

Blocked blockedFromJson(String str) {
  final jsonData = json.decode(str);
  return Blocked.fromMap(jsonData);
}

String blockedToJson(Blocked data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Blocked
{
  //This will be all ids of the account the user does not want to talk to

  int id;
  String blockedUserId;

  Blocked({this.id, this.blockedUserId});

  Map<String, dynamic> toMap() => {
    "id": id,
    "blockedId": blockedUserId,
  };

  factory Blocked.fromMap(Map<String, dynamic> json) => new Blocked(
    id: json["id"],
    blockedUserId: json["blockedId"],
  );

}

Matched matchedFromJson(String str) {
  final jsonData = json.decode(str);
  return Matched.fromMap(jsonData);
}

String matchedToJson(Matched data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Matched
{
  int id;
  String accountId;
  int rating;
  int isTalkingTo;
  String name;
  String imageLocation;
  String description;

  Matched({this.id, this.accountId,
    this.rating, this.isTalkingTo, this.name, this.imageLocation, this.description});

  Map<String, dynamic> toMap() => {
    "id": id,
    "accountId": accountId,
    "rating": rating,
    "isTalkingTo": isTalkingTo,
    "name": name,
    "image": imageLocation,
    "description": description,
  };

  factory Matched.fromMap(Map<String, dynamic> json) => new Matched(
    id: json["id"],
    accountId: json["accountId"],
    rating: json["rating"],
    isTalkingTo: json["isTalkingTo"],
    name: json["name"],
    imageLocation: json["image"],
    description: json["description"],
  );
}

Messages messageFromJson(String str) {
  final jsonData = json.decode(str);
  return Messages.fromMap(jsonData);
}

String messagesToJson(Messages data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

/*
This class represents the number of messages the user can send. They can get more
through a reward ad.
 */
class Messages
{
  int id;
  int messageAmount;

  Messages({this.id, this.messageAmount});

  Map<String, dynamic> toMap() => {
    "id": id,
    "messageAmount": messageAmount,
  };

  factory Messages.fromMap(Map<String, dynamic> json) => new Messages(
    id: json["id"],
    messageAmount: json["messageAmount"],
  );

}

Messages categoryFromJson(String str) {
  final jsonData = json.decode(str);
  return Messages.fromMap(jsonData);
}

String categoryToJson(Messages data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

/*
This class represents the number of messages the user can send. They can get more
through a reward ad.
 */
class Category
{
  int id;
  String name;

  Category({this.id, this.name});

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };

  factory Category.fromMap(Map<String, dynamic> json) => new Category(
    id: json["id"],
    name: json["name"],
  );

}

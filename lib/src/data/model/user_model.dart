class UserModel {
  String displayName;
  String photoUrl;
  String userId;

  UserModel({this.displayName, this.photoUrl, this.userId});

  factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
      displayName: json["displayName"], photoUrl: json["photoUrl"], userId: json["user_id"]);

  Map<String, dynamic> toJson() =>
      {"displayName": displayName, "photoUrl": photoUrl, "user_id": userId};
}

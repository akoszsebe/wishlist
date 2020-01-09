class UserModel {
  String displayName;
  String photoUrl;
  String email;

  UserModel({this.displayName, this.photoUrl, this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
      displayName: json["displayName"], photoUrl: json["photoUrl"], email: json["email"]);

  Map<String, dynamic> toJson() =>
      {"displayName": displayName, "photoUrl": photoUrl, "email": email};
}

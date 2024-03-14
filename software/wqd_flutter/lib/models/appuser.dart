class AppUser {
  final String id;
  final String fullName;
  final String photoUrl;
  final String email;
  final DateTime regTime;

  AppUser({
    required this.id,
    required this.fullName,
    required this.photoUrl,
    required this.email,
    required this.regTime,
  });

  AppUser.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? "",
        fullName = data['fullName'] ?? "nil",
        photoUrl = data['photoUrl'] ?? "nil",
        email = data['email'] ?? "nil",
        regTime =
            data['regTime'] != null ? data['regTime'].toDate() : DateTime.now();

  Map<String, dynamic> toJson(keyword) {
    Map<String, dynamic> map = {
      'id': id,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'keyword': keyword,
      'email': email,
      'regTime': regTime,
    };
    // if (imgString != null) map['imgString'] = imgString!;
    return map;
  }
}

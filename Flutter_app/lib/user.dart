class User {
  int id;
  String username;
  String password;
  bool isAdmin;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      isAdmin: json['admin'] as bool,
    );
  }


}

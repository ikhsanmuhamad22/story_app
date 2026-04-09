import 'dart:convert';

class User {
  String? email;
  String? password;
  String? token;

  User({this.email, this.password, this.token});

  @override
  String toString() =>
      'User(email: $email, password: $password, token: $token)';

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password, 'token': token};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      token: map['token'],
    );
  }
  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class LoginResponse {
  bool error;
  String message;
  LoginResult loginResult;

  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    error: json["error"],
    message: json["message"],
    loginResult: LoginResult.fromJson(json["loginResult"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "loginResult": loginResult.toJson(),
  };
}

class LoginResult {
  String userId;
  String name;
  String token;

  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
    userId: json["userId"],
    name: json["name"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "token": token,
  };
}

class RegisterResponse {
  bool error;
  String message;

  RegisterResponse({required this.error, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(error: json["error"], message: json["message"]);

  Map<String, dynamic> toJson() => {"error": error, "message": message};
}

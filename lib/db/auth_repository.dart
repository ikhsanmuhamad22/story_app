import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/user.dart';

class AuthRepository {
  final String stateKey = "state";
  final String userKey = "user";
  final String tokenKey = "token";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  Future<bool> saveUser(User user) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final jsonString = preferences.getString(userKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    User? user;
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      user = User.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }

  Future<bool> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getString(tokenKey);
  }

  Future<bool> deleteToken() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(tokenKey, "");
  }
}

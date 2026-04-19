import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/add_story_response.dart';
import 'package:story_app/model/login_response.dart';
import 'package:story_app/model/register_response.dart';
import 'package:story_app/model/story_response.dart';

class ApiServices {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1/';

  Future<String?> _getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('token');
  }

  Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<StoryResponse> getStories(int? size, int? page) async {
    final token = await _getToken();
    final uri = Uri.parse('${baseUrl}stories?page=$page&size=$size&location=0');
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load story list');
    }
  }

  Future<StoryResponse> getStoryDetail(String id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}detail/$id'),
      headers: {
        "Content-Type": "application/json",
        'authorization': 'Bearer ${await _getToken()}',
      },
    );
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<AddStoryResponse> addStory(
    String description,
    File photoFile,
    double? lat,
    double? lon,
  ) async {
    final token = await _getToken();
    final uri = Uri.parse('${baseUrl}stories');

    var request = http.MultipartRequest('POST', uri);
    request.headers['authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    request.files.add(
      await http.MultipartFile.fromPath('photo', photoFile.path),
    );
    request.fields['lat'] = lat!.toString();
    request.fields['lon'] = lon!.toString();

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddStoryResponse.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to add story');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/model/auth_response.dart';
import 'package:story_app/model/story_response.dart';

class ApiServices {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1/';

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

  Future<StoryResponse> getStory() async {
    final response = await http.get(Uri.parse('${baseUrl}list'));
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant list');
    }
  }

  Future<StoryResponse> getStoryDetail(String id) async {
    final response = await http.get(Uri.parse('${baseUrl}detail/$id'));
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  // Future<AddReviewResponse> addReviewRestaurant(
  //   String restaurantId,
  //   String name,
  //   String review,
  // ) async {
  //   final response = await http.post(
  //     Uri.parse('${baseUrl}review'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"id": restaurantId, "name": name, "review": review}),
  //   );
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return AddReviewResponse.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed add review');
  //   }
  // }
}

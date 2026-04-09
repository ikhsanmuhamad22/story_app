import 'package:flutter/material.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/service/api_service.dart';

class StoryProvider extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();

  StoryProvider();

  StoryResponse _resultState = StoryResponse(
    error: false,
    message: '',
    listStory: [],
  );
  StoryResponse get resultState => _resultState;

  Future<void> fetchStories() async {
    _resultState = StoryResponse(error: false, message: '', listStory: []);
    notifyListeners();

    try {
      final storyResponse = await _apiServices.getStories();
      _resultState = storyResponse;
      notifyListeners();
    } catch (e) {
      _resultState = StoryResponse(
        error: true,
        message: 'failed to fetch data',
        listStory: [],
      );
      notifyListeners();
    }

    notifyListeners();
  }
}

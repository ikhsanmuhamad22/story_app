import 'dart:io';

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

  bool _isLoadingUpload = false;
  bool get isLoadingUpload => _isLoadingUpload;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  int pageItems = 1;
  int sizeItems = 10;

  Future<void> fetchStories({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      pageItems = 1;
      _hasMore = true;
      _resultState = StoryResponse(error: false, message: '', listStory: []);
      notifyListeners();
    }
    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final storyResponse = await _apiServices.getStories(sizeItems, pageItems);
      if (pageItems == 1) {
        _resultState = storyResponse;
      } else {
        _resultState = StoryResponse(
          error: storyResponse.error,
          message: storyResponse.message,
          listStory: [..._resultState.listStory, ...storyResponse.listStory],
        );
      }

      _hasMore = storyResponse.listStory.length == sizeItems;
      if (_hasMore) pageItems++;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resultState = StoryResponse(
        error: true,
        message: 'failed to fetch data',
        listStory: _resultState.listStory,
      );
      notifyListeners();
    }
  }

  Future<bool> uploadStory(String description, File photoFile) async {
    _isLoadingUpload = true;
    notifyListeners();

    try {
      await _apiServices.addStory(description, photoFile);
      await fetchStories();
      _isLoadingUpload = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoadingUpload = false;
      notifyListeners();
      rethrow;
    }
  }
}

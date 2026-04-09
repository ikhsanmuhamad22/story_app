import 'package:flutter/material.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/model/auth_response.dart';
import 'package:story_app/service/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiServices _apiServices = ApiServices();

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;

  Future<LoginResponse> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      final response = await _apiServices.login(email, password);
      await authRepository.login();
      await authRepository.saveUser(User(email: email, password: password));
      await authRepository.saveToken(response.loginResult.token);
      isLoggedIn = await authRepository.isLoggedIn();
      return response;
    } finally {
      isLoadingLogin = false;
      notifyListeners();
    }
  }

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    isLoadingRegister = true;
    notifyListeners();

    try {
      final response = await _apiServices.register(name, email, password);
      if (!response.error) {
        await authRepository.saveUser(User(email: email, password: password));
      }
      return response;
    } finally {
      isLoadingRegister = false;
      notifyListeners();
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
      await authRepository.deleteToken();
    }
    isLoggedIn = await authRepository.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();
    return !isLoggedIn;
  }

  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();
    final userState = await authRepository.saveUser(user);
    isLoadingRegister = false;
    notifyListeners();
    return userState;
  }
}

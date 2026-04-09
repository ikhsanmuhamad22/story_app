import 'package:flutter/material.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/ui/home_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/signin_page.dart';
import 'package:story_app/ui/splash_page.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<void> _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  void showRegisterPage() {
    isRegister = true;
    notifyListeners();
  }

  void showLoginPage() {
    if (isRegister) {
      isRegister = false;
      notifyListeners();
    }
  }

  void onLoginSuccess() {
    isLoggedIn = true;
    notifyListeners();
  }

  void onRegisterSuccess() {
    isRegister = false;
    notifyListeners();
  }

  void onLogout() {
    isLoggedIn = false;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      // ignore: deprecated_member_use
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (isRegister == true) {
          isRegister = false;
          notifyListeners();
        }
        return true;
      },
    );
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashScreen"), child: SplashPage()),
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: LoginPage(
        onLoginSuccess: onLoginSuccess,
        onSignUpPressed: showRegisterPage,
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("SigninPage"),
        child: SigninPage(
          onRegisterSuccess: onRegisterSuccess,
          onBackToLogin: showLoginPage,
        ),
      ),
  ];

  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey("HomePage"),
      child: HomePage(routerDelegate: this),
    ),
  ];

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}

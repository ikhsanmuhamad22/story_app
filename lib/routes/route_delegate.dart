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

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
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
      onDidRemovePage: (page) {
        if (page.key == const ValueKey("SigninPage")) {
          isRegister = false;
          notifyListeners();
        }
      },
    );
  }

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey("SplashScreen"), child: SplashPage()),
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(key: const ValueKey("LoginPage"), child: LoginPage()),
    if (isRegister == true)
      MaterialPage(key: const ValueKey("SigninPage"), child: SigninPage()),
  ];
  List<Page> get _loggedInStack => [
    MaterialPage(key: const ValueKey("HomePage"), child: HomePage()),
  ];

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}

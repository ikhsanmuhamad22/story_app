import 'package:flutter/material.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/signin_page.dart';
import 'package:story_app/ui/splash_page.dart';
import 'package:story_app/ui/story_page.dart';

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
  ListStory? selectedStory;
  bool isAddingStory = false;

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

  void showStoryDetail(ListStory story) {
    selectedStory = story;
    notifyListeners();
  }

  void backToHome() {
    selectedStory = null;
    notifyListeners();
  }

  void showAddStoryPage() {
    isAddingStory = true;
    notifyListeners();
  }

  void backFromAddStory() {
    isAddingStory = false;
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
        if (isAddingStory) {
          isAddingStory = false;
          notifyListeners();
        } else if (selectedStory != null) {
          selectedStory = null;
          notifyListeners();
        } else if (isRegister == true) {
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
      key: const ValueKey("StoryPage"),
      child: StoryPage(routerDelegate: this),
    ),
    if (isAddingStory == true)
      MaterialPage(
        key: const ValueKey("AddStoryPage"),
        child: AddStoryPage(onBack: backFromAddStory),
      ),
    if (selectedStory != null && !isAddingStory)
      MaterialPage(
        key: ValueKey("DetailStoryPage-${selectedStory!.id}"),
        child: DetailStoryPage(story: selectedStory!, onBack: backToHome),
      ),
  ];

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}

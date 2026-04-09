import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes/route_delegate.dart';

void main() {
  final authRepository = AuthRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => StoryProvider()),
      ],
      child: MyApp(authRepository: authRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 00, 82, 204),
        ),
      ),
      home: Router(routerDelegate: MyRouterDelegate(authRepository)),
    );
  }
}

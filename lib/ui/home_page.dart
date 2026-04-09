import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes/route_delegate.dart';

class HomePage extends StatefulWidget {
  final MyRouterDelegate routerDelegate;

  const HomePage({super.key, required this.routerDelegate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryProvider>().fetchStories();
    });
  }

  void _handleLogout() async {
    final authProvider = context.read<AuthProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await authProvider.logout();
      widget.routerDelegate.onLogout();
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer(
        builder: (context, StoryProvider storyProvider, _) {
          if (storyProvider.resultState.error) {
            return Center(child: Text(storyProvider.resultState.message));
          } else if (storyProvider.resultState.listStory.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: storyProvider.resultState.listStory.length,
              itemBuilder: (context, index) {
                final story = storyProvider.resultState.listStory[index];
                return ListTile(
                  title: Text(story.name),
                  subtitle: Text(story.description),
                );
              },
            );
          }
        },
      ),
    );
  }
}

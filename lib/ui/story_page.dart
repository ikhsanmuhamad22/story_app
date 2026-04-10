import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes/route_delegate.dart';
import 'package:story_app/utils/format_date.dart';

class StoryPage extends StatefulWidget {
  final MyRouterDelegate routerDelegate;

  const StoryPage({super.key, required this.routerDelegate});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
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
        title: const Text('All Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => widget.routerDelegate.showAddStoryPage(),
            tooltip: 'Add Story',
          ),
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
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: storyProvider.resultState.listStory.length,
                      itemBuilder: (context, index) {
                        final story =
                            storyProvider.resultState.listStory[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: GestureDetector(
                            onTap: () =>
                                widget.routerDelegate.showStoryDetail(story),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  story.photoUrl,
                                  fit: BoxFit.cover,
                                ),
                                ListTile(
                                  title: Text(story.name),
                                  trailing: Text(
                                    formatDate(story.createdAt.toString()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

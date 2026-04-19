import 'package:flutter/material.dart';
import 'package:story_app/model/list_story.dart';
import 'package:story_app/routes/route_delegate.dart';
import 'package:story_app/utils/format_date.dart';

class DetailStoryPage extends StatelessWidget {
  const DetailStoryPage({
    super.key,
    required this.story,
    required this.onBack,
    required this.routerDelegate,
  });

  final ListStory story;
  final VoidCallback onBack;
  final MyRouterDelegate routerDelegate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              story.photoUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  story.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton(
                  onPressed: () =>
                      routerDelegate.showMapsPage(story.lon, story.lat),
                  child: Text('see location'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Created: ${formatDate(story.createdAt.toString())}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              story.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

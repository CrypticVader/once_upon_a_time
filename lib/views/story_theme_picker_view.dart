import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';
import 'package:once_upon_a_time/views/main_view.dart';

class StoryThemePickerView extends StatefulWidget {
  const StoryThemePickerView({
    super.key,
    required this.selectedCourse,
  });

  final String selectedCourse;

  @override
  State<StoryThemePickerView> createState() => _StoryThemePickerViewState();
}

class _StoryThemePickerViewState extends State<StoryThemePickerView> {
  final List themeNameList = [
    'Underwater',
    'Fantasy',
    'Space',
    'Sci-Fi',
  ];
  final List themeArtList = [
    'assets/images/underwater.jpeg',
    'assets/images/fantasy.jpeg',
    'assets/images/space.jpeg',
    'assets/images/scifi.jpeg',
  ];

  Future<void> onSelectStoryTheme({required String storyTheme}) async {
    await FirestoreService().addCourse(
      courseName: widget.selectedCourse,
      theme: storyTheme,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const MainView();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lets pick a theme'),
      ),
      body: ListView.separated(
        itemCount: 4,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => onSelectStoryTheme(storyTheme: themeNameList[index]),
            tileColor: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            title: Image.asset(themeArtList[index]),
            subtitle: Text(
              themeNameList[index],
              style: const TextStyle(
                fontSize: 32,
                fontVariations: <FontVariation>[FontVariation('wght', 700)],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 16.0,
          );
        },
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';
import 'package:once_upon_a_time/views/dashboard_view.dart';

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

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) {
          return const DashboardView();
        },
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lets pick a theme',
          style: TextStyle(
            fontVariations: <FontVariation>[FontVariation('wght', 400)],
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: 4,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            onTap: () => onSelectStoryTheme(storyTheme: themeNameList[index]),
            tileColor: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            title: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(themeArtList[index]),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(
                themeNameList[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontVariations: <FontVariation>[FontVariation('wght', 700)],
                ),
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

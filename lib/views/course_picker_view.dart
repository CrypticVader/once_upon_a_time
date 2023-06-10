import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/views/story_theme_picker_view.dart';

class CoursePickerView extends StatefulWidget {
  const CoursePickerView({super.key});

  @override
  State<CoursePickerView> createState() => _CoursePickerViewState();
}

class _CoursePickerViewState extends State<CoursePickerView> {
  final courseNameList = [
    'Maths',
    'Programming',
    'Science',
    'Language',
  ];
  final courseArtList = [
    'assets/images/maths.jpeg',
    'assets/images/programming.jpeg',
    'assets/images/science.jpeg',
    'assets/images/language.jpeg',
  ];

  void onSelectCourse({required String courseName}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return StoryThemePickerView(selectedCourse: courseName,);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lets pick a course'),
      ),
      body: ListView.separated(
        itemCount: 4,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => onSelectCourse(courseName: courseNameList[index]),
            tileColor: Theme.of(context).colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            title: Image.asset(courseArtList[index]),
            subtitle: Text(
              courseNameList[index],
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

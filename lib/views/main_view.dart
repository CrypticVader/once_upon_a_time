import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';
import 'package:once_upon_a_time/services/preference_service.dart';
import 'package:once_upon_a_time/views/course_picker_view.dart';
import 'package:once_upon_a_time/views/leaderboard_view.dart';
import 'package:once_upon_a_time/views/story_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final String? userId = AppPreferenceService().getUserId();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getMainViewData,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (snapshot.hasData) {
              final score = snapshot.data!['score'];
              final courseData = snapshot.data!['courses'];

              return Scaffold(
                bottomNavigationBar: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  child: Container(
                    height: 56.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.book_rounded),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.leaderboard_rounded),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                appBar: AppBar(
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: Image.asset(
                      AppPreferenceService().getUserAvatar(),
                      height: 56,
                      width: 56,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        'Hello ${userId ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontVariations: <FontVariation>[
                            FontVariation('wght', 400)
                          ],
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.diamond_rounded),
                            Text(
                              score.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontVariations: <FontVariation>[
                                  FontVariation('wght', 400)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'You have been on this path for the last 7 days!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontVariations: <FontVariation>[
                                    FontVariation('wght', 400)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CoursePickerView(),
                    ),
                  ),
                  label: const Text(
                    'New course',
                    style: TextStyle(
                      fontSize: 18,
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 400)
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                ),
                body: (_selectedIndex == 0)?Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 32.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var course in courseData)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StoryView(
                                      courseName: course[0],
                                      themeName: course[1],
                                    ),
                                  ),
                                );
                              },
                              tileColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              title: Text(
                                course[0],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontVariations: <FontVariation>[
                                    FontVariation('wght', 600)
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                course[1],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontVariations: <FontVariation>[
                                    FontVariation('wght', 300)
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ):LeaderboardView(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}

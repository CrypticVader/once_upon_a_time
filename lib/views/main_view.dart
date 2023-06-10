import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';
import 'package:once_upon_a_time/services/preference_service.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final String? userId = AppPreferenceService().getUserId();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirestoreService().getActiveUserCourses(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            case ConnectionState.active:
            case ConnectionState.waiting:
              if (snapshot.hasData) {
                final courseData = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            child: Image.asset(
                              AppPreferenceService().getUserAvatar(),
                              height: 56,
                              width: 56,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.diamond_rounded),
                                Text(
                                  '125',
                                  style: TextStyle(
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
                      const SizedBox(
                        height: 16.0,
                      ),
                      Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
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
                      const SizedBox(
                        height: 16.0,
                      ),
                      for (var course in courseData)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            onTap: () {},
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
      ),
    );
  }
}
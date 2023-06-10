import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/constants/maths_fantasy_story.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';

class StoryView extends StatefulWidget {
  const StoryView({
    super.key,
    required this.courseName,
    required this.themeName,
  });

  final String courseName;
  final String themeName;

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  final int storyLength = mathsFantasyStory.length;
  int storyProgress = 1;
  int? correctAnswer;

  int? get submittedAnswer => int.parse(answerFieldController.text);
  late final TextEditingController answerFieldController;

  @override
  void initState() {
    answerFieldController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (storyProgress <= storyLength)
        ? FutureBuilder(
            future: FirestoreService().getStoryViewData(
              courseName: widget.courseName,
              themeName: widget.themeName,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  if (snapshot.hasData) {
                    final Map storyData = snapshot.data!;
                    final int userScore = storyData['score'];
                    storyProgress = storyData['progress'];

                    return Scaffold(
                      appBar: AppBar(
                        leading: null,
                        title: Row(
                          children: [
                            Text(
                              '${widget.courseName}, ${widget.themeName}',
                              style: const TextStyle(
                                fontSize: 22,
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
                              child: Row(
                                children: [
                                  const Icon(Icons.scoreboard_rounded),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    userScore.toString(),
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
                      ),
                      floatingActionButton: ((storyProgress + 1) % 2 != 0)
                          ? FloatingActionButton.extended(
                              onPressed: () async {
                                if (submittedAnswer == null) {
                                  return;
                                } else {
                                  if (submittedAnswer == correctAnswer) {
                                    answerFieldController.text = '';
                                    if (storyProgress <= storyLength) {
                                      setState(
                                        () async {
                                          await FirestoreService()
                                              .setProgress(++storyProgress);
                                          await FirestoreService()
                                              .incrementScoreBy(5);
                                          setState(() {});
                                        },
                                      );
                                      if (mathsFantasyStory[storyProgress][0] ==
                                          'story') {}
                                    }
                                  } else {
                                    int newScore = userScore - 1;
                                    if (newScore >= 0) {
                                      await FirestoreService()
                                          .incrementScoreBy(-1);
                                    }
                                    setState(() {});
                                  }
                                }
                              },
                              label: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontVariations: <FontVariation>[
                                    FontVariation('wght', 400)
                                  ],
                                ),
                              ),
                              icon: const Icon(Icons.question_answer_rounded),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                            )
                          : FloatingActionButton.extended(
                              onPressed: () async {
                                if (storyProgress <= storyLength) {
                                  await FirestoreService()
                                      .setProgress(++storyProgress);
                                  setState(() {});
                                }
                              },
                              label: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontVariations: <FontVariation>[
                                    FontVariation('wght', 400)
                                  ],
                                ),
                              ),
                              icon: const Icon(Icons.navigate_next_rounded),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                      body: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.separated(
                          itemCount: storyProgress,
                          itemBuilder: (context, index) {
                            if (mathsFantasyStory[index][0] == 'story') {
                              final String storyPart =
                                  mathsFantasyStory[index][1] as String;

                              return ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                tileColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                title: Text(
                                  storyPart,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontVariations: <FontVariation>[
                                      FontVariation('wght', 400)
                                    ],
                                  ),
                                ),
                              );
                            } else if (mathsFantasyStory[index][0] ==
                                'problem') {
                              final String problemStatement =
                                  mathsFantasyStory[index][1] as String;
                              correctAnswer =
                                  mathsFantasyStory[index][2] as int;

                              return ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                tileColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                leading:
                                    const Icon(Icons.question_mark_rounded),
                                title: Text(
                                  problemStatement,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontVariations: <FontVariation>[
                                      FontVariation('wght', 400)
                                    ],
                                  ),
                                ),
                                subtitle: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: answerFieldController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.mark_chat_read_rounded),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .tertiary
                                        .withAlpha(100),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Text(
                                  'YOU SHOULD NOT BE SEEING THIS!!');
                            }
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16.0,
                            );
                          },
                        ),
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
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Congrats! You have finished this course.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 600)
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 18,
                        fontVariations: <FontVariation>[
                          FontVariation('wght', 400)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

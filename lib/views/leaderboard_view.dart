import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirestoreService().getLeaderboardViewData,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.done:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final leaderboardData = snapshot.data!.toList();
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        leaderboardData[index][0],
                        style: const TextStyle(
                          fontSize: 20,
                          fontVariations: <FontVariation>[
                            FontVariation('wght', 500)
                          ],
                        ),
                      ),
                      trailing: Text(
                        leaderboardData[index][1],
                        style: const TextStyle(
                          fontSize: 20,
                          fontVariations: <FontVariation>[
                            FontVariation('wght', 500)
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 12.0,
                    );
                  },
                  itemCount: leaderboardData.length,
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

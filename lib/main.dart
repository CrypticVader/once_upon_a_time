import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';
import 'package:once_upon_a_time/services/preference_service.dart';
import 'package:once_upon_a_time/views/dashboard_view.dart';
import 'package:once_upon_a_time/views/user_avatar_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirestoreService().initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Once upon a time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'JosefinSans',
        fontFamilyFallback: const ['Roboto'],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        splashFactory:
            (kIsWeb) ? InkRipple.splashFactory : InkSparkle.splashFactory,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'JosefinSans',
        fontFamilyFallback: const ['Roboto'],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        splashFactory:
            (kIsWeb) ? InkRipple.splashFactory : InkSparkle.splashFactory,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _userIdTextController;

  @override
  void initState() {
    _userIdTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userIdTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppPreferenceService().initPrefs(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
              if (AppPreferenceService().userNull) {
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  body: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: 0.6,
                          child: Image.asset('assets/images/home_bg.png'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 32,
                            ),
                            Text(
                              'Once',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 44,
                                fontVariations: const <FontVariation>[
                                  FontVariation('wght', 900)
                                ],
                              ),
                            ),
                            Text(
                              'upon',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 44,
                                  fontVariations: const <FontVariation>[
                                    FontVariation('wght', 900)
                                  ]),
                            ),
                            Text(
                              'a time...',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 44,
                                  fontVariations: const <FontVariation>[
                                    FontVariation('wght', 900)
                                  ]),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'Tell us who you are',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontVariations: <FontVariation>[
                                        FontVariation('wght', 400)
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextField(
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontVariations: <FontVariation>[
                                        FontVariation('wght', 560)
                                      ],
                                    ),
                                    controller: _userIdTextController,
                                    decoration: InputDecoration(
                                      constraints:
                                          const BoxConstraints(maxWidth: 320),
                                      contentPadding: const EdgeInsets.all(16),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withAlpha(200),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withAlpha(150),
                                        ),
                                      ),
                                      labelStyle: const TextStyle(
                                        fontVariations: <FontVariation>[
                                          FontVariation('wght', 700)
                                        ],
                                      ),
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withAlpha(150),
                                      filled: true,
                                      prefixIconColor:
                                          Theme.of(context).colorScheme.primary,
                                      prefixIcon: const Icon(
                                        Icons.person_rounded,
                                      ),
                                      hintText: 'How do you go by...',
                                      hintStyle: const TextStyle(
                                        fontVariations: <FontVariation>[
                                          FontVariation('wght', 700)
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FilledButton.icon(
                                    onPressed: () async {
                                      final userId = _userIdTextController.text;
                                      if (userId.isEmpty) {
                                        return;
                                      } else {
                                        await AppPreferenceService()
                                            .setUserId(userId: userId);
                                      }
                                      await FirestoreService().initUser();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const UserAvatarPicker();
                                          },
                                        ),
                                        ModalRoute.withName('/'),
                                      );
                                    },
                                    label: const Text(
                                      'Start your journey',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontVariations: <FontVariation>[
                                          FontVariation('wght', 400)
                                        ],
                                      ),
                                    ),
                                    icon: const Icon(Icons.book_rounded),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return const DashboardView();
              }
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}

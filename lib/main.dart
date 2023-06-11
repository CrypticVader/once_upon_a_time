import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';
import 'package:once_upon_a_time/services/preference_service.dart';
import 'package:once_upon_a_time/views/user_avatar_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppPreferenceService().initPrefs();
  FirestoreService().initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AppPreferenceService().initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Once upon a time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'JosefinSans',
        fontFamilyFallback: const ['Roboto'],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
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
          seedColor: Colors.deepOrange,
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/home_bg.png'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 64,
                ),
                const Text(
                  'Once',
                  style: TextStyle(
                    fontSize: 40,
                    fontVariations: <FontVariation>[FontVariation('wght', 700)],
                  ),
                ),
                const Text(
                  'upon',
                  style: TextStyle(
                      fontSize: 40,
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 700)
                      ]),
                ),
                const Text(
                  'a time...',
                  style: TextStyle(
                      fontSize: 40,
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 700)
                      ]),
                ),
                const Spacer(
                  flex: 1,
                ),
                const Text(
                  'Tell us who you are',
                  style: TextStyle(
                    fontSize: 18,
                    fontVariations: <FontVariation>[FontVariation('wght', 400)],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _userIdTextController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    labelStyle: TextStyle(
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 700)
                      ],
                    ),
                    fillColor:
                        Theme.of(context).colorScheme.secondary.withAlpha(100),
                    filled: true,
                    prefixIconColor: Theme.of(context).colorScheme.primary,
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
                  height: 8,
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final userId = _userIdTextController.text;
                    if (userId.isEmpty) {
                      return;
                    } else {
                      await AppPreferenceService().setUserId(userId: userId);
                    }
                    await FirestoreService().initCourseDoc();
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
                const SizedBox(
                  height: 32,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

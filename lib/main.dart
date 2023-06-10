import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                  onPressed: () {},
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

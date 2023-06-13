import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:once_upon_a_time/services/firestore_service.dart';
import 'package:once_upon_a_time/views/course_picker_view.dart';

class UserAvatarPicker extends StatefulWidget {
  const UserAvatarPicker({super.key});

  @override
  State<UserAvatarPicker> createState() => _UserAvatarPickerState();
}

class _UserAvatarPickerState extends State<UserAvatarPicker> {
  String? _selectedAvatarName;

  Future<void> onSelectAvatar({required String? assetName}) async {
    if (_selectedAvatarName == null) {
      return;
    } else {
      await FirestoreService().setAvatar(assetPath: assetName!);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const CoursePickerView();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How do you look like',
          style: TextStyle(
            fontVariations: <FontVariation>[FontVariation('wght', 400)],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                Card(
                  color: _selectedAvatarName == 'assets/images/boy.png'
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32.0),
                    onTap: () {
                      setState(() {
                        _selectedAvatarName = 'assets/images/boy.png';
                      });
                    },
                    child: Image.asset('assets/images/boy.png'),
                  ),
                ),
                Card(
                  color: _selectedAvatarName == 'assets/images/boy_alt.png'
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32.0),
                    onTap: () {
                      setState(() {
                        _selectedAvatarName = 'assets/images/boy_alt.png';
                      });
                    },
                    child: Image.asset('assets/images/boy_alt.png'),
                  ),
                ),
                Card(
                  color: _selectedAvatarName == 'assets/images/girl.png'
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32.0),
                    onTap: () {
                      setState(() {
                        _selectedAvatarName = 'assets/images/girl.png';
                      });
                    },
                    child: Image.asset('assets/images/girl.png'),
                  ),
                ),
                Card(
                  color: _selectedAvatarName == 'assets/images/girl_alt.png'
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32.0),
                    onTap: () {
                      setState(() {
                        _selectedAvatarName = 'assets/images/girl_alt.png';
                      });
                    },
                    child: Image.asset('assets/images/girl_alt.png'),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                FilledButton.icon(
                  onPressed: () async => await onSelectAvatar(assetName: _selectedAvatarName),
                  icon: const Icon(Icons.next_plan_rounded),
                  label: const Text(
                    'Set this as your avatar',
                    style: TextStyle(
                      fontVariations: <FontVariation>[
                        FontVariation('wght', 700)
                      ],
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    maximumSize: const Size.fromHeight(44),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

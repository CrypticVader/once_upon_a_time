import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:once_upon_a_time/firebase_options.dart';
import 'package:once_upon_a_time/services/preference_service.dart';

class FirestoreService {
  static final _shared = FirestoreService._sharedInstance();

  FirestoreService._sharedInstance();

  factory FirestoreService() => _shared;

  String get userId => AppPreferenceService().getUserId();

  CollectionReference<Map<String, dynamic>> get courses {
    return FirebaseFirestore.instance.collection('userCourses');
  }

  CollectionReference<Map<String, dynamic>> get scores {
    return FirebaseFirestore.instance.collection('userScores');
  }

  CollectionReference<Map<String, dynamic>> get progress {
    return FirebaseFirestore.instance.collection('userProgress');
  }

  Future<void> initialize() async {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> addCourse({
    required String courseName,
    required String theme,
  }) async {
    await courses.doc(userId).update({
      courseName: FieldValue.arrayUnion([theme])
    });
  }

  Future<void> initCourseDoc() async {
    try {
      await courses.doc(userId).update({
        'Maths': FieldValue.arrayUnion([]),
        'Programming': FieldValue.arrayUnion([]),
        'Science': FieldValue.arrayUnion([]),
        'Language': FieldValue.arrayUnion([]),
      });
      await scores.doc(userId).update({'score': FieldValue.increment(0)});
      await progress
          .doc(userId)
          .update({'progress': FieldValue.increment(0)});
    } catch (e) {
      await courses.doc(userId).set({
        'Maths': [],
        'Programming': [],
        'Science': [],
        'Language': [],
      });
      await scores.doc(userId).set({'score': 0});
      await progress.doc(userId).set({'progress': 1});
    }
  }

  Future<List<List<String>>> getActiveUserCourses() async {
    final courseSnapshot = await courses.doc(userId).get();
    final courseMap = courseSnapshot.data()!;
    List<List<String>> courseList = [];
    for (String courseName in courseMap.keys) {
      var courseThemes = courseMap[courseName] as List;
      for (var theme in courseThemes) {
        courseList.add([courseName, theme]);
      }
    }

    return courseList;
  }

  Future<int> get getUserScore async {
    final scoreRef = await scores.doc(userId).get();
    return scoreRef.data()!['score'] as int;
  }

  Future<void> incrementScoreBy(int value) async {
    final currentScore = await getUserScore;
    await scores.doc(userId).update({
      'score': currentScore + value,
    });
  }

  Future<void> setProgress(value) async {
    await progress.doc(userId).update({'progress': value});
  }

  Future<int> getProgress() async {
    final progressRef = await progress.doc(userId).get();
    return progressRef.data()!['progress'] as int;
  }

  Future<Map> getStoryViewData({
    required String courseName,
    required String themeName,
  }) async {
    final progress = await getProgress();
    final score = await getUserScore;

    return {
      'progress': progress,
      'score': score,
    };
  }
}

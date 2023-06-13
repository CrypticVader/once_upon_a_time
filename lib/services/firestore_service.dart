import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:once_upon_a_time/firebase_options.dart';
import 'package:once_upon_a_time/services/preference_service.dart';

class FirestoreService {
  static final _shared = FirestoreService._sharedInstance();

  FirestoreService._sharedInstance();

  factory FirestoreService() => _shared;

  String get userId => AppPreferenceService().getUserId();

  CollectionReference<Map<String, dynamic>> get avatars =>
      FirebaseFirestore.instance.collection('userAvatars');

  CollectionReference<Map<String, dynamic>> get courses =>
      FirebaseFirestore.instance.collection('userCourses');

  CollectionReference<Map<String, dynamic>> get scores =>
      FirebaseFirestore.instance.collection('userScores');

  CollectionReference<Map<String, dynamic>> get progress =>
      FirebaseFirestore.instance.collection('userProgress');

  Future<void> initialize() async {
    await Firebase.initializeApp(
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

  Future<void> initUser() async {
    try {
      await courses.doc(userId).update({
        'Maths': FieldValue.arrayUnion([]),
        'Programming': FieldValue.arrayUnion([]),
        'Science': FieldValue.arrayUnion([]),
        'Language': FieldValue.arrayUnion([]),
      });
      await scores.doc(userId).update({
        'score': FieldValue.increment(0),
      });
      await progress.doc(userId).update({
        'progress': FieldValue.increment(0),
      });
      await avatars.doc(userId).update({
        'path': '',
      });
    } catch (e) {
      await courses.doc(userId).set({
        'Maths': [],
        'Programming': [],
        'Science': [],
        'Language': [],
      });
      await scores.doc(userId).set({
        'score': 0,
      });
      await progress.doc(userId).set({
        'progress': 1,
      });
      await avatars.doc(userId).set({
        'path': '',
      });
    }
  }

  Future<List<List<String>>> get getActiveUserCourses async {
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
    await scores.doc(userId).update({
      'score': FieldValue.increment(value),
    });
  }

  Future<void> setProgress(value) async {
    await progress.doc(userId).update({
      'progress': value,
    });
  }

  Future<int> get getProgress async {
    final progressRef = await progress.doc(userId).get();
    return progressRef.data()!['progress'] as int;
  }

  Future<Map> getStoryViewData({
    required String courseName,
    required String themeName,
  }) async {
    final progress = await getProgress;
    final score = await getUserScore;

    return {
      'progress': progress,
      'score': score,
    };
  }

  Future<Map> get getMainViewData async {
    final score = await getUserScore;
    final courses = await getActiveUserCourses;
    final avatar = await getAvatar;

    return {
      'courses': courses,
      'score': score,
      'avatar': avatar,
    };
  }

  // eg. [['userName1', score1], ...]
  Stream<Iterable<List<String>>> get getLeaderboardViewData {
    final usersStream = scores.snapshots();
    final users = usersStream.map((event) => event.docs.map((doc) => [
          doc.id.toString(),
          (doc.data()['score'] as int).toString(),
        ]));
    return users;
  }

  Future<void> setAvatar({required String assetPath}) async {
    await avatars.doc(userId).set({
      'path': assetPath,
    });
  }

  Future<String> get getAvatar async {
    final progressRef = await avatars.doc(userId).get();
    return progressRef.data()!['path'] as String;
  }
}

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
      // courseName: [theme]
      courseName: FieldValue.arrayUnion([theme])
    });
  }

  Future<void> initCourseDoc() async {
    await courses.doc(userId).set({
      'Maths': [],
      'Programming': [],
      'Science': [],
      'Language': [],
    });
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
}

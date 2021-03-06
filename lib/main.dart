import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:forinterview/controllers/auth_controller.dart';
import 'package:forinterview/screens/auth/auth_screen.dart';
import 'package:forinterview/screens/landing/home_screen.dart';
import 'package:forinterview/utils/theme.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics _analytics = FirebaseAnalytics();
    return MaterialApp(
      title: 'Interview Task',
      theme: buildAppTheme(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: _analytics),
      ],
      home: const AppScreen(),
    );
  }
}

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    super.initState();
    AuthBloc().setupAuthData();
  }

  @override
  void dispose() {
    AuthBloc().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthBloc().currentUser,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const AuthScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}

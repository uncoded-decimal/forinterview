import 'package:flutter/material.dart';
import 'package:forinterview/controllers/auth_controller.dart';
import 'package:forinterview/screens/auth/login_screen.dart';
import 'package:forinterview/screens/auth/sign_up_screen.dart';
import 'package:forinterview/screens/widgets/error_dialog.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;

  @override
  void initState() {
    super.initState();
    AuthBloc().currentUser.listen(
      (event) {},
      onError: (e) {
        if (mounted) {
          showErrorDialog(
            context,
            errorTitle: "Authentication Error",
            errorMessage: e.toString(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: showLogin ? const LoginScreen() : const SignUpScreen(),
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () => setState(() {
          showLogin = !showLogin;
        }),
        child: Text(
            showLogin ? "Are you a new user?" : "Already have an account?"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forinterview/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
            validator: (value) => value == null || value.isEmpty
                ? "This field cannot be empty"
                : null,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              hintText: "Email ID",
              label: Text("Email ID"),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: showPassword,
            controller: _passwordController,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            validator: (value) => value == null || value.isEmpty
                ? "This field cannot be empty"
                : null,
            decoration: InputDecoration(
              hintText: "Password",
              label: const Text("Password"),
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  showPassword = !showPassword;
                }),
                icon: Icon(
                    !showPassword ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                FocusScope.of(context).requestFocus(FocusNode());
                AuthBloc().loginWithEmailAndPassword(
                  email: _emailController.value.text,
                  password: _passwordController.value.text,
                );
              }
            },
            child: const Text("Log me in!"),
          ),
          const Divider(height: 30),
          ElevatedButton(
            onPressed: () => AuthBloc().loginWithGoogle(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/vectors/g_white.svg",
                  height: 20,
                ),
                const SizedBox(width: 10),
                const Text("Login with Google"),
              ],
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

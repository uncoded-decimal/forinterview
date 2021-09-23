import 'package:flutter/material.dart';
import 'package:forinterview/controllers/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;

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
            "Sign Up",
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
            controller: _passwordController,
            obscureText: showPassword,
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
                AuthBloc().signUpWithEmailAndPassword(
                  email: _emailController.value.text,
                  password: _passwordController.value.text,
                );
              }
            },
            child: const Text("Sign me up!"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

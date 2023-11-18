import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'enter email address',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'enter password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase()
                    .logIn(email: email, password: password);

                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //user is verified
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  //user isnt verified
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on InvalidLoginCredentialsAuthException {
                await showErrorDialog(
                  context,
                  'Invalid login credentials',
                );
              } on InvalidEmailAddressAuthException {
                await showErrorDialog(
                  context,
                  'Invalid email address',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication Error',
                );
              }

              // on FirebaseAuthException catch (e) {
              //   // print(e.runtimeType);
              //   if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
              //     // print('Invalid Login Credentials');
              //     // devtools.log('Invalid login credentials');
              //     await showErrorDialog(
              //       context,
              //       'Invalid login credentials',
              //     );
              //   } else if (e.code == 'invalid-email') {
              //     // print('Enter a valid email address');
              //     // devtools.log('Enter a valid email address');
              //     await showErrorDialog(
              //       context,
              //       'Invalid email address',
              //     );
              //   } else {
              //     await showErrorDialog(
              //       context,
              //       'Error: ${e.code}',
              //     );
              //   }
              // } catch (e) {
              //   await showErrorDialog(
              //     context,
              //     e.toString(),
              //   );
              // }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Not yet registered? Register here"))
        ],
      ),
    );
  }
}

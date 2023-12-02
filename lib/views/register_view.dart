import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/dialogs/error_dialog.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterView();
}

class _RegisterView extends State<RegisterView> {
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
      appBar: AppBar(title: const Text("Register")),
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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );

                AuthService.firebase().sendEmailVerification();
                if (!mounted) return;
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email address already in use',
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on InvalidEmailAddressAuthException {
                await showErrorDialog(
                  context,
                  'Please enter a valid email address',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to register',
                );
              }

              // on FirebaseAuthException catch (e) {
              //   if (e.code == 'email-already-in-use') {
              //     // print('Email address already in use');
              //     // devtools.log('Email address already in use');
              //     await showErrorDialog(
              //       context,
              //       'Email address already in use',
              //     );
              //   } else if (e.code == 'weak-password') {
              //     // print('Your password is weak');
              //     // devtools.log('Your password is weak');
              //     await showErrorDialog(
              //       context,
              //       'Weak password',
              //     );
              //   } else if (e.code == 'invalid-email') {
              //     // print('please enter a valid email');
              //     // devtools.log('Please enter a valid email address');
              //     await showErrorDialog(
              //       context,
              //       'Please enter a valid email address',
              //     );
              //   } else {
              //     await showErrorDialog(context, 'Error: ${e.code}');
              //   }
              // } catch (e) {
              //   await showErrorDialog(
              //     context,
              //     e.toString(),
              //   );
              // }
            },
            child: const Text('create account'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Login')),
        ],
      ),
    );
  }
}

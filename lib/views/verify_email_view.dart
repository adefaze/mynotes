import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Email',
        ),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent a verification link to your email address, click on the link to verify your account."),
          const Text(
              'if you didn\'t receive the link, tap on the button to resend your verification link'),
          TextButton(
            onPressed: () async {
              // final user = FirebaseAuth.instance.currentUser;
              // await user?.sendEmailVerification();
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Resend verification link'),
          ),
          TextButton(
            onPressed: () {
              // FirebaseAuth.instance.signOut();
              AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}

import 'package:bloc_firebase_photo_gallery/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bloc_firebase_photo_gallery/extensions/if_debugging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'devtest15678@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'devtest15678'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                hintText: 'Enter you email',
                label: Text('Email'),
              ),
            ),
            TextFormField(
              controller: passwordController,
              autocorrect: false,
              obscureText: true,
              obscuringCharacter: '⦿',
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter you password',
                label: Text('Password'),
              ),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppBloc>().add(
                      AppEventRegister(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(const AppEventGoToLogIn());
              },
              child: const Text('Already registered? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

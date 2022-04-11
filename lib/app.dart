import 'package:bloc_firebase_photo_gallery/bloc/bloc.dart';
import 'package:bloc_firebase_photo_gallery/dialogs/auth_error.dart';
import 'package:bloc_firebase_photo_gallery/loading/loading_screen.dart';
import 'package:bloc_firebase_photo_gallery/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (context) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        title: 'Gallery',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen().hide();
            }
            final authError = state.authError;
            if (authError != null) {
              showAuthError(
                context,
                authError: authError,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginScreen();
            }
            if (state is AppStateLoggedIn) {
              return const PhotoGallery();
            }
            if (state is AppStateInRegistrationView) {
              return const RegisterScreen();
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

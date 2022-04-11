import 'dart:developer';
import 'dart:io';

import 'package:bloc_firebase_photo_gallery/auth/auth.dart';
import 'package:bloc_firebase_photo_gallery/bloc/bloc.dart';
import 'package:bloc_firebase_photo_gallery/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateInitializing()) {
    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return emit(const AppStateLoggedOut());
      }
      final images = await _getImages(user.uid);
      emit(AppStateLoggedIn(user: user, images: images));
    });

    on<AppEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      emit(const AppStateLoggedOut(isLoading: true));
      try {
        final userCredentials = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final user = userCredentials.user;

        if (user != null) {
          final images = await _getImages(user.uid);
          emit(AppStateLoggedIn(user: user, images: images));
        }
      } catch (e) {
        emit(AppStateLoggedOut(authError: AuthError.from(e)));
      }
    });

    on<AppEventGoToLogIn>((event, emit) {
      emit(const AppStateLoggedOut());
    });

    on<AppEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      emit(const AppStateInRegistrationView(isLoading: true));
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception();
        }
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(user: user, images: images));
      } catch (e) {
        emit(AppStateInRegistrationView(authError: AuthError.from(e)));
      }
    });

    on<AppEventGoToRegister>((event, emit) {
      emit(const AppStateInRegistrationView());
    });

    on<AppEventLogOut>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      await FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut());
    });

    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      if (user == null) {
        return emit(const AppStateLoggedOut());
      }
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );

      final file = File(event.filePath);
      await uploadImage(
        file: file,
        userId: user.uid,
      );
      final images = await _getImages(user.uid);
      emit(AppStateLoggedIn(user: user, images: images));
    });

    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return emit(const AppStateLoggedOut());
      }
      emit(AppStateLoggedIn(
        user: user,
        images: state.images ?? [],
        isLoading: true,
      ));
      try {
        final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folder.items) {
          await item.delete().catchError((_) => {});
        }
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) => {});

        await user.delete();
        await FirebaseAuth.instance.signOut();
        emit(const AppStateLoggedOut());
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        // ignore: todo
        // TODO: handle error
        emit(const AppStateLoggedOut());
      }
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance.ref(userId).list().then((list) => list.items);
}

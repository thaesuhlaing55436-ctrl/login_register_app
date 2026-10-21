import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_register_app/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _auth;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  StreamSubscription<User?>? _authSubscription;

  AuthCubit(this._auth) : super(AuthInitial()) {
    _authSubscription = _firebaseAuth.authStateChanges().listen(
          (user) {
        if (isClosed) return;

        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(AuthError(error.toString()));
        }
      },
    );
  }

  User? get user => switch (state) {
    Authenticated(user: final user) => user,
    _ => null,
  };

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.login(
        email: email,
        password: password,
      );
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e.toString()));
      }
      rethrow;
    }
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.register(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(e.toString()));
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await super.close();
  }
}
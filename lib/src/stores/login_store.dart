import 'package:destrava/src/services/login_service.dart';
import 'package:destrava/src/states/login_state.dart';
import 'package:flutter/material.dart';

class LoginStore extends ValueNotifier<LoginState> {
  LoginService loginService;
  LoginStore({required this.loginService}) : super(InitialLoginState());

  Future signIn(
    String email,
    String password,
  ) async {
    value = LoadingLoginState();

    try {
      final result = await loginService.signIn(email, password);
      value = SuccessLoginState(result.toString());
    } catch (e) {
      value = ErrorLoginState(e.toString());
    }
  }

  Future signUp(
    String email,
    String password,
  ) async {
    value = LoadingLoginState();
    try {
      final result = await loginService.signUp(password, email);
      value = RegisteredLoginState(result.user.id);
    } catch (e) {
      value = ErrorLoginState(e.toString());
    }
  }

  Future createProfile(
    String id,
    String name,
    String email,
    String profilePictureUrl,
    String createdAt,
    String updatedAt,
  ) async {
    try {
      final result = await loginService.createProfile(
          id, name, email, profilePictureUrl, createdAt, updatedAt);
      value = SuccessLoginState(result.toString());
    } catch (e) {
      value = ErrorLoginState(e.toString());
    }
  }
}

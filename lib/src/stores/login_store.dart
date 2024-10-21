import 'package:destrava/main.dart';
import 'package:destrava/src/services/login_service.dart';
import 'package:destrava/src/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginStore extends ValueNotifier<LoginState> {
  LoginService loginService = LoginService(getIt.get<SupabaseClient>());
  LoginStore() : super(InitialLoginState());

  Future signIn(
    String email,
    String password,
  ) async {
    value = LoadingLoginState();

    try {
      final result = await loginService.signIn(password, email);
      value = SuccessLoginState(result.toString());
    } catch (e) {
      value = ErrorLoginState(e.toString());
    }
  }

  Future signUp(
    String email,
    String password,
    Map<String, dynamic> data,
  ) async {
    value = LoadingLoginState();
    try {
      final result = await loginService.signUp(password, email, data);
      value = SuccessLoginState(result.toString());
    } catch (e) {
      value = ErrorLoginState(e.toString());
    }
  }
}

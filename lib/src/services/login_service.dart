import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  final SupabaseClient supabaseClient;

  LoginService(this.supabaseClient);

  Future signUp(
      String password, String email, Map<String, dynamic> data) async {
    return await supabaseClient.auth.signUp(
      password: password,
      email: email,
      data: data,
    );
  }

  Future signIn(
    String password,
    String email,
  ) async {
    return await supabaseClient.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }
}

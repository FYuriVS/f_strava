import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  final SupabaseClient supabaseClient;

  LoginService(this.supabaseClient);

  Future signUp(String password, String email) async {
    return await supabaseClient.auth.signUp(
      password: password,
      email: email,
    );
  }

  Future signIn(
    String email,
    String password,
  ) async {
    return await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future createProfile(
    String id,
    String name,
    String email,
    String profilePictureUrl,
    String createdAt,
    String updatedAt,
  ) async {
    final response = await supabaseClient.from('users').insert([
      {
        'id': id,
        'name': name,
        'email': email,
        'profile_picture_url': profilePictureUrl,
        'created_at': createdAt,
        'updated_at': updatedAt,
      }
    ]);

    if (response.error != null) {
      throw Exception('Erro ao criar perfil: ${response.error!.message}');
    }
  }
}

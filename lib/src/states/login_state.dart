sealed class LoginState {}

class InitialLoginState extends LoginState {}

//Success
class SuccessLoginState extends LoginState {
  final String message;
  SuccessLoginState(this.message);
}

//Loading
class LoadingLoginState extends LoginState {}

class RegisteredLoginState extends LoginState {
  String userId;
  RegisteredLoginState(this.userId);
}

//Error
class ErrorLoginState extends LoginState {
  final String message;
  ErrorLoginState(this.message);
}

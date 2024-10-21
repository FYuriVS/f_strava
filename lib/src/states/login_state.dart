sealed class LoginState {}

class InitialLoginState extends LoginState {}

//Success
class SuccessLoginState extends LoginState {
  final String message;
  SuccessLoginState(this.message);
}

//Loading
class LoadingLoginState extends LoginState {}

//Error
class ErrorLoginState extends LoginState {
  final String message;
  ErrorLoginState(this.message);
}

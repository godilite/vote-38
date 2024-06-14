sealed class AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailed extends AuthState {}

class SignupSuccess extends AuthState {}

class AccountSetupRequired extends AuthState {}

class OnboardingNotComplete extends AuthState {}

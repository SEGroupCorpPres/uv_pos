class ApiEndpoints {
  static const String baseUrl = 'https://api.barbershop.com/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // Social auth
  static const String googleAuth = '/auth/google';
  static const String appleAuth = '/auth/apple';

  // Phone auth
  static const String sendOtp = '/auth/phone/send-otp';
  static const String verifyOtp = '/auth/phone/verify-otp';

  // User
  static const String currentUser = '/auth/me';
  static const String updateProfile = '/auth/profile';
  static const String deleteAccount = '/auth/delete-account';
}

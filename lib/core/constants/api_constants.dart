class ApiConstants {
  static const String baseUrl = 'https://chirpup.sitestaginglink.com/api';

  // auth
  static const String login = '/login';
  static const String createAccount = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendOTP = '/auth/resend-otp';
  static const String getCharacters = '/characters';
  static const String getYears = '/years';
  static const String createChildProfile = '/children';
  static const String parentPin = '/parent-pin';
  static const String parentPinSkip = '/parent-pin/skip';

  // parent dashboard
  static const String getParentChildrens = '/children-all';

  // child profile selection
  static const String pinStatus = '/parent-pin/status';
  static const String verifyPin = '/parent-pin/verify';
}
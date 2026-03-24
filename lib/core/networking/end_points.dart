class EndPoints {
  static const String baseUrl = 'https://sales-tracker.sitksa-eg.com/api/';
  // ? auth & user
  static const String login = 'auth/login';
  static const String profile = 'auth/me';
  static const String editProfile = 'auth/profile';
  static const String repHome = 'rep/dashboard';
  static const String adminHome = 'admin/dashboard';
  static const String clients = 'rep/clients';
  static const String allClients = 'admin/clients';
  static const String reps = 'admin/reps';
  static const String visits = 'rep/visits';
  static const String allVisits = 'admin/visits';
  static const String register = 'register';
  static const String sendOtp = 'send-otp';
  static const String verifyOtp = 'verify-otp';
  static const String updatePassword = 'update-password';
  static const String resetPassword = 'update-profile';
  static const String getAuthUser = 'get-auth-user';
  static const String updateProfile = 'update-profile';
  static const String logout = 'auth/logout';
}

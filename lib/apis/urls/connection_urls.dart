class ConnectionUrls {
  static const String baseUrl = 'https://clock-path-api.onrender.com';

  //Auth EndPoints
  static const String acceptInviteEndpoint =
      '/api/v1/auth/user/invite/verify-otp';
  static const String setNewPasswordEndpoint = '/api/v1/auth/user/password/new';
  static const String loginEndpoint = '/api/v1/auth/user/login';
  static const String forgotPasswordEndpoint =
      '/api/v1/auth/user/password/forgot';
  static const String oneTimePinEndpoint =
      '/api/v1/auth/user/password/verify-otp';
  static const String resetPasswordEndpoint =
      '/api/v1/auth/user/password/reset';

  //setUpProfile
  static const String setupProfileEndpoint = '/api/v1/user/profile';
}

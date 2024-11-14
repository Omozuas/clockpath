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
  static const String setupWorkDaysEndpoint = '/api/v1/user/profile';

  //clockIn and Out
  static const String clockInEndpoint = '/api/v1/user/clock-in';
  static const String clockOutEndpoint = '/api/v1/user/clock-out';

  //get recentactivity
  static const String getrecentActivityEndpoint =
      '/api/v1/user/recent-activity';

  //requestUser
  static const String requestUserEndpoint = '/api/v1/user/request';
  //settings
  static const String managePasswordEndpoint = '/api/v1/user/passwords';
  static const String updateProfileEndpoint = '/api/v1/user/profile';
  static const String logoutEndpoint = '/api/v1/user/logout';
  static const String registerDeviceEndpoint = '/api/v1/user/device/register';
}

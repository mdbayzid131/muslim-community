class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String selectRole = '/selectRole';

  // Auth Routes
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String signUpOtp = '/signUpOTP';
  static const String forgotPassword = '/forgotPassword';
  static const String forgotPasswordOtp = '/forgotPasswordOTP';
  static const String resetPassword = '/resetPassword';
  static const String locationAccess = '/locationAccess';
  static const String identityVerification = '/identityVerification';
  static const String verificationComplete = '/verificationComplete';

  // Legacy role-specific aliases (for backward compatibility)
  static const String maleSignUp = '/maleSignUp';
  static const String femaleSignUp = '/femaleSignUp';
  static const String jummaSignUp = '/jummaSignUp';
  static const String maleLogin = '/maleLogin';
  static const String femaleLogin = '/femaleLogin';
  static const String jummaLogin = '/jummaLogin';
  static const String maleSignUpOTP = '/maleSignUpOTP';
  static const String femaleSignUpOTP = '/femaleSignUpOTP';
  static const String jummaSignUpOTP = '/jummaSignUpOTP';
  static const String maleForgetPasswordEmail = '/maleForgetPasswordEmail';
  static const String femaleForgetPasswordEmail = '/femaleForgetPasswordEmail';
  static const String jummaForgetPasswordEmail = '/jummaForgetPasswordEmail';
  static const String maleForgetPasswordOTP = '/maleForgetPasswordOTP';
  static const String femaleForgetPasswordOTP = '/femaleForgetPasswordOTP';
  static const String jummaForgetPasswordOTP = '/jummaForgetPasswordOTP';
  static const String maleResetPassword = '/maleResetPassword';
  static const String femaleResetPassword = '/femaleResetPassword';
  static const String jummaResetPassword = '/jummaResetPassword';
  static const String maleLocationAccess = '/maleLocationAccess';
  static const String femaleLocationAccess = '/femaleLocationAccess';
  static const String maleIdentityVerification = '/maleIdentityVerification';
  static const String femaleIdentityVerification = '/femaleIdentityVerification';
  static const String maleVerificationComplete = '/maleVerificationComplete';
  static const String femaleVerificationComplete = '/femaleVerificationComplete';

  // Navigation & Main Views
  static const String navbar = '/navbar';
  static const String maleNavbar = '/maleNavbar';
  static const String femaleNavbar = '/femaleNavbar';
  static const String jummaNavbar = '/jummaNavbar';

  // Features
  static const String prayerSettings = '/prayerSettings';
  static const String sunriseDetails = '/sunriseDetails';
  static const String threeQuls = '/threeQuls';

  static const String groupDetails = '/groupDetails';
  static const String maleGroupDetails = '/maleGroupDetails';
  static const String femaleGroupDetails = '/femaleGroupDetails';
  static const String postDetails = '/postDetails';
  static const String malePostDetails = '/malePostDetails';
  static const String femalePostDetails = '/femalePostDetails';

  static const String learning = '/learningDetails';
  static const String learningDetails = '/learningDetails';
  static const String maleLearningDetails = '/maleLearningDetails';
  static const String femaleLearningDetails = '/femaleLearningDetails';
  static const String mosqueDetails = '/mosqueDetails';
  static const String maleMosqueDetails = '/maleMosqueDetails';
  static const String femaleMosqueDetails = '/femaleMosqueDetails';
  static const String jummaNowPlaying = '/jummaNowPlaying';
  static const String maleJummaNowPlaying = '/maleJummaNowPlaying';
  static const String femaleJummaNowPlaying = '/femaleJummaNowPlaying';
  static const String wuduGhuslFlashcard = '/wuduGhuslFlashcard';

  static const String notifications = '/notifications';
  static const String femaleNotifications = '/femaleNotifications';
  static const String pendingRequests = '/pendingRequests';
  static const String sentRequests = '/sentRequests';

  static const String personalInfo = '/personalInfo';
  static const String changePassword = '/changePassword';
  static const String privacyPolicy = '/privacyPolicy';
  static const String termsConditions = '/termsConditions';

  static const String askImam = '/askImam';
  static const String submissionSuccess = '/submissionSuccess';

  static const String prayerRakatGuide = '/prayerRakatGuide';
  static const String prayerRecitation = '/prayerRecitation';
  static const String chat = '/chat';
}

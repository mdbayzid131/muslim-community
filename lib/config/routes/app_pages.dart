import 'package:get/get.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/modules/ask_imam/binding/ask_imam_binding.dart';
import 'package:muslim_community/modules/ask_imam/view/ask_imam_view.dart';
import 'package:muslim_community/modules/ask_imam/view/submission_success_view.dart';
import 'package:muslim_community/modules/auth/binding/auth_binding.dart';
import 'package:muslim_community/modules/auth/view/forgot_password_email_view.dart';
import 'package:muslim_community/modules/auth/view/forgot_password_otp_view.dart';
import 'package:muslim_community/modules/auth/view/identity_verification_view.dart';
import 'package:muslim_community/modules/auth/view/location_access_view.dart';
import 'package:muslim_community/modules/auth/view/login_view.dart';
import 'package:muslim_community/modules/auth/view/reset_password_view.dart';
import 'package:muslim_community/modules/auth/view/signup_otp_view.dart';
import 'package:muslim_community/modules/auth/view/signup_view.dart';
import 'package:muslim_community/modules/auth/view/verification_complete_view.dart';
import 'package:muslim_community/modules/discover/binding/discover_binding.dart';
import 'package:muslim_community/modules/discover/view/jumma_now_playing_view.dart';
import 'package:muslim_community/modules/discover/view/learning_view.dart';
import 'package:muslim_community/modules/discover/view/mosque_details_view.dart';
import 'package:muslim_community/modules/discover/view/wudu_ghusl_flashcard_view.dart';
import 'package:muslim_community/modules/group/binding/group_binding.dart';
import 'package:muslim_community/modules/group/view/group_details_view.dart';
import 'package:muslim_community/modules/group/view/post_details_view.dart';
import 'package:muslim_community/modules/home/binding/home_binding.dart';
import 'package:muslim_community/modules/home/view/prayer_settings_view.dart';
import 'package:muslim_community/modules/home/view/sunrise_details_view.dart';
import 'package:muslim_community/modules/home/view/three_quls_view.dart';
import 'package:muslim_community/modules/messages/binding/messages_binding.dart';
import 'package:muslim_community/modules/messages/view/chat_view.dart';
import 'package:muslim_community/modules/navigation/binding/navigation_binding.dart';
import 'package:muslim_community/modules/navigation/view/navbar_view.dart';
import 'package:muslim_community/modules/notifications/binding/notifications_binding.dart';
import 'package:muslim_community/modules/notifications/view/notifications_view.dart';
import 'package:muslim_community/modules/notifications/view/pending_request_view.dart';
import 'package:muslim_community/modules/notifications/view/sent_request_view.dart';
import 'package:muslim_community/modules/prayer_guide/binding/prayer_guide_binding.dart';
import 'package:muslim_community/modules/prayer_guide/view/prayer_rakat_guide_view.dart';
import 'package:muslim_community/modules/prayer_guide/view/prayer_recitation_view.dart';
import 'package:muslim_community/modules/profile/binding/profile_binding.dart';
import 'package:muslim_community/modules/profile/view/change_password_view.dart';
import 'package:muslim_community/modules/profile/view/personal_info_view.dart';
import 'package:muslim_community/modules/profile/view/privacy_policy_view.dart';
import 'package:muslim_community/modules/profile/view/terms_conditions_view.dart';
import 'package:muslim_community/modules/select_role/binding/select_role_binding.dart';
import 'package:muslim_community/modules/select_role/view/select_role_view.dart';
import 'package:muslim_community/modules/splash/binding/splash_binding.dart';
import 'package:muslim_community/modules/splash/view/splash_view.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final List<GetPage> pages = [
    // Splash & Role Selection
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.selectRole,
      page: () => const SelectRoleView(),
      binding: SelectRoleBinding(),
    ),

    // Auth Routes
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleLogin,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleLogin,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaLogin,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleSignUp,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleSignUp,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaSignUp,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUpOtp,
      page: () => const SignUpOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleSignUpOTP,
      page: () => const SignUpOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleSignUpOTP,
      page: () => const SignUpOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaSignUpOTP,
      page: () => const SignUpOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordEmailView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleForgetPasswordEmail,
      page: () => const ForgotPasswordEmailView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleForgetPasswordEmail,
      page: () => const ForgotPasswordEmailView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaForgetPasswordEmail,
      page: () => const ForgotPasswordEmailView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordOtp,
      page: () => const ForgotPasswordOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleForgetPasswordOTP,
      page: () => const ForgotPasswordOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleForgetPasswordOTP,
      page: () => const ForgotPasswordOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaForgetPasswordOTP,
      page: () => const ForgotPasswordOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleResetPassword,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleResetPassword,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaResetPassword,
      page: () => const ResetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.locationAccess,
      page: () => const LocationAccessView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleLocationAccess,
      page: () => const LocationAccessView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleLocationAccess,
      page: () => const LocationAccessView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.identityVerification,
      page: () => const IdentityVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleIdentityVerification,
      page: () => const IdentityVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleIdentityVerification,
      page: () => const IdentityVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verificationComplete,
      page: () => const VerificationCompleteView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.maleVerificationComplete,
      page: () => const VerificationCompleteView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleVerificationComplete,
      page: () => const VerificationCompleteView(),
      binding: AuthBinding(),
    ),

    // Navigation & Main Views
    GetPage(
      name: AppRoutes.navbar,
      page: () => const NavbarView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.maleNavbar,
      page: () => const NavbarView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleNavbar,
      page: () => const NavbarView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaNavbar,
      page: () => const NavbarView(),
      binding: NavigationBinding(),
    ),

    // Home Features
    GetPage(
      name: AppRoutes.prayerSettings,
      page: () => const PrayerSettingsView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.sunriseDetails,
      page: () => const SunriseDetailsView(),
    ),
    GetPage(
      name: AppRoutes.threeQuls,
      page: () => const ThreeQulsView(),
    ),

    // Group Features
    GetPage(
      name: AppRoutes.groupDetails,
      page: () => const GroupDetailsView(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: AppRoutes.maleGroupDetails,
      page: () => const GroupDetailsView(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleGroupDetails,
      page: () => const GroupDetailsView(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: AppRoutes.postDetails,
      page: () => const PostDetailsView(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: AppRoutes.malePostDetails,
      page: () => const PostDetailsView(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: AppRoutes.femalePostDetails,
      page: () => const PostDetailsView(),
      binding: GroupBinding(),
    ),

    // Discover & Learning Features
    GetPage(
      name: AppRoutes.learningDetails,
      page: () => const LearningView(),
      binding: DiscoverBinding(),
    ),
    GetPage(
      name: AppRoutes.maleLearningDetails,
      page: () => const LearningView(),
      binding: DiscoverBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleLearningDetails,
      page: () => const LearningView(),
      binding: DiscoverBinding(),
    ),
    GetPage(
      name: AppRoutes.jummaNowPlaying,
      page: () => const JummaNowPlayingView(),
    ),
    GetPage(
      name: AppRoutes.maleJummaNowPlaying,
      page: () => const JummaNowPlayingView(),
    ),
    GetPage(
      name: AppRoutes.femaleJummaNowPlaying,
      page: () => const JummaNowPlayingView(),
    ),
    GetPage(
      name: AppRoutes.wuduGhuslFlashcard,
      page: () => const WuduGhuslFlashcardView(title: "How to Make Wudu"),
    ),
    GetPage(
      name: AppRoutes.mosqueDetails,
      page: () => const MosqueDetailsView(),
    ),
    GetPage(
      name: AppRoutes.maleMosqueDetails,
      page: () => const MosqueDetailsView(),
    ),
    GetPage(
      name: AppRoutes.femaleMosqueDetails,
      page: () => const MosqueDetailsView(),
    ),

    // Messages
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      binding: MessagesBinding(),
    ),

    // Notifications
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.femaleNotifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.pendingRequests,
      page: () => const PendingRequestView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.sentRequests,
      page: () => const SentRequestView(),
      binding: NotificationsBinding(),
    ),

    // Profile
    GetPage(
      name: AppRoutes.personalInfo,
      page: () => const PersonalInfoView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyView(),
    ),
    GetPage(
      name: AppRoutes.termsConditions,
      page: () => const TermsConditionsView(),
    ),

    // Ask Imam
    GetPage(
      name: AppRoutes.askImam,
      page: () => const AskImamView(),
      binding: AskImamBinding(),
    ),
    GetPage(
      name: AppRoutes.submissionSuccess,
      page: () => const SubmissionSuccessView(),
    ),

    // Prayer Guide
    GetPage(
      name: AppRoutes.prayerRakatGuide,
      page: () => const PrayerRakatGuideView(),
      binding: PrayerGuideBinding(),
    ),
    GetPage(
      name: AppRoutes.prayerRecitation,
      page: () => const PrayerRecitationView(),
      binding: PrayerGuideBinding(),
    ),
    GetPage(
      name: '/PrayerRecitationView',
      page: () => const PrayerRecitationView(),
      binding: PrayerGuideBinding(),
    ),
  ];
}

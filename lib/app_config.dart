class AppConfig {
  static const String baseUrl = "https://nayem5001.binarybards.online/api/v1";
  static const String createUserEndpoint = "$baseUrl/users";
  static const String verifyOtpEndpoint = "$baseUrl/auth/verify-otp";
  static const String loginEndpoint = "$baseUrl/auth/login";
  static const String refreshTokenEndpoint = "$baseUrl/auth/refresh-token";
  static const String getProfileEndpoint = "$baseUrl/users/me";
  static const String getProfilesEndpoint = "$baseUrl/users/profiles";
  static const String connectionsEndpoint = "$baseUrl/connections";
  static const String connectionRequestEndpoint =
      "$baseUrl/connections/request";
  static const String cancelConnectionEndpoint =
      "$baseUrl/connections/{id}/cancel";
  static const String pendingConnectionsEndpoint =
      "$baseUrl/connections/requests";
  static const String updateConnectionEndpoint = "$baseUrl/connections";
  static const String prayersNotificationsEndpoint =
      "$baseUrl/notifications/me";
  static const String markNotificationReadEndpoint =
      "$baseUrl/notifications/{id}/read";
  static const String markAllNotificationsReadEndpoint =
      "$baseUrl/notifications/read-all";
  static const String groupPostsEndpoint = "$baseUrl/groups/posts";
  static const String deletePostEndpoint = "$baseUrl/groups/posts/{postId}";
  static const String postCommentsEndpoint =
      "$baseUrl/groups/posts/{postId}/comments";
  static const String deleteCommentEndpoint =
      "$baseUrl/groups/comments/{commentId}";
  static const String learningContentsEndpoint = "$baseUrl/learning-contents";
  static const String likeLearningContentEndpoint =
      "$baseUrl/learning-contents/{id}/like";
  static const String learningCommentsEndpoint =
      "$baseUrl/learning-contents/{id}/comments";
  static const String deleteLearningCommentEndpoint =
      "$baseUrl/learning-contents/comments/{id}";
  static const String askQuestionEndpoint = "$baseUrl/ask-question";
  static const String myQuestionsEndpoint =
      "$baseUrl/ask-question/my-questions";
  static const String forgotPasswordEndpoint = "$baseUrl/auth/forgot-password";
  static const String verifyForgotPasswordOtpEndpoint =
      "$baseUrl/auth/verify-forgot-password-otp";
  static const String resetPasswordEndpoint = "$baseUrl/auth/reset-password";
  static const String legalEndpoint = "$baseUrl/legal";
  static const String duasEndpoint = "$baseUrl/duas";
  static const String changePasswordEndpoint = "$baseUrl/auth/change-password";
  static const String prayerTimesEndpoint = "$baseUrl/prayer-times";
  static const String groupsEndpoint = "$baseUrl/groups";
  static const String chatListEndpoint = "$baseUrl/chats";
  static const String messagesEndpoint = "$baseUrl/messages";
  static String getChatMessagesEndpoint(String chatId) =>
      "$baseUrl/messages/chat/$chatId";
  static String markChatAsReadEndpoint(String chatId) =>
      "$baseUrl/messages/chat/$chatId/read";
  static String getPublicProfileEndpoint(String userId) =>
      "$baseUrl/users/$userId/public";
  static String getNamazGuideEndpoint(String salahType) =>
      "$baseUrl/namaz/guide/$salahType";
}

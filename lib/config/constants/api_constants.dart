class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = "https://nayem5002.binarybards.online/api/v1";
  static const String serverUrl = "https://nayem5002.binarybards.online";

  static String getImageUrl(String? url) {
    if (url == null ||
        url.isEmpty ||
        url == 'null' ||
        url == '/' ||
        url.toLowerCase().endsWith('.svg') ||
        url.toLowerCase().contains('default-avatar')) {
      return '';
    }
    if (url.startsWith('http')) return url;
    if (url.startsWith('/')) return '$serverUrl$url';
    return '$serverUrl/$url';
  }

  // Auth Endpoints
  static const String login = "/auth/login";
  static const String signup = "/users";
  static const String verifyOtp = "/auth/verify-otp";
  static const String refreshToken = "/auth/refresh-token";
  static const String forgotPassword = "/auth/forgot-password";
  static const String verifyForgotPasswordOtp = "/auth/verify-forgot-password-otp";
  static const String resetPassword = "/auth/reset-password";
  static const String changePassword = "/auth/change-password";

  // User & Profile Endpoints
  static const String profile = "/users/me";
  static const String profiles = "/users/profiles";
  static String publicProfile(String userId) => "/users/$userId/public";

  // Connection Endpoints
  static const String connections = "/connections";
  static const String connectionRequest = "/connections/request";
  static String cancelConnection(String id) => "/connections/$id/cancel";
  static const String pendingConnections = "/connections/requests";
  static const String updateConnection = "/connections";

  // Notification Endpoints
  static const String notifications = "/notifications/me";
  static String markNotificationRead(String id) => "/notifications/$id/read";
  static const String markAllNotificationsRead = "/notifications/read-all";

  // Group Endpoints
  static const String groups = "/groups";
  static const String groupPosts = "/groups/posts";
  static String deletePost(String postId) => "/groups/posts/$postId";
  static String postComments(String postId) => "/groups/posts/$postId/comments";
  static String deleteComment(String commentId) => "/groups/comments/$commentId";

  // Learning Endpoints
  static const String learningContents = "/learning-contents";
  static String likeLearningContent(String id) => "/learning-contents/$id/like";
  static String learningComments(String id) => "/learning-contents/$id/comments";
  static String deleteLearningComment(String id) => "/learning-contents/comments/$id";

  // Ask Question / Ask Imam Endpoints
  static const String askQuestion = "/ask-question";
  static const String myQuestions = "/ask-question/my-questions";

  // Prayer & Namaz Endpoints
  static const String prayerTimes = "/prayer-times";
  static String namazGuide(String salahType) => "/namaz/guide/$salahType";
  static const String duas = "/duas";

  // Chat & Messaging Endpoints
  static const String chats = "/chats";
  static const String messages = "/messages";
  static String chatMessages(String chatId) => "/messages/chat/$chatId";
  static String markChatRead(String chatId) => "/messages/chat/$chatId/read";

  // Legal Endpoints
  static const String legal = "/legal";
}

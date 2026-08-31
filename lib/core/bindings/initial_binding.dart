import 'package:get/get.dart';
import 'package:muslim_community/core/controllers/internet_controller.dart';
import 'package:muslim_community/core/services/api_client.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/services/azan_service.dart';
import 'package:muslim_community/core/services/notification_service.dart';
import 'package:muslim_community/core/services/socket_service.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/data/repositories/ask_imam_repository.dart';
import 'package:muslim_community/data/repositories/auth_repository.dart';
import 'package:muslim_community/data/repositories/chat_repository.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';
import 'package:muslim_community/data/repositories/dua_repository.dart';
import 'package:muslim_community/data/repositories/group_repository.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';
import 'package:muslim_community/data/repositories/mosque_repository.dart';
import 'package:muslim_community/data/repositories/notification_repository.dart';
import 'package:muslim_community/data/repositories/prayer_repository.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put(StorageService(), permanent: true);
    final apiClient = Get.put(ApiClient(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(SocketService(), permanent: true);
    Get.put(NotificationService(), permanent: true);
    Get.put(AzanService(), permanent: true);

    // Global Controllers
    Get.put(InternetController(), permanent: true);

    // Repositories
    Get.lazyPut(() => AuthRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => UserRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => ConnectionRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => GroupRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => ChatRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => LearningRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => PrayerRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => DuaRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => NotificationRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => AskImamRepository(apiClient: apiClient), fenix: true);
    Get.lazyPut(() => MosqueRepository(apiClient: apiClient), fenix: true);
  }
}

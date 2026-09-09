import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/auth/emergency_contacts_setup_screen.dart';
import '../../screens/permissions/microphone_permission_screen.dart';
import '../../screens/permissions/location_permission_screen.dart';
import '../../screens/permissions/bluetooth_permission_screen.dart';
import '../../screens/permissions/battery_optimization_screen.dart';
import '../../screens/sos/sos_active_screen.dart';
import '../../screens/sos/sos_history_screen.dart';
import '../../screens/sos/test_alert_screen.dart';
import '../../screens/profile/emergency_contacts_screen.dart';
import '../../screens/profile/medical_info_screen.dart';
import '../../screens/settings/detection_sensitivity_screen.dart';
import '../../screens/settings/notifications_screen.dart';
import '../../screens/settings/permissions_screen.dart';
import '../../screens/settings/offline_data_screen.dart';
import '../../screens/settings/privacy_screen.dart';
import '../../screens/settings/language_screen.dart';
import '../../screens/settings/about_screen.dart';
import '../../navigation/main_tab_shell.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const emergencyContactsSetup = '/emergency-contacts-setup';

  static const micPermission = '/permissions/microphone';
  static const locationPermission = '/permissions/location';
  static const bluetoothPermission = '/permissions/bluetooth';
  static const batteryOptimization = '/permissions/battery';

  static const main = '/main';
  static const sosActive = '/sos/active';
  static const sosHistory = '/sos/history';
  static const testAlert = '/sos/test';

  static const emergencyContacts = '/profile/emergency-contacts';
  static const medicalInfo = '/profile/medical-info';

  static const sensitivity = '/settings/sensitivity';
  static const notifications = '/settings/notifications';
  static const permissions = '/settings/permissions';
  static const offlineData = '/settings/offline-data';
  static const privacy = '/settings/privacy';
  static const language = '/settings/language';
  static const about = '/settings/about';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
    GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
    GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupScreen()),
    GoRoute(path: AppRoutes.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
    GoRoute(path: AppRoutes.resetPassword, builder: (_, __) => const ResetPasswordScreen()),
    GoRoute(
      path: AppRoutes.emergencyContactsSetup,
      builder: (_, __) => const EmergencyContactsSetupScreen(),
    ),
    GoRoute(path: AppRoutes.micPermission, builder: (_, __) => const MicrophonePermissionScreen()),
    GoRoute(path: AppRoutes.locationPermission, builder: (_, __) => const LocationPermissionScreen()),
    GoRoute(path: AppRoutes.bluetoothPermission, builder: (_, __) => const BluetoothPermissionScreen()),
    GoRoute(path: AppRoutes.batteryOptimization, builder: (_, __) => const BatteryOptimizationScreen()),
    GoRoute(path: AppRoutes.main, builder: (_, __) => const MainTabShell()),
    GoRoute(
      path: AppRoutes.sosActive,
      builder: (_, state) => SosActiveScreen(eventId: state.extra as String?),
    ),
    GoRoute(path: AppRoutes.sosHistory, builder: (_, __) => const SosHistoryScreen()),
    GoRoute(path: AppRoutes.testAlert, builder: (_, __) => const TestAlertScreen()),
    GoRoute(path: AppRoutes.emergencyContacts, builder: (_, __) => const EmergencyContactsScreen()),
    GoRoute(path: AppRoutes.medicalInfo, builder: (_, __) => const MedicalInfoScreen()),
    GoRoute(path: AppRoutes.sensitivity, builder: (_, __) => const DetectionSensitivityScreen()),
    GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: AppRoutes.permissions, builder: (_, __) => const PermissionsScreen()),
    GoRoute(path: AppRoutes.offlineData, builder: (_, __) => const OfflineDataScreen()),
    GoRoute(path: AppRoutes.privacy, builder: (_, __) => const PrivacyScreen()),
    GoRoute(path: AppRoutes.language, builder: (_, __) => const LanguageScreen()),
    GoRoute(path: AppRoutes.about, builder: (_, __) => const AboutScreen()),
  ],
);
class AppStrings {
  AppStrings._();

  static const appName = 'Tourist Safety';

  static const onboardingTitle1 = 'Detects distress automatically';
  static const onboardingBody1 =
      'Even when you cannot call for help, on-device AI listens and watches for signs of danger.';

  static const onboardingTitle2 = 'Works without internet';
  static const onboardingBody2 =
      'SMS and nearby-device relay keep your alert moving even with zero signal.';

  static const onboardingTitle3 = 'Your identity stays locked';
  static const onboardingBody3 =
      'Personal and medical details are only unlocked for a verified responder during a real emergency.';

  static const monitoringActive = 'Monitoring active';
  static const monitoringInactive = 'Monitoring paused';
  static const identityLocked = 'Identity: Locked';
  static const identityUnlocked = 'Identity: Unlocked';

  static const sosCancelPrompt = 'Cancel before sending';
  static const sosSentInternet = 'Alert sent via Internet';
  static const sosSentSms = 'Alert sent via SMS';
  static const sosSentMesh = 'Relaying via nearby devices';
  static const sosImSafe = "I'm Safe — Cancel";

  static const offlineBanner = 'No internet — SMS and mesh backup active';
}
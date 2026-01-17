class StorageKeys {
  // Auth
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String isLoggedIn = 'is_logged_in';

  // User
  static const String userProfile = 'user_profile';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  // Guest
  static const String guestSessionId = 'guest_session_data';
  static const String isGuestMode = 'is_guest_mode';

  // App Lock
  static const String pincode = 'pincode';
  static const String isPincodeEnabled = 'is_pincode_enabled';
  static const String isBiometricEnabled = 'is_biometric_enabled';

  // Settings
  static const String language = 'language';
  static const String theme = 'theme';
  static const String notificationsEnabled = 'notifications_enabled';

  // Location
  static const String lastKnownLatitude = 'last_known_latitude';
  static const String lastKnownLongitude = 'last_known_longitude';

  // Onboarding
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String appVersion = 'app_version';

  // Cache
  static const String cachedSalons = 'cached_salons';
  static const String cacheTimestamp = 'cache_timestamp';
}
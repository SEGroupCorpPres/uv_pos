class ApiConstants {
  static const String baseUrl = 'https://api.barbershop.com/v1';

  // Auth endpoints
  static const String login = '$baseUrl/admin/login';
  static const String logout = '$baseUrl/admin/logout';
  static const String refreshToken = '$baseUrl/admin/refresh-token';

  // Dashboard endpoints
  static const String dashboard = '$baseUrl/admin/dashboard';
  static const String stats = '$baseUrl/admin/stats';

  // Barbers endpoints
  static const String barbers = '$baseUrl/admin/barbers';
  static String barberById(int id) => '$baseUrl/admin/barbers/$id';

  // Services endpoints
  static const String services = '$baseUrl/admin/services';
  static String serviceById(int id) => '$baseUrl/admin/services/$id';

  // Bookings endpoints
  static const String bookings = '$baseUrl/admin/bookings';
  static String bookingById(int id) => '$baseUrl/admin/bookings/$id';
  static const String updateBookingStatus = '$baseUrl/admin/bookings/status';

  // Customers endpoints
  static const String customers = '$baseUrl/admin/customers';
  static String customerById(int id) => '$baseUrl/admin/customers/$id';

  // Reports endpoints
  static const String revenueReport = '$baseUrl/admin/reports/revenue';
  static const String bookingReport = '$baseUrl/admin/reports/bookings';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
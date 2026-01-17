import 'package:uv_pos/core/core.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    notifyListeners();
  }

  void signIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void signOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

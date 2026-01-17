import 'package:uv_pos/core/core.dart';

sealed class NetworkStatus {
  Future<bool> get isConnected;
}

class NetworkStatusImp implements NetworkStatus {
  NetworkStatusImp(this.internetConnection);

  final InternetConnection internetConnection;

  @override
  Future<bool> get isConnected async => await internetConnection.hasInternetAccess;
}


import 'package:uv_pos/core/core.dart';

/// Token entity
class TokenEntity extends Equatable {
  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
    this.tokenType = 'Bearer',
  });

  final String accessToken;
  final String refreshToken;
  final int? expiresIn;
  final String tokenType;

  bool get isExpired {
    if (expiresIn == null) return false;
    // Implement expiration logic
    return false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenEntity && runtimeType == other.runtimeType && accessToken == other.accessToken;

  @override
  int get hashCode => accessToken.hashCode;

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresIn, tokenType];
}

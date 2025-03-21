
import 'dart:convert';

class Dimensions {
  final double? width;
  final double? height;
  final double? depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  Dimensions copyWith({
    double? width,
    double? height,
    double? depth,
  }) =>
      Dimensions(
        width: width ?? this.width,
        height: height ?? this.height,
        depth: depth ?? this.depth,
      );

  factory Dimensions.fromJson(String str) => Dimensions.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Dimensions.fromMap(Map<String, dynamic> json) => Dimensions(
    width: json["width"]?.toDouble(),
    height: json["height"]?.toDouble(),
    depth: json["depth"]?.toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "width": width,
    "height": height,
    "depth": depth,
  };
}

import 'package:meta/meta.dart';
import 'dart:convert';




class Meta {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String? qrCode;

  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  Meta copyWith({
    String? createdAt,
    String? updatedAt,
    String? barcode,
    String? qrCode,
  }) =>
      Meta(
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        barcode: barcode ?? this.barcode,
        qrCode: qrCode ?? this.qrCode,
      );

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    barcode: json["barcode"],
    qrCode: json["qrCode"],
  );

  Map<String, dynamic> toMap() => {
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "barcode": barcode,
    "qrCode": qrCode,
  };
}


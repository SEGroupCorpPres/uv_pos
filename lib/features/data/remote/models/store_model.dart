import 'package:equatable/equatable.dart';

class StoreModel extends Equatable {
  final String id;
  final String uid;
  final String name;
  final String description;
  final String phone;
  final String? imageUrl;
  final String address;

  const StoreModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.phone,
    this.imageUrl,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, description, phone, imageUrl, address];

  // Factory constructor to create a Store instance from a map
  factory StoreModel.fromMap(Map<String, dynamic> data) {
    return StoreModel(
      id: data['id'] as String,
      uid: data['uid'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      phone: data['phone'] as String,
      imageUrl: data['imageUrl'] as String?,
      address: data['address'] as String,
    );
  }

  // Convert Store instance to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'description': description,
      'phone': phone,
      'imageUrl': imageUrl,
      'address': address,
    };
  }

  StoreModel copyWith({
    String? id,
    String? name,
    String? uid,
    String? description,
    String? phone,
    String? imageUrl,
    String? address,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      uid: uid ?? this.uid,
      address: address ?? this.address,
    );
  }
}

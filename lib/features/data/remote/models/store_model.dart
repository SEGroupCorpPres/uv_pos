import 'package:equatable/equatable.dart';

class StoreModel extends Equatable {
  final String id;
  final String uid;
  final String name;
  final String description;
  final String phone;
  final String imageUrl;
  final String address;

  const StoreModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.phone,
    required this.imageUrl,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, description, phone, imageUrl, address];

  // Factory constructor to create a Store instance from a map
  factory StoreModel.fromMap(Map<String, dynamic> data) {
    return StoreModel(
      id: data['id'],
      uid: data['uid'],
      name: data['name'],
      description: data['description'],
      phone: data['phone'],
      imageUrl: data['imageUrl'],
      address: data['address'],
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
}

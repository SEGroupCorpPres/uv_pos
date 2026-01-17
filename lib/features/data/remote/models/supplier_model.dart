
class SupplierModel {
  final String id; // Unique supplier ID
  final String name; // Supplier nomi
  final String phone; // Telefon raqami
  final String email; // Email
  final String address; // Manzil
  final DateTime createdAt; // Qachon qo'shilgan

  SupplierModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.createdAt,
  });

  factory SupplierModel.fromMap(Map<String, dynamic> data) {
    return SupplierModel(
      id: data['id'] as String,
      name: data['name'] as String,
      phone: data['phone'] as String,
      email: data['email'] as String,
      address: data['address'] as String,
      createdAt: data['created_at'] as DateTime,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'created_at': createdAt,
    };
  }

  SupplierModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    DateTime? createdAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

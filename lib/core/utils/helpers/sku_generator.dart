class SKUGenerator {
  final String? categoryCode; // Masalan: "DR" (Drink)
  final String? productName; // Masalan: "Coca Cola 1.5L"
  final int? sequenceNumber; // Masalan: 1, 2, 3...

  // Ichki maydon (private)
  String? _sku;

  SKUGenerator({
    required this.categoryCode,
    required this.productName,
    required this.sequenceNumber,
  });

  // SKU Getter (avtomatik generatsiya qiladi agar mavjud bo'lmasa)
  String get sku {
    if (_sku != null) return _sku!;

    String shortName = productName!
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '') // Belgilarni tozalash
        .toUpperCase();

    if (shortName.length > 6) {
      shortName = shortName.substring(0, 6);
    }

    String seq = sequenceNumber.toString().padLeft(3, '0');
    return "$categoryCode-$shortName-$seq";
  }

  // SKU Setter (qo‘lda berish uchun)
  set sku(String value) {
    _sku = value.toUpperCase(); // Kiritilgan SKU ni upper case qilamiz
  }
}

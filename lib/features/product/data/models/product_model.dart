class Product {
  final int? id;
  final String name;
  final String category;
  final String type; // 'BAHAN' or 'CAFE'
  final double buyPrice;
  final double sellPrice;
  final double stock;
  final String unit;
  final DateTime createdAt;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.buyPrice,
    required this.sellPrice,
    required this.stock,
    required this.unit,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'type': type,
      'buy_price': buyPrice,
      'sell_price': sellPrice,
      'stock': stock,
      'unit': unit,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      type: map['type'],
      buyPrice: map['buy_price'],
      sellPrice: map['sell_price'],
      stock: map['stock'],
      unit: map['unit'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? category,
    String? type,
    double? buyPrice,
    double? sellPrice,
    double? stock,
    String? unit,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      type: type ?? this.type,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      stock: stock ?? this.stock,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

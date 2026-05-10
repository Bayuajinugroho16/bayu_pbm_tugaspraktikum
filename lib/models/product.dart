class Product {
  final int? id;
  final String name;
  final int price; // tetap int
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Perbaikan: handle price yang berupa String
    int parsedPrice = 0;
    if (json['price'] != null) {
      if (json['price'] is int) {
        parsedPrice = json['price'];
      } else if (json['price'] is String) {
        // Ubah String "200000.00" menjadi int 200000
        parsedPrice = double.parse(json['price']).toInt();
      }
    }

    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      price: parsedPrice,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'description': description};
  }
}

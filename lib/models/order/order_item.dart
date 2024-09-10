


class OrderItem {
  final String category;
  final int color;
  final String description;
  final int id;
  final String image;
  final double price;
  final int quantity;
  final String title;
  final double totalPrice;

  OrderItem({
    required this.category,
    required this.color,
    required this.description,
    required this.id,
    required this.image,
    required this.price,
    required this.quantity,
    required this.title,
    required this.totalPrice,
  });

  // Convert OrderItem to a Map
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'color': color,
      'description': description,
      'id': id,
      'image': image,
      'price': price,
      'quantity': quantity,
      'title': title,
      'totalPrice': totalPrice,
    };
  }

  // Create OrderItem from a Map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      category: map['category'],
      color: map['color'],
      description: map['description'],
      id: map['id'],
      image: map['image'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
      title: map['title'],
      totalPrice: map['totalPrice'].toDouble(),
    );
  }
}

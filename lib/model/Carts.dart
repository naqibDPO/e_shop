
class Order {
  String deliveryAddress;
  String deliveryTime;
  String deliveryDate;
  List<CartItem> cartProducts;

  Order({
    required this.deliveryAddress,
    required this.deliveryTime,
    required this.deliveryDate,
    required this.cartProducts,
  });

  // Convert Order object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'deliveryAddress': deliveryAddress,
      'deliveryTime': deliveryTime,
      'deliveryDate': deliveryDate,
      'cartProducts': cartProducts.map((cartItem) => cartItem.toJson()).toList(),
    };
  }

  // Create Order object from a JSON map
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      deliveryAddress: json['deliveryAddress'],
      deliveryTime: json['deliveryTime'],
      deliveryDate: json['deliveryDate'],
      cartProducts: (json['cartProducts'] as List)
          .map((itemJson) => CartItem.fromJson(itemJson))
          .toList(),
    );
  }
  String getCartProductTitles() {
    return cartProducts.map((item) => item.title).join(", ");
  }
}


class CartItem {
  String title;
  int price;
  int quantity;
  String image;

  CartItem({
    required this.title,
    required this.price,
    required this.quantity,
    required this.image,
  });

  // Convert CartItem object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'quantity': quantity,
      'image': image
    };
  }

  // Create CartItem object from a JSON map
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      image: json['image']
    );
  }

}

class Product {
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final String description;

  Product({
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.isFavorite = false,
    required this.description,
  });
}

final List<Product> products = [
  Product(
    name: 'Shoes',
    category: 'Footwear',
    price: 69.00,
    oldPrice: 189.00,
    imageUrl: 'Frontend/assets/images/shoe.jpg',
    description: 'Stylish and comfortable shoes for everyday wear.',
  ),
    Product(
        name: 'Watch',
        category: 'Accessories',
        price: 199.00,
        oldPrice: 299.00,
        imageUrl: 'Frontend/assets/images/shoe2.jpg',
        description: 'Elegant watch with a classic design.',
    ),
    Product(
        name: 'T-Shirt',
        category: 'Clothing',
        price: 29.00,
        oldPrice: 49.00,
        imageUrl: 'Frontend/assets/images/shoes2.jpg',
        description: 'Casual t-shirt made from soft cotton.',
    ),
    Product(
        name: 'Backpack',
        category: 'Bags',
        price: 89.00,
        oldPrice: 129.00,
        imageUrl: 'Frontend/assets/images/laptop.jpg',
        description: 'Durable backpack for daily use.',
    ),

];

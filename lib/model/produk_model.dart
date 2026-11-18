class Produk{
  final String id;
  final String name;
  final double price;
  final String category;

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
});
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(), // pakai 'num' biar aman untuk int maupun double
      category: json['category'],
    );
  }
}

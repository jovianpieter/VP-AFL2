import 'produk_model.dart';

class CartItem{
  final Produk product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
});
}
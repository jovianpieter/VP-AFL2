import 'package:flutter/foundation.dart';

import '../model/produk_model.dart';
import '../model/cart_item_model.dart';
import '../model/repository/produk_repository.dart';

class KasirViewModel extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  List<Produk> _products = [];
  bool _isLoading = false;
  String _selectedCategory = 'Semua';
  final List<CartItem> _cart = [];
  double _cashReceived = 0.0;
  String? _errorMessage;

  KasirViewModel() {
    loadProducts();
  }

  bool get isLoading => _isLoading;

  String get selectedCategory => _selectedCategory;

  List<CartItem> get cart => List.unmodifiable(_cart);

  double get cashReceived => _cashReceived;

  String? get errorMessage => _errorMessage;

  List<Produk> get filteredProducts {
    if (_selectedCategory == 'Semua') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  int get totalItems {
    int total = 0;
    for (var item in _cart) {
      total += item.quantity;
    }
    return total;
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _cart) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  double get changeAmount {
    if (_cashReceived >= totalPrice) {
      return _cashReceived - totalPrice;
    } else {
      return 0.0;
    }
  }

  bool get isPaymentValid => _cart.isNotEmpty && _cashReceived >= totalPrice;

  Future<bool> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Gagal memuat daftar menu.';
      notifyListeners();
      return false;
    }
  }

  bool selectCategory(String category) {
    if (_selectedCategory == category) return false;
    _selectedCategory = category;
    notifyListeners();
    return true;
  }

  bool addToCart(Produk product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
    return true;
  }

  bool decrementItem(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index == -1) return false;
    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    } else {
      _cart.removeAt(index);
    }
    notifyListeners();
    return true;
  }

  bool setCashReceived(double amount) {
    if (amount < 0) return false;
    _cashReceived = amount;
    notifyListeners();
    return true;
  }

  bool processCheckout() {
    if (!isPaymentValid) {
      return false;
    }
    _cart.clear();
    _cashReceived = 0.0;
    notifyListeners();
    return true;
  }
}

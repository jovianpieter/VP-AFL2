import 'package:flutter/material.dart';

import '../viewmodel/kasir_viewmodel.dart';
import 'checkout_view.dart';

class KasirView extends StatefulWidget {
  const KasirView({super.key});
  @override
  State<KasirView> createState() => _KasirViewState();
}

class _KasirViewState extends State<KasirView> {
  final KasirViewModel _vm = KasirViewModel();
  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', 'Makanan', 'Minuman', 'Snack'];
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Mini Kasir')),
          body: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _vm.selectedCategory == category,
                        onSelected: (_) => _vm.selectCategory(category),
                      ),
                    );
                  }).toList(),
                ),
              ),
            Expanded(
              child: _vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _vm.filteredProducts.isEmpty
                  ? Center(child: Text(_vm.errorMessage ?? 'Menu tidak tersedia'))
                  : ListView.builder(
                itemCount: _vm.filteredProducts.length,
                itemBuilder: (context, index) {
                  final produk = _vm.filteredProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(produk.name),
                      subtitle: Text(
                        '${produk.category} • Rp ${produk.price.toStringAsFixed(0)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue),
                        onPressed: () {
                          if (_vm.addToCart(produk)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${produk.name} masuk keranjang'),
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ],
          ),
          bottomNavigationBar: _vm.cart.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${_vm.totalItems} Item dipilih'),
                          Text(
                            'Total: Rp ${_vm.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutView(viewModel: _vm),
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

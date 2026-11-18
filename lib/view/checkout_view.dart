import 'package:flutter/material.dart';
import '../viewmodel/kasir_viewmodel.dart';

class CheckoutView extends StatelessWidget {
  final KasirViewModel viewModel;
  const CheckoutView({super.key, required this.viewModel});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Pembayaran')),
          body: Column(
            children: [
              Expanded(
                child: viewModel.cart.isEmpty
                    ? const Center(child: Text('Keranjang kosong'))
                    : ListView.builder(
                  itemCount: viewModel.cart.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.cart[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text('Rp ${item.product.price.toStringAsFixed(0)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => viewModel.decrementItem(item.product.id),
                          ),
                          Text(
                            '${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => viewModel.addToCart(item.product),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total Belanja: Rp ${viewModel.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Uang Tunai Diterima (Rp)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        double nominal = double.tryParse(value) ?? 0.0;
                        viewModel.setCashReceived(nominal);
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kembalian: Rp ${viewModel.changeAmount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.isPaymentValid ? () {
                        if (viewModel.processCheckout()) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaksi Berhasil!')),);
                          Navigator.pop(context);
                        }
                      } : null, child: const Text('Bayar Sekarang'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
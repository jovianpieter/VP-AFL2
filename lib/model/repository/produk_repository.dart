import '../produk_model.dart';
import '../service/produk_service.dart';

class ProductRepository {
  final ProdukService _service = ProdukService();

  Future<List<Produk>> getProducts() async {
    final rawList = await _service.fetchRawProducts();
    return rawList.map((json) => Produk.fromJson(json)).toList();
  }
}
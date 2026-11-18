import 'dart:convert';
import 'package:flutter/services.dart';

class ProdukService {
  Future<List<dynamic>> fetchRawProducts() async {
    final String jsonString = await rootBundle.loadString('data.json');
    return jsonDecode(jsonString) as List<dynamic>;
  }
}
import 'package:daily_bloom/product/domain/dao/product_dao/product.dart';
import 'package:daily_bloom/product/domain/dao/product_dao/product_dao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  ProductDao? _productDao;
  List<ProductDao> _productList = [];
  Future<void> _fetchProduct() async {
    try {
      dynamic product = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );
      _productDao = ProductDao.fromJson(product);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("product")),
      body: _hasError
          ? Text("Somethnig went wrong")
          : _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: (ProductDao.products ?? []).length,
              itemBuilder: (BuildContext context, int index) {Products? products = _productDao?Products![];
              return)},
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ApiService _api = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _products = await _api.getProducts();
    } catch (e) {
      _errorMessage = 'Gagal memuat produk: $e';
    }

    setState(() => _isLoading = false);
  }

  Future<void> _addProduct() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add_box, color: Color(0xFFF64668)),
            SizedBox(width: 8),
            Text('Tambah Produk'),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                prefixIcon: Icon(Icons.shopping_bag, color: Color(0xFF984063)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Harga',
                prefixIcon: Icon(Icons.attach_money, color: Color(0xFF984063)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: Icon(Icons.description, color: Color(0xFF984063)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Color(0xFFFE9677))),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty || priceController.text.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Lengkapi data produk')));
                return;
              }

              final success = await _api.createProduct(
                nameController.text,
                int.tryParse(priceController.text) ?? 0,
                descController.text,
              );

              Navigator.pop(context);

              if (success) {
                _loadProducts();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Produk berhasil ditambahkan')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menambahkan produk')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF41436A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Produk'),
        content: Text('Yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: TextStyle(color: Color(0xFFFE9677))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: Color(0xFFF64668))),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _api.deleteProduct(id);
      if (success) {
        _loadProducts();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Produk dihapus')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFE9677).withOpacity(0.1),
      appBar: AppBar(
        title: Text(
          'Katalog Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF41436A),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF41436A), Color(0xFF984063)],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _api.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF64668)),
              ),
            )
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Color(0xFFF64668)),
                  SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Color(0xFF984063)),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadProducts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF41436A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : _products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Color(0xFFFE9677)),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada produk',
                    style: TextStyle(fontSize: 16, color: Color(0xFF984063)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Color(0xFFFE9677).withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFF64668),
                        child: Text(
                          product.name[0].toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF41436A),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Rp ${product.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF64668),
                            ),
                          ),
                          Text(
                            product.description,
                            style: TextStyle(color: Color(0xFF984063)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Color(0xFFFE9677),
                        ),
                        onPressed: () => _deleteProduct(product.id!),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF64668), Color(0xFFFE9677)],
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: _addProduct,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

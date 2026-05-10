import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'product_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _api = ApiService();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    String nim = _nimController.text.trim();
    String password = _passwordController.text.trim();

    if (nim.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Masukkan NIM dan Password')));
      setState(() => _isLoading = false);
      return;
    }

    String? token = await _api.login(nim, password);

    setState(() => _isLoading = false);

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/products');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal, periksa NIM Anda')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF41436A), // ungu gelap
              Color(0xFF984063), // magenta gelap
              Color(0xFFF64668), // merah muda
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Color(0xFFFE9677).withOpacity(0.1)],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF64668), Color(0xFFFE9677)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Product Catalog',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [Color(0xFF41436A), Color(0xFF984063)],
                            ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                        ),
                      ),
                      Text(
                        'Tugas Praktikum PBM',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF984063),
                        ),
                      ),
                      SizedBox(height: 32),
                      // NIM Field
                      TextField(
                        controller: _nimController,
                        decoration: InputDecoration(
                          labelText: 'NIM',
                          hintText: 'Masukkan NIM Anda',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Color(0xFFF64668),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFE9677)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFF64668),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFE9677)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Masukkan Password',
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFFF64668),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFE9677)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFF64668),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFFE9677)),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFF41436A),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text('Login', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

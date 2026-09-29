import 'package:flutter/material.dart';
import 'package:kuis/data/users_data.dart';
import 'package:kuis/models/user.dart';
import 'package:kuis/screens/root_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoggedIn = false;
  bool isLoginFailed = false;

  /// User yang berhasil login
  User? _loggedInUser;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Proses login: cek ke SEMUA user di allowedUsers
  void _login() {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    // Validasi input kosong
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        isLoggedIn = false;
        isLoginFailed = true;
        _loggedInUser = null;
      });
      _showSnackBar('NIM dan password tidak boleh kosong!');
      return;
    }

    // Loop semua user untuk mencari yang cocok
    User? foundUser;
    for (final user in allowedUsers) {
      if (user.credentialsMatch(username, password)) {
        foundUser = user;
        break;
      }
    }

    if (foundUser != null) {
      // ✅ Promosi ke variabel lokal non-nullable
      // supaya tidak error saat dipakai di dalam closure (builder)
      final User user = foundUser;

      setState(() {
        isLoggedIn = true;
        isLoginFailed = false;
        _loggedInUser = user;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RootScreen(userName: user.nama),
        ),
      );
    } else {
      setState(() {
        isLoggedIn = false;
        isLoginFailed = true;
        _loggedInUser = null;
      });
      _showSnackBar('Login gagal! NIM atau password tidak sesuai.');
    }
  }

  /// Helper menampilkan SnackBar error
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Widget input field reusable
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required bool isLoginFailed,
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        enabled: true,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isLoginFailed ? Colors.red : const Color(0xFF00897B),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isLoginFailed ? Colors.red : const Color(0xFF00897B),
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isLoggedIn) ...[
                  const Icon(
                    Icons.pets_rounded,
                    size: 80,
                    color: Color(0xFF00897B),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Animal Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login untuk memulai',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  _inputField(
                    controller: _usernameController,
                    hint: 'Username (NIM)',
                    isLoginFailed: isLoginFailed,
                  ),
                  const SizedBox(height: 16),
                  _inputField(
                    controller: _passwordController,
                    hint: 'Password (Program Studi)',
                    isLoginFailed: isLoginFailed,
                    obscure: true,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor:
                          const Color(0xFF00897B).withValues(alpha: 0.4),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'NIM: 9 digit | Password: nama prodi',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ] else ...[
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 80,
                    color: Color(0xFF00897B),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Login Berhasil, ${_loggedInUser?.nama ?? 'User'}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final User? user = _loggedInUser;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => RootScreen(
                            userName: user?.nama ?? 'Pelanggan',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ke Halaman Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
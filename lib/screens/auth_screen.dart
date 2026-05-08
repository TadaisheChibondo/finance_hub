import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart'; // We'll navigate here after login
import '../main.dart'; // To access MainNavigator

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _isLogin = true; // Toggle between Login and Sign Up

  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      if (_isLogin) {
        // LOGIN
        await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // SIGN UP
        final AuthResponse res = await supabase.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          data: {'full_name': _nameController.text.trim()}, // Save name
        );

        // Create a record in the students table for the new user
        if (res.user != null) {
          await supabase.from('students').insert({
            'id': res.user!.id,
            'balance': 0.00, // Starting balance
            // Add other default fields here if needed by your DB
          });
        }
      }

      // If successful, go to the Main Navigator (Dashboard + Tabs)
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigator()),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: const Color(0xFFFF5C5C),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred'),
          backgroundColor: Color(0xFFFF5C5C),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0D0F14);
    const card = Color(0xFF1E2330);
    const green = Color(0xFF00E5A0);
    const textPrimary = Color(0xFFEEF0F6);
    const textSecondary = Color(0xFF8A90A2);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.account_balance_wallet, size: 64, color: green),
                const SizedBox(height: 24),
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Sign in to manage your finances'
                      : 'Sign up to get started',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Name Field (Only for Sign Up)
                if (!_isLogin) ...[
                  _buildTextField(
                    _nameController,
                    'Full Name',
                    Icons.person_outline,
                    card,
                    textPrimary,
                    textSecondary,
                  ),
                  const SizedBox(height: 16),
                ],

                // Email Field
                _buildTextField(
                  _emailController,
                  'Email',
                  Icons.email_outlined,
                  card,
                  textPrimary,
                  textSecondary,
                ),
                const SizedBox(height: 16),

                // Password Field
                _buildTextField(
                  _passwordController,
                  'Password',
                  Icons.lock_outline,
                  card,
                  textPrimary,
                  textSecondary,
                  isPassword: true,
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: bg,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isLoading ? null : _authenticate,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: bg)
                      : Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // Toggle Login/Signup
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Login",
                    style: const TextStyle(color: green),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    Color cardColor,
    Color textPrimary,
    Color textSecondary, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: textSecondary),
        prefixIcon: Icon(icon, color: textSecondary),
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

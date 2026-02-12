import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart'; // Import your controller

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  //Create an instance of the controller
  final AuthController _authController = AuthController();

  //The function to trigger login
  void _handleLogin() async {
    final success = await _authController.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (mounted) { // Check if the screen is still visible
      if (success) {
        // Success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome back, ${_authController.user?.name}!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Failure Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid registration number or password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              "DiCoMan",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Registration Number",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // 3. The Button wrapped in a ListenableBuilder
            ListenableBuilder(
              listenable: _authController,
              builder: (context, child) {
                return FilledButton(
                  // Disable button by passing null to onPressed if loading
                  onPressed: _authController.isLoading ? null : _handleLogin,
                  child: _authController.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Login"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
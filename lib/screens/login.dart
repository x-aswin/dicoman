import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{
  LoginScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(24.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
          //logo
          const Icon(Icons.school,size: 80, color: Colors.blueAccent,),
          const SizedBox(height: 16,),
          Text("DiCoMan", textAlign: TextAlign.center,style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),),const SizedBox(height: 32,),

          //username field
          TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Registration Number",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(), // Material 3 look
              ),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true, // Hides the password
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            //button
            FilledButton(
              onPressed: () {
                // For now, let's just print the values
                print("Username: ${_usernameController.text}");
              },
              child: const Text("Login"),
            ),
      ],
      )
    )
    );
  }
}
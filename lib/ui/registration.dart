import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthResponse? response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            // Champ mot de passe (masqué)
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // Bouton d'inscription
            ElevatedButton(
              onPressed: () async {
                try {
                  // Appel à l'API Supabase pour l'inscription
                  response = await supabase.auth.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                } catch (e) {
                  if (mounted) context.showSnackBar(e.toString(), isError: true);
                }
                // Retour à l'écran de login si inscription réussie
                if (response?.user != null) {
                  Navigator.pop(context);
                } else {
                  if (mounted) {
                    context.showSnackBar('Registration error', isError: true);
                  }
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/ui/profil.dart';
import '/ui/registration.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthResponse? response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
            // Bouton de connexion
            ElevatedButton(
              onPressed: () async {
                try {
                  // Appel à l'API Supabase pour la connexion
                  response = await supabase.auth.signInWithPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                } catch (e) {
                  if (mounted) context.showSnackBar(e.toString(), isError: true);
                }
                // Navigation vers le profil si connexion réussie
                if (response?.user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileForm()),
                  );
                }
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            // Bouton vers l'écran d'inscription
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
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
    // Libération des contrôleurs pour éviter les fuites mémoire
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

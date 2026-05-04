import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chargement des variables d'environnement depuis .env
  await dotenv.load(fileName: '.env');

  // Initialisation de Supabase avec les identifiants du fichier .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MaterialApp(home: LoginScreen()));
}

// Instance globale du client Supabase, accessible depuis tous les fichiers
final supabase = Supabase.instance.client;

// Extension utilitaire sur BuildContext pour afficher des SnackBars
extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}

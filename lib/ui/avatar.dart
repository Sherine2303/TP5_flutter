import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  // Callback appelé après un upload réussi, avec l'URL signée
  final void Function(String) onUpload;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Affichage de l'avatar ou placeholder si absent
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            color: Colors.grey,
            child: const Center(child: Text('No Image')),
          )
        else
          Image.network(
            widget.imageUrl!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        const SizedBox(height: 8),
        // Bouton d'upload (désactivé pendant le chargement)
        ElevatedButton(
          onPressed: _isLoading ? null : _upload,
          child: const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    // Sélection d'une image depuis la galerie, redimensionnée à 300x300 max
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) return;

    setState(() => _isLoading = true);
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      // Nom de fichier unique basé sur le timestamp
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';

      // Upload binaire dans le bucket "avatars" de Supabase Storage
      await supabase.storage.from('avatars').uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );

      // Génération d'une URL signée valable 10 ans (60s * 60m * 24h * 365j * 10)
      final signedUrl = await supabase.storage
          .from('avatars')
          .createSignedUrl(fileName, 60 * 60 * 24 * 365 * 10);

      // Transmission de l'URL au widget parent via le callback
      widget.onUpload(signedUrl);
    } on StorageException catch (error) {
      if (mounted) context.showSnackBar(error.message, isError: true);
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    }
    setState(() => _isLoading = false);
  }
}

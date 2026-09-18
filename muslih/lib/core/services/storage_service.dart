import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final SupabaseClient _client;

  StorageService(this._client);

  final _picker = ImagePicker();

  /// اختيار صورة من المعرض
  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image == null) return null;
    return File(image.path);
  }

  /// رفع صورة إلى Supabase Storage
  Future<String?> uploadImage({
    required File file,
    required String bucket,
    required String path,
  }) async {
    try {
      final fileExtension = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final fullPath = '$path/$fileName';

      await _client.storage.from(bucket).upload(
            fullPath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = _client.storage.from(bucket).getPublicUrl(fullPath);
      return publicUrl;
    } catch (e) {
      return null;
    }
  }
}

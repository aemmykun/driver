import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ReceiptService {
  ReceiptService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();
  final ImagePicker _picker;
  static const _uuid = Uuid();

  Future<String?> capture() async {
    final selected = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 2200,
    );
    if (selected == null) return null;
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(documents.path, 'receipts'));
    await directory.create(recursive: true);
    final extension = p.extension(selected.path).isEmpty ? '.jpg' : p.extension(selected.path);
    final target = p.join(directory.path, '${_uuid.v4()}$extension');
    await File(selected.path).copy(target);
    return target;
  }
}

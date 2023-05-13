import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:intl/intl.dart';

class PdfApi {
  static Future<File> saveDocument({required String name, required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future<File> saveDocuments({required String name, required Document pdf, required String maPB
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    uploadFile(file,maPB);

    return file;
  }

  static Future<void> uploadFile(File pdf,String maPB) async {
    try {
      File file = File(pdf.path);
      FirebaseStorage.instance
          .ref('PhieuKiemKe/$maPB')
          .child("Ngay_Kiem_Ke: ${DateFormat('dd_MM_yyyy').format(DateTime.now())}")
          .putFile(file);
    } catch (e) {
      print("Lỗi upload ảnh: " + e.toString());
    }
  }

  static Future openFiles(String url) async {
    await OpenFile.open(url);
  }
}

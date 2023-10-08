// ignore_for_file: use_build_context_synchronously
import 'package:enableorg/ui/custom_button.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ManagerUserUploadForm extends StatelessWidget {
  final Function(List<List<dynamic>>) onCSVUpload;

  ManagerUserUploadForm({required this.onCSVUpload});

  Future<void> _handleFileUpload(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.single.bytes;
      if (fileBytes != null) {
        final excel = Excel.decodeBytes(fileBytes);
        final sheet = excel.tables[excel.tables.keys.first];
        final excelData = sheet?.rows
            .map((row) => row.map((cell) => cell?.value).toList())
            .toList();

        onCSVUpload(excelData!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel uploaded successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomButton(
            onPressed: () => _handleFileUpload(context),
            width: 200,
            text: Text(
              '+ Upload',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Cormorant Garamond',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

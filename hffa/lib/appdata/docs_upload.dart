import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';

class UploadWidget extends StatefulWidget {
  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  Future<void> _uploadDataFromExcel() async {
    // Pick an Excel file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;
      if (fileBytes == null) {
        // Handle platforms where path is valid (e.g., mobile)
        String? filePath = result.files.single.path;
        if (filePath != null) {
          var file = File(filePath);
          fileBytes = await file.readAsBytes();
        } else {
          print('File not picked correctly.');
          return;
        }
      }

      var excel = Excel.decodeBytes(fileBytes);

      // Reference to Firestore collection
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('customers');

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];

        if (sheet != null) {
          for (var i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];

            try {
              // Create a map to hold the document data with null checks
              Map<String, dynamic> data = {
                'surname': row[0]?.value?.toString().trim() ?? '',
                'name': row[1]?.value?.toString().trim() ?? '',
                'phone': row[2]?.value != null
                    ? row[2]!.value.toString().trim()
                    : 'N/A',
              };

              // Validate the data (e.g., check if phone is valid)
              if (data['surname'].isNotEmpty &&
                  data['name'].isNotEmpty &&
                  data['phone'] != 'N/A') {
                // Upload data to Firestore
                await collectionRef.add(data);
                print('Document added successfully: $data');
              } else {
                print('Skipped row due to missing data: $data');
              }
            } catch (e) {
              print('Error adding document: $e');
            }
          }
        }
      }
    } else {
      print('File not picked.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _uploadDataFromExcel,
          child: Text('Upload Excel Data'),
        ),
      ),
    );
  }
}

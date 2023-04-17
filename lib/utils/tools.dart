import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  final XFile? file = await _imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  print("Không có ảnh được chọn");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}

//mobile_scanner_screen

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String? barcode;
  MobileScannerController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcodeCapture) {
          setState(() {
            barcode = barcodeCapture.barcodes.first.rawValue;
          });
          // Process the barcode here (e.g., add book to database)
          if (barcode != null) {
            print('Barcode: $barcode');
            // Navigate back and pass the barcode value
            Navigator.pop(context, barcode);
          }
        },
      ),
    );
  }
}
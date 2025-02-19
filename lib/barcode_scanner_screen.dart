//barcode_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String? barcode;
  MobileScannerController? controller;
  bool isScanning = true; // Track scanning state

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover, // Make scanner fill the screen
            onDetect: (barcodeCapture) {
              if (isScanning) { // Only process if scanning is active
                setState(() {
                  barcode = barcodeCapture.barcodes.first.rawValue;
                  isScanning = false; // Stop scanning after detection
                });

                if (barcode != null) {
                  controller?.stop(); // Stop the camera
                  Navigator.pop(context, barcode); // Return the barcode
                }
              }
            },
          ),
          Center( // Overlay a "Scanning..." indicator
            child: isScanning
                ? const Text(
              "Scanning...",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
                : const SizedBox.shrink(), // Empty widget when not scanning
          ),
        ],
      ),
    );
  }
}
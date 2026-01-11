import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/models/device_credentials.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;
  bool _torchEnabled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Parse QR code data
      final credentials = DeviceCredentials.fromQrCode(rawValue);

      if (mounted) {
        // Return credentials to previous screen
        Navigator.of(context).pop(credentials);
      }
    } catch (e) {
      if (mounted) {
        // Afficher l'erreur et permettre de réessayer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('QR code invalide : ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner le QR Code ESP32'),
        actions: [
          IconButton(
            icon: Icon(
              _torchEnabled ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: () {
              setState(() {
                _torchEnabled = !_torchEnabled;
              });
              _controller.toggleTorch();
            },
            tooltip: 'Activer/désactiver la lampe',
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => _controller.switchCamera(),
            tooltip: 'Changer de caméra',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera preview
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay with scanning frame
          CustomPaint(
            painter: ScannerOverlayPainter(),
            child: Container(),
          ),

          // Instructions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Scannez le QR code affiché sur votre ESP32',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Assurez-vous que le QR code est clairement visible et bien éclairé',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                  if (_isProcessing) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for the scanner overlay with scanning frame
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;
    final rect = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);

    // Draw semi-transparent overlay
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12))),
      ),
      backgroundPaint,
    );

    // Draw corners
    final cornerPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final cornerLength = 30.0;

    // Top-left
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), cornerPaint);

    // Top-right
    canvas.drawLine(Offset(left + scanAreaSize, top), Offset(left + scanAreaSize - cornerLength, top), cornerPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top), Offset(left + scanAreaSize, top + cornerLength), cornerPaint);

    // Bottom-left
    canvas.drawLine(Offset(left, top + scanAreaSize), Offset(left + cornerLength, top + scanAreaSize), cornerPaint);
    canvas.drawLine(Offset(left, top + scanAreaSize), Offset(left, top + scanAreaSize - cornerLength), cornerPaint);

    // Bottom-right
    canvas.drawLine(Offset(left + scanAreaSize, top + scanAreaSize), Offset(left + scanAreaSize - cornerLength, top + scanAreaSize), cornerPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top + scanAreaSize), Offset(left + scanAreaSize, top + scanAreaSize - cornerLength), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import '../../core/models/device_credentials.dart';
import 'qr_scanner_screen.dart';

class IpConfigDialog extends StatefulWidget {
  final String? currentIp;

  const IpConfigDialog({Key? key, this.currentIp}) : super(key: key);

  @override
  State<IpConfigDialog> createState() => _IpConfigDialogState();
}

class _IpConfigDialogState extends State<IpConfigDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentIp ?? '192.168.');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _validateIp(String ip) {
    // Basic IP validation regex
    final ipRegex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipRegex.hasMatch(ip);
  }

  void _handleSubmit() {
    final ip = _controller.text.trim();

    if (ip.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an IP address';
      });
      return;
    }

    if (!_validateIp(ip)) {
      setState(() {
        _errorMessage = 'Invalid IP format (e.g., 192.168.1.100)';
      });
      return;
    }

    // Return DeviceCredentials with IP but no token (manual entry)
    final credentials = DeviceCredentials(
      ipAddress: ip,
      authToken: '', // No token for manual entry
    );
    Navigator.of(context).pop(credentials);
  }

  Future<void> _handleQrScan() async {
    try {
      final credentials = await Navigator.of(context).push<DeviceCredentials>(
        MaterialPageRoute(
          builder: (context) => const QrScannerScreen(),
          fullscreenDialog: true,
        ),
      );

      if (credentials != null && mounted) {
        // Return the scanned credentials
        Navigator.of(context).pop(credentials);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'QR scan failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.router, color: Colors.white70),
          SizedBox(width: 12),
          Text('ESP32 Configuration'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Connect to your TTGO T-Display ESP32:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),

          // QR Scan Button
          OutlinedButton.icon(
            onPressed: _handleQrScan,
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan QR Code (Secure)'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          const SizedBox(height: 16),

          // Divider with "OR"
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 16),

          // Manual IP Entry
          const Text(
            'Enter IP address manually:',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'IP Address',
              hintText: '192.168.1.100',
              errorText: _errorMessage,
              prefixIcon: const Icon(Icons.edit),
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              if (_errorMessage != null) {
                setState(() {
                  _errorMessage = null;
                });
              }
            },
            onSubmitted: (_) => _handleSubmit(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Manual entry is less secure - QR code is recommended',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Connect'),
        ),
      ],
    );
  }
}

// Helper function to show dialog
Future<DeviceCredentials?> showIpConfigDialog(BuildContext context, {String? currentIp}) {
  return showDialog<DeviceCredentials>(
    context: context,
    barrierDismissible: false,
    builder: (context) => IpConfigDialog(currentIp: currentIp),
  );
}

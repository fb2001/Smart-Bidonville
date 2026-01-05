import 'package:flutter/material.dart';

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

    Navigator.of(context).pop(ip);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the IP address of your TTGO T-Display ESP32 device:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'IP Address',
              hintText: '192.168.1.100',
              errorText: _errorMessage,
              prefixIcon: const Icon(Icons.network_check),
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
          Text(
            'Tip: Check your router\'s DHCP table or ESP32 serial monitor',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
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
Future<String?> showIpConfigDialog(BuildContext context, {String? currentIp}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => IpConfigDialog(currentIp: currentIp),
  );
}

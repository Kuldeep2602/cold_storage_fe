import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../state/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController(text: '9000000001');
  final _code = TextEditingController();

  bool _requested = false;
  bool _busy = false;
  String? _otpHint;
  bool _isSignup = false; // Toggle between signup and login

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() {
      _busy = true;
      _otpHint = null;
    });

    try {
      final app = context.read<AppState>();
      final res = await app.signup(_phone.text.trim());
      setState(() {
        _requested = true;
        _otpHint = (res['otp_code'] as String?);
      });
      _showSuccess('Account created! Enter OTP to login.');
    } on ApiException catch (e) {
      _showError(e.toString());
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestOtp() async {
    setState(() {
      _busy = true;
      _otpHint = null;
    });

    try {
      final app = context.read<AppState>();
      final res = await app.requestOtp(_phone.text.trim());
      setState(() {
        _requested = true;
        _otpHint = (res['otp_code'] as String?);
      });
    } on ApiException catch (e) {
      _showError(e.toString());
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _busy = true);
    try {
      final app = context.read<AppState>();
      await app.verifyOtp(phoneNumber: _phone.text.trim(), code: _code.text.trim());
    } on ApiException catch (e) {
      _showError(e.toString());
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Storage ERP')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('API: ${app.baseUrl}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          
          // Toggle between Signup and Login
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text('Login'),
                  selected: !_isSignup,
                  onSelected: (_) => setState(() {
                    _isSignup = false;
                    _requested = false;
                    _code.clear();
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  label: const Text('Signup'),
                  selected: _isSignup,
                  onSelected: (_) => setState(() {
                    _isSignup = true;
                    _requested = false;
                    _code.clear();
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone number'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _busy ? null : (_isSignup ? _signup : _requestOtp),
            child: Text(_isSignup ? 'Signup & Get OTP' : 'Request OTP'),
          ),
          if (_requested) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _code,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP code'),
            ),
            if (_otpHint != null && _otpHint!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Debug OTP: $_otpHint', style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy ? null : _verifyOtp,
              child: const Text('Verify & Login'),
            ),
          ],
          const SizedBox(height: 24),
          const Text('Tip: If using Android emulator, keep API on 0.0.0.0:8000.'),
        ],
      ),
    );
  }
}

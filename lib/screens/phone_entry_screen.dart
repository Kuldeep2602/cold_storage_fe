import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../state/app_state.dart';
import 'otp_verification_screen.dart';

class PhoneEntryScreen extends StatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOTP() async {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    if (phone.length < 10) {
      _showError('Please enter a valid phone number');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppState>();
      
      // Try signup first (will fail if user exists, then we'll try login)
      try {
        final res = await appState.signup(phone);
        final otpCode = res['otp_code'] as String?;
        
        if (!mounted) return;
        
        // Navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              phoneNumber: phone,
              debugOTP: otpCode,
            ),
          ),
        );
      } on ApiException catch (e) {
        // If signup fails with "already registered", try login
        if (e.toString().contains('already registered') || 
            e.toString().contains('Phone number already registered')) {
          final res = await appState.requestOtp(phone);
          final otpCode = res['otp_code'] as String?;
          
          if (!mounted) return;
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                phoneNumber: phone,
                debugOTP: otpCode,
              ),
            ),
          );
        } else {
          throw e;
        }
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.body.toString());
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              
              // Logo
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // App Title
              const Text(
                'ColdOne',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              const Text(
                'Cold Storage Login',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Phone Number Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Phone Input
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.grey.shade600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Send OTP Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const Spacer(),
              
              // Footer Text
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  'Secure login for cold storage operations',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

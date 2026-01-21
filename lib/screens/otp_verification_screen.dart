import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../state/app_state.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String? debugOTP;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.debugOTP,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendTimer = 30);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_isLoading) return;
    final otp = _otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      _showError('Please enter complete OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppState>();
      await appState.verifyOtp(
        phoneNumber: widget.phoneNumber,
        code: otp,
      );
      
      // OTP verified successfully - pop all screens and let main.dart handle navigation
      if (!mounted) return;
      
      // Pop back to root and let Consumer rebuild
      Navigator.of(context).popUntil((route) => route.isFirst);
      
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

  Future<void> _resendOTP() async {
    setState(() => _isLoading = true);

    try {
      final appState = context.read<AppState>();
      await appState.requestOtp(widget.phoneNumber);
      
      if (!mounted) return;
      
      _startTimer();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () {
            // Show dialog to confirm going back and changing role
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Go Back?'),
                content: const Text('Do you want to go back and change your phone number or role?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to phone screen
                    },
                    child: const Text('Change Phone'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Clear role selection and go back to role screen
                      final appState = context.read<AppState>();
                      await appState.clearSelectedRole();
                      
                      if (!mounted) return;
                      Navigator.pop(context); // Close dialog
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Change Role'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Title
              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Enter the 6-digit code sent to\n${widget.phoneNumber}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E88E5),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        
                        // Auto-submit when all 6 digits are entered
                        if (index == 5 && value.length == 1) {
                          _verifyOTP();
                        }
                      },
                    ),
                  );
                }),
              ),
              
              if (widget.debugOTP != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Debug OTP: ${widget.debugOTP}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _verifyOTP,
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
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Resend OTP
              Center(
                child: TextButton(
                  onPressed: _resendTimer == 0 && !_isLoading ? _resendOTP : null,
                  child: Text(
                    _resendTimer > 0
                        ? 'Resend OTP in ${_resendTimer}s'
                        : 'Resend OTP',
                    style: TextStyle(
                      fontSize: 16,
                      color: _resendTimer > 0
                          ? Colors.grey.shade400
                          : const Color(0xFF1E88E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

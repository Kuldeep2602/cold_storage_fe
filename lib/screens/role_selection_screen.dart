import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'operator';
  bool _isProcessing = false;

  List<Map<String, String>> _getRoles(AppLocalizations? l10n) {
    return [
      {
        'code': 'operator',
        'name': l10n?.operator ?? 'Operator',
        'description': l10n?.operatorDescription ?? 'Handles day-to-day operations',
      },
      {
        'code': 'technician',
        'name': l10n?.technician ?? 'Technician',
        'description': l10n?.technicianDescription ?? 'Manages technical aspects',
      },
      {
        'code': 'manager',
        'name': l10n?.manager ?? 'Manager',
        'description': l10n?.managerDescription ?? 'Oversees team and operations',
      },
      {
        'code': 'owner',
        'name': l10n?.owner ?? 'Owner',
        'description': l10n?.ownerDescription ?? 'Full access and control',
      },
    ];
  }

  Future<void> _onContinue() async {
    setState(() => _isProcessing = true);
    final l10n = AppLocalizations.of(context);

    try {
      final appState = context.read<AppState>();
      await appState.setSelectedRole(_selectedRole);

      // Navigation handled automatically by main.dart
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n?.error ?? "Error"}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final roles = _getRoles(l10n);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                         MediaQuery.of(context).padding.top -
                         MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Back Button to change language
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        context.read<AppState>().clearSelectedLanguage();
                      },
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),

                  const SizedBox(height: 32),

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
                  Text(
                    l10n?.appTitle ?? 'ColdOne',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Subtitle
                  Text(
                    l10n?.selectRole ?? 'Select role',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Role Options
                  Expanded(
                    child: Column(
                      children: roles.map((role) {
                        final isSelected = _selectedRole == role['code'];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              setState(() => _selectedRole = role['code']!);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1E88E5)
                                      : const Color(0xFFE0E0E0),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isSelected
                                    ? const Color(0xFFF0F8FF)
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          role['name']!,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: isSelected
                                                ? const Color(0xFF1E88E5)
                                                : const Color(0xFF333333),
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          role['description']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isSelected
                                                ? const Color(0xFF1E88E5).withOpacity(0.7)
                                                : const Color(0xFF666666),
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF1E88E5),
                                      size: 28,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10n?.continueText ?? 'Continue',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

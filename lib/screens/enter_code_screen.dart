import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../utils/http_helper.dart';
import '../utils/constants.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      _joinSession();
    }
  }

  Future<void> _joinSession() async {
    setState(() {
      isLoading = true;
    });

    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final deviceId = appState.deviceId;
      final response = await HttpHelper.joinSession(
        deviceId,
        _codeController.text,
      );

      if (response.containsKey('data')) {
        appState.setSessionId(response['data']['session_id']);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/movie-selection');
        }
      } else {
        _showSnackBar('Invalid code! Please try again.');
      }
    } catch (e) {
      _showSnackBar('Error: Unable to join session.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
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
      appBar: AppBar(
        title: const Text('Enter Session Code'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Container(
        color: const Color(0xFFE8F5E9),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Enter 4-Digit Code',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., 1234',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Code is required.';
                      }
                      if (value.length != 4) {
                        return 'Code must be 4 digits.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: Spacing.large),
                ElevatedButton(
                  onPressed: isLoading ? null : _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.medium,
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Join Session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

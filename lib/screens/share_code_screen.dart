import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../utils/http_helper.dart';
import '../utils/constants.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _CodeSharingScreenState();
}

class _CodeSharingScreenState extends State<ShareCodeScreen> {
  bool _isFetchingCode = true;
  String? _generatedCode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Code'),
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        color: const Color(0xFFF1F8E9),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.large),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isFetchingCode) {
      return const CircularProgressIndicator();
    } else if (_errorText != null) {
      return Text(
        _errorText!,
        style: const TextStyle(color: Colors.red, fontSize: 18),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Use this code to join:',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: Spacing.medium),
          Text(
            _generatedCode ?? '',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: Spacing.extraLarge),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/movie-selection');
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
            ),
            child: const Text('Start Picking Movies'),
          ),
        ],
      );
    }
  }

  Future<void> _initializeSession() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final deviceIdentifier = appState.deviceId;
      final response = await HttpHelper.startSession(deviceIdentifier);

      if (mounted) {
        setState(() {
          _generatedCode = response['data']['code'];
          appState.setSessionId(response['data']['session_id']);
          _isFetchingCode = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorText = 'Failed to generate code. Please try again.';
          _isFetchingCode = false;
        });
      }
    }
  }
}

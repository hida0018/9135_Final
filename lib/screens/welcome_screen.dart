import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/deviceid.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';

class MainWelcomeScreen extends StatelessWidget {
  final DeviceIdService deviceService;

  const MainWelcomeScreen({super.key, required this.deviceService});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppState>(context, listen: false);

    if (appData.deviceId == null) {
      deviceService.getDeviceId().then((id) {
        appData.setDeviceId(id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: const Color(0xFFEDE7F6),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Final Project Movie Night!',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: Spacing.large),
                _buildButton(
                  context,
                  '/share-code',
                  'Share Code',
                  Colors.indigo,
                ),
                const SizedBox(height: Spacing.medium),
                _buildButton(
                  context,
                  '/enter-code',
                  'Enter Code',
                  Colors.teal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build buttons
  Widget _buildButton(
      BuildContext context, String route, String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.large,
          vertical: Spacing.small,
        ),
      ),
      child: Text(label),
    );
  }
}

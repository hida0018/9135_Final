import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/welcome_screen.dart';
import 'services/deviceid.dart';
import 'utils/app_state.dart';
import 'screens/share_code_screen.dart';
import 'screens/enter_code_screen.dart';
import 'screens/movie_selection_screen.dart';
import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Error loading .env file: $e');
  }

  final prefs = await SharedPreferences.getInstance();
  final deviceIdService = DeviceIdService(prefs);

  runApp(MovieNightApp(deviceIdService: deviceIdService, prefs: prefs));
}

class MovieNightApp extends StatelessWidget {
  final DeviceIdService deviceIdService;
  final SharedPreferences prefs;

  const MovieNightApp(
      {super.key, required this.deviceIdService, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(prefs),
      child: MaterialApp(
        title: 'Movie Night',
        theme: AppTheme.theme,
        home: MainWelcomeScreen(deviceService: deviceIdService),
        routes: {
          '/share-code': (context) => const ShareCodeScreen(),
          '/enter-code': (context) => const EnterCodeScreen(),
          '/movie-selection': (context) => const MovieSelectionScreen(),
        },
      ),
    );
  }
}

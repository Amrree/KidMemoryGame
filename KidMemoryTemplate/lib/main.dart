import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/managers/analytics_manager.dart';
import 'core/managers/audio_manager.dart';
import 'core/managers/module_manager.dart';
import 'core/managers/save_manager.dart';
import 'core/screens/loading_screen.dart';
import 'core/screens/main_menu_screen.dart';
import 'core/models/game_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Set preferred orientations (landscape for tablets)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Hide system UI for immersive experience
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(const KidMemoryTemplateApp());
}

class KidMemoryTemplateApp extends StatelessWidget {
  const KidMemoryTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalyticsManager()),
        ChangeNotifierProvider(create: (_) => AudioManager()),
        ChangeNotifierProvider(create: (_) => ModuleManager()),
        ChangeNotifierProvider(create: (_) => SaveManager()),
      ],
      child: MaterialApp(
        title: 'Kid Memory Template',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
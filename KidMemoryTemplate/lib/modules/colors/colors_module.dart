import 'package:flutter/material.dart';
import '../../core/models/game_module.dart';

/// Example colors module implementation
class ColorsModule {
  static const String moduleId = 'colors';
  
  /// Get the colors module configuration
  static GameModule getModule() {
    return GameModule(
      id: moduleId,
      name: 'Colors',
      description: 'Discover beautiful colors',
      iconPath: 'assets/images/colors/icon.png',
      backgroundPath: 'assets/images/colors/background.png',
      cardPaths: [
        'assets/images/colors/red.png',
        'assets/images/colors/blue.png',
        'assets/images/colors/green.png',
        'assets/images/colors/yellow.png',
        'assets/images/colors/orange.png',
        'assets/images/colors/purple.png',
      ],
      isUnlocked: true,
      difficultyLevel: 1,
      audioPaths: [
        'assets/audio/colors/red.mp3',
        'assets/audio/colors/blue.mp3',
        'assets/audio/colors/green.mp3',
        'assets/audio/colors/yellow.mp3',
        'assets/audio/colors/orange.mp3',
        'assets/audio/colors/purple.mp3',
      ],
    );
  }
  
  /// Get color names for display
  static List<String> getColorNames() {
    return [
      'Red',
      'Blue',
      'Green',
      'Yellow',
      'Orange',
      'Purple',
    ];
  }
  
  /// Get color values for UI
  static List<Color> getColorValues() {
    return [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
    ];
  }
  
  /// Get color descriptions for educational content
  static Map<String, String> getColorDescriptions() {
    return {
      'Red': 'The color of apples and roses',
      'Blue': 'The color of the sky and ocean',
      'Green': 'The color of grass and leaves',
      'Yellow': 'The color of the sun and bananas',
      'Orange': 'The color of oranges and pumpkins',
      'Purple': 'The color of grapes and violets',
    };
  }
  
  /// Get educational tips for this module
  static List<String> getEducationalTips() {
    return [
      'Look for these colors around you!',
      'Mix colors to make new ones',
      'Colors can make us feel different emotions',
      'Try naming colors you see every day',
    ];
  }
}
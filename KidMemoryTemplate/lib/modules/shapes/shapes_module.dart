import 'package:flutter/material.dart';
import '../../core/models/game_module.dart';

/// Example shapes module implementation
/// This demonstrates how to create a custom module
class ShapesModule {
  static const String moduleId = 'shapes';
  
  /// Get the shapes module configuration
  static GameModule getModule() {
    return GameModule(
      id: moduleId,
      name: 'Shapes',
      description: 'Learn about different shapes',
      iconPath: 'assets/images/shapes/icon.png',
      backgroundPath: 'assets/images/shapes/background.png',
      cardPaths: [
        'assets/images/shapes/circle.png',
        'assets/images/shapes/square.png',
        'assets/images/shapes/triangle.png',
        'assets/images/shapes/rectangle.png',
        'assets/images/shapes/star.png',
        'assets/images/shapes/heart.png',
      ],
      isUnlocked: true,
      difficultyLevel: 1,
      audioPaths: [
        'assets/audio/shapes/circle.mp3',
        'assets/audio/shapes/square.mp3',
        'assets/audio/shapes/triangle.mp3',
        'assets/audio/shapes/rectangle.mp3',
        'assets/audio/shapes/star.mp3',
        'assets/audio/shapes/heart.mp3',
      ],
    );
  }
  
  /// Get shape names for display
  static List<String> getShapeNames() {
    return [
      'Circle',
      'Square', 
      'Triangle',
      'Rectangle',
      'Star',
      'Heart',
    ];
  }
  
  /// Get shape descriptions for educational content
  static Map<String, String> getShapeDescriptions() {
    return {
      'Circle': 'A round shape with no corners',
      'Square': 'A shape with 4 equal sides',
      'Triangle': 'A shape with 3 sides',
      'Rectangle': 'A shape with 4 sides, 2 long and 2 short',
      'Star': 'A shape with 5 points',
      'Heart': 'A shape that looks like love',
    };
  }
  
  /// Get educational tips for this module
  static List<String> getEducationalTips() {
    return [
      'Look for shapes around you!',
      'Count the sides of each shape',
      'Shapes are everywhere in nature',
      'Try drawing these shapes',
    ];
  }
}
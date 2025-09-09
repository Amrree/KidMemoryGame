import 'package:hive/hive.dart';

part 'game_module.g.dart';

/// Represents a game module with all its assets and configuration
@HiveType(typeId: 0)
class GameModule extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String iconPath;
  
  @HiveField(4)
  final String backgroundPath;
  
  @HiveField(5)
  final List<String> cardPaths;
  
  @HiveField(6)
  bool isUnlocked;
  
  @HiveField(7)
  final int difficultyLevel;
  
  @HiveField(8)
  final List<String> audioPaths;
  
  @HiveField(9)
  final String category;
  
  @HiveField(10)
  final int ageRangeMin;
  
  @HiveField(11)
  final int ageRangeMax;
  
  @HiveField(12)
  final Map<String, dynamic> customData;

  GameModule({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.backgroundPath,
    required this.cardPaths,
    this.isUnlocked = false,
    required this.difficultyLevel,
    required this.audioPaths,
    required this.category,
    this.ageRangeMin = 3,
    this.ageRangeMax = 8,
    this.customData = const {},
  });

  /// Create a copy of this module with updated values
  GameModule copyWith({
    String? id,
    String? name,
    String? description,
    String? iconPath,
    String? backgroundPath,
    List<String>? cardPaths,
    bool? isUnlocked,
    int? difficultyLevel,
    List<String>? audioPaths,
    String? category,
    int? ageRangeMin,
    int? ageRangeMax,
    Map<String, dynamic>? customData,
  }) {
    return GameModule(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      backgroundPath: backgroundPath ?? this.backgroundPath,
      cardPaths: cardPaths ?? this.cardPaths,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      audioPaths: audioPaths ?? this.audioPaths,
      category: category ?? this.category,
      ageRangeMin: ageRangeMin ?? this.ageRangeMin,
      ageRangeMax: ageRangeMax ?? this.ageRangeMax,
      customData: customData ?? this.customData,
    );
  }

  /// Get the total number of cards in this module
  int get totalCards => cardPaths.length;

  /// Get the number of pairs (assuming each card appears twice)
  int get totalPairs => totalCards ~/ 2;

  /// Check if this module is appropriate for the given age
  bool isAppropriateForAge(int age) {
    return age >= ageRangeMin && age <= ageRangeMax;
  }

  /// Get difficulty description
  String get difficultyDescription {
    switch (difficultyLevel) {
      case 1:
        return 'Easy';
      case 2:
        return 'Medium';
      case 3:
        return 'Hard';
      default:
        return 'Custom';
    }
  }

  @override
  String toString() {
    return 'GameModule(id: $id, name: $name, difficulty: $difficultyLevel, unlocked: $isUnlocked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameModule && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Game session data for analytics and progress tracking
@HiveType(typeId: 1)
class GameSession extends HiveObject {
  @HiveField(0)
  final String moduleId;
  
  @HiveField(1)
  final DateTime startTime;
  
  @HiveField(2)
  DateTime? endTime;
  
  @HiveField(3)
  int score;
  
  @HiveField(4)
  int moves;
  
  @HiveField(5)
  int correctMatches;
  
  @HiveField(6)
  int incorrectMatches;
  
  @HiveField(7)
  bool completed;
  
  @HiveField(8)
  final Map<String, dynamic> metadata;

  GameSession({
    required this.moduleId,
    required this.startTime,
    this.endTime,
    this.score = 0,
    this.moves = 0,
    this.correctMatches = 0,
    this.incorrectMatches = 0,
    this.completed = false,
    this.metadata = const {},
  });

  /// Get session duration in seconds
  int get durationSeconds {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inSeconds;
  }

  /// Get accuracy percentage
  double get accuracy {
    final total = correctMatches + incorrectMatches;
    if (total == 0) return 0.0;
    return (correctMatches / total) * 100;
  }

  /// Complete the session
  void complete() {
    endTime = DateTime.now();
    completed = true;
  }
}
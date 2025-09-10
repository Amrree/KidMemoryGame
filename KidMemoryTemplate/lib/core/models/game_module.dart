import 'package:hive/hive.dart';

part 'game_module.g.dart';

/// Represents a game module (shapes, colors, animals, etc.)
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
  final bool isUnlocked;
  
  @HiveField(7)
  final int difficultyLevel;
  
  @HiveField(8)
  final List<String> audioPaths;

  GameModule({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.backgroundPath,
    required this.cardPaths,
    this.isUnlocked = false,
    this.difficultyLevel = 1,
    this.audioPaths = const [],
  });

  /// Create a copy with updated fields
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
    );
  }
}

/// Represents a game card
@HiveType(typeId: 1)
class GameCard extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String imagePath;
  
  @HiveField(2)
  final String audioPath;
  
  @HiveField(3)
  final String name;
  
  @HiveField(4)
  final bool isMatched;
  
  @HiveField(5)
  final bool isFlipped;

  GameCard({
    required this.id,
    required this.imagePath,
    required this.audioPath,
    required this.name,
    this.isMatched = false,
    this.isFlipped = false,
  });

  GameCard copyWith({
    String? id,
    String? imagePath,
    String? audioPath,
    String? name,
    bool? isMatched,
    bool? isFlipped,
  }) {
    return GameCard(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      name: name ?? this.name,
      isMatched: isMatched ?? this.isMatched,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }
}

/// Game session data for analytics
@HiveType(typeId: 2)
class GameSession extends HiveObject {
  @HiveField(0)
  final String sessionId;
  
  @HiveField(1)
  final String moduleId;
  
  @HiveField(2)
  final DateTime startTime;
  
  @HiveField(3)
  final DateTime? endTime;
  
  @HiveField(4)
  final int correctMatches;
  
  @HiveField(5)
  final int incorrectMatches;
  
  @HiveField(6)
  final int totalMoves;
  
  @HiveField(7)
  final Duration? duration;

  GameSession({
    required this.sessionId,
    required this.moduleId,
    required this.startTime,
    this.endTime,
    this.correctMatches = 0,
    this.incorrectMatches = 0,
    this.totalMoves = 0,
    this.duration,
  });

  GameSession copyWith({
    String? sessionId,
    String? moduleId,
    DateTime? startTime,
    DateTime? endTime,
    int? correctMatches,
    int? incorrectMatches,
    int? totalMoves,
    Duration? duration,
  }) {
    return GameSession(
      sessionId: sessionId ?? this.sessionId,
      moduleId: moduleId ?? this.moduleId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      correctMatches: correctMatches ?? this.correctMatches,
      incorrectMatches: incorrectMatches ?? this.incorrectMatches,
      totalMoves: totalMoves ?? this.totalMoves,
      duration: duration ?? this.duration,
    );
  }
}
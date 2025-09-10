import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../core/models/game_module.dart';

/// Improved memory game implementation with better error handling and performance
class MemoryGameImproved extends FlameGame with HasTapDetectors {
  final GameModule module;
  final VoidCallback? onCardFlipped;
  final VoidCallback? onMatch;
  final VoidCallback? onMismatch;
  final VoidCallback? onGameWon;
  final VoidCallback? onError;

  late List<MemoryCardImproved> _cards;
  late List<MemoryCardImproved> _flippedCards;
  bool _isProcessing = false;
  int _matchesFound = 0;
  final int _totalMatches;
  
  // Performance tracking
  int _totalMoves = 0;
  int _incorrectMoves = 0;
  DateTime? _gameStartTime;
  DateTime? _gameEndTime;
  
  // Error tracking
  int _errorCount = 0;
  static const int _maxErrors = 10;

  MemoryGameImproved({
    required this.module,
    this.onCardFlipped,
    this.onMatch,
    this.onMismatch,
    this.onGameWon,
    this.onError,
  }) : _totalMatches = module.cardPaths.length;

  @override
  Future<void> onLoad() async {
    try {
      await super.onLoad();
      _gameStartTime = DateTime.now();
      _setupGame();
    } catch (e) {
      _handleError('Error loading memory game', e);
    }
  }

  void _setupGame() {
    try {
      _cards = [];
      _flippedCards = [];
      _matchesFound = 0;
      _isProcessing = false;
      _totalMoves = 0;
      _incorrectMoves = 0;

      // Validate module data
      if (module.cardPaths.isEmpty) {
        _handleError('Module has no card paths', null);
        return;
      }

      // Create card pairs
      final cardData = <String>[];
      for (final path in module.cardPaths) {
        if (path.isNotEmpty) {
          cardData.addAll([path, path]); // Add each card twice
        }
      }
      
      if (cardData.isEmpty) {
        _handleError('No valid card paths found', null);
        return;
      }
      
      cardData.shuffle(Random());

      // Create card components with improved layout
      final cardSize = _calculateCardSize();
      final spacing = 20.0;
      final gridWidth = 4;
      final gridHeight = (cardData.length / gridWidth).ceil();
      
      final startX = (size.x - (gridWidth * cardSize + (gridWidth - 1) * spacing)) / 2;
      final startY = (size.y - (gridHeight * cardSize + (gridHeight - 1) * spacing)) / 2;

      for (int i = 0; i < cardData.length; i++) {
        final row = i ~/ gridWidth;
        final col = i % gridWidth;
        
        final card = MemoryCardImproved(
          imagePath: cardData[i],
          cardId: i,
          position: Vector2(
            startX + col * (cardSize + spacing),
            startY + row * (cardSize + spacing),
          ),
          size: Vector2(cardSize, cardSize),
          onTap: () => _onCardTapped(card),
          onError: (error) => _handleError('Card error', error),
        );
        
        _cards.add(card);
        add(card);
      }
    } catch (e) {
      _handleError('Error setting up game', e);
    }
  }

  double _calculateCardSize() {
    // Calculate optimal card size based on screen size and number of cards
    final minSize = 60.0;
    final maxSize = 120.0;
    final availableWidth = size.x - 100; // Leave margin
    final availableHeight = size.y - 100;
    
    final cardCount = _totalMatches * 2;
    final gridWidth = 4;
    final gridHeight = (cardCount / gridWidth).ceil();
    
    final maxWidth = availableWidth / gridWidth;
    final maxHeight = availableHeight / gridHeight;
    
    return (maxWidth < maxHeight ? maxWidth : maxHeight)
        .clamp(minSize, maxSize);
  }

  void _onCardTapped(MemoryCardImproved card) {
    if (_isProcessing || card.isFlipped || card.isMatched) return;

    try {
      _totalMoves++;
      onCardFlipped?.call();
      card.flip();

      if (_flippedCards.length < 2) {
        _flippedCards.add(card);
      }

      if (_flippedCards.length == 2) {
        _isProcessing = true;
        Future.delayed(const Duration(milliseconds: 1000), () {
          _checkForMatch();
        });
      }
    } catch (e) {
      _handleError('Error handling card tap', e);
    }
  }

  void _checkForMatch() {
    try {
      if (_flippedCards.length != 2) return;

      final card1 = _flippedCards[0];
      final card2 = _flippedCards[1];

      if (card1.imagePath == card2.imagePath) {
        // Match found
        card1.setMatched();
        card2.setMatched();
        _matchesFound++;
        onMatch?.call();

        if (_matchesFound == _totalMatches) {
          // Game won
          _gameEndTime = DateTime.now();
          Future.delayed(const Duration(milliseconds: 500), () {
            onGameWon?.call();
          });
        }
      } else {
        // No match
        _incorrectMoves++;
        card1.flip();
        card2.flip();
        onMismatch?.call();
      }

      _flippedCards.clear();
      _isProcessing = false;
    } catch (e) {
      _handleError('Error checking for match', e);
      _isProcessing = false;
    }
  }

  void restart() {
    try {
      removeAll(children);
      _setupGame();
    } catch (e) {
      _handleError('Error restarting game', e);
    }
  }

  /// Get game statistics
  Map<String, dynamic> getGameStats() {
    final duration = _gameStartTime != null && _gameEndTime != null
        ? _gameEndTime!.difference(_gameStartTime!)
        : null;
    
    return {
      'totalMoves': _totalMoves,
      'incorrectMoves': _incorrectMoves,
      'matchesFound': _matchesFound,
      'totalMatches': _totalMatches,
      'isComplete': _matchesFound == _totalMatches,
      'duration': duration?.inMilliseconds,
      'errorCount': _errorCount,
      'accuracy': _totalMoves > 0 ? (_matchesFound / _totalMoves) : 0.0,
    };
  }

  /// Handle errors with improved logging
  void _handleError(String message, dynamic error) {
    _errorCount++;
    
    if (error != null) {
      print('MemoryGame Error: $message - $error');
    } else {
      print('MemoryGame Error: $message');
    }
    
    onError?.call();
    
    // If too many errors, restart the game
    if (_errorCount >= _maxErrors) {
      print('MemoryGame: Too many errors, restarting game');
      restart();
    }
  }
}

/// Improved individual memory card component
class MemoryCardImproved extends PositionComponent with TapCallbacks {
  final String imagePath;
  final int cardId;
  final VoidCallback? onTap;
  final Function(dynamic)? onError;

  bool _isFlipped = false;
  bool _isMatched = false;
  late SpriteComponent _backSprite;
  late SpriteComponent _frontSprite;
  bool _isLoading = true;

  bool get isFlipped => _isFlipped;
  bool get isMatched => _isMatched;
  bool get isLoading => _isLoading;

  MemoryCardImproved({
    required this.imagePath,
    required this.cardId,
    required Vector2 position,
    required Vector2 size,
    this.onTap,
    this.onError,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    try {
      await super.onLoad();
      
      // Create back sprite (card back)
      _backSprite = SpriteComponent(
        sprite: await Sprite.load('images/card_back.png'),
        size: size,
      );
      
      // Create front sprite (card image) with error handling
      try {
        _frontSprite = SpriteComponent(
          sprite: await Sprite.load(imagePath),
          size: size,
        );
      } catch (e) {
        // Create a placeholder sprite if image fails to load
        _frontSprite = SpriteComponent(
          sprite: await _createPlaceholderSprite(),
          size: size,
        );
        onError?.call('Failed to load image: $imagePath');
      }
      
      add(_backSprite);
      _isLoading = false;
    } catch (e) {
      onError?.call('Error loading card: $e');
      _isLoading = false;
    }
  }

  Future<Sprite> _createPlaceholderSprite() async {
    // Create a simple colored rectangle as placeholder
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.x.toInt(), size.y.toInt());
    
    return Sprite(image);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (_isLoading) return false;
    
    try {
      onTap?.call();
      return true;
    } catch (e) {
      onError?.call('Error handling card tap: $e');
      return false;
    }
  }

  void flip() {
    if (_isMatched || _isLoading) return;

    try {
      _isFlipped = !_isFlipped;
      
      if (_isFlipped) {
        remove(_backSprite);
        add(_frontSprite);
      } else {
        remove(_frontSprite);
        add(_backSprite);
      }
    } catch (e) {
      onError?.call('Error flipping card: $e');
    }
  }

  void setMatched() {
    if (_isMatched) return;
    
    try {
      _isMatched = true;
      // Add a glow effect or different visual state
      add(GlowEffectImproved());
    } catch (e) {
      onError?.call('Error setting card as matched: $e');
    }
  }
}

/// Improved glow effect for matched cards
class GlowEffectImproved extends Component {
  @override
  Future<void> onLoad() async {
    try {
      await super.onLoad();
      
      // Add a simple glow effect using a colored rectangle
      final glow = RectangleComponent(
        size: parent!.size,
        paint: Paint()
          ..color = Colors.green.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
      
      add(glow);
    } catch (e) {
      print('Error creating glow effect: $e');
    }
  }
}
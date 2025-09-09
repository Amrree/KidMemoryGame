import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../core/models/game_module.dart';

/// Main memory game implementation using Flame
class MemoryGame extends FlameGame with HasTapDetectors {
  final GameModule module;
  final VoidCallback? onCardFlipped;
  final VoidCallback? onMatch;
  final VoidCallback? onMismatch;
  final VoidCallback? onGameWon;

  late List<MemoryCard> _cards;
  late List<MemoryCard> _flippedCards;
  bool _isProcessing = false;
  int _matchesFound = 0;
  final int _totalMatches;

  MemoryGame({
    required this.module,
    this.onCardFlipped,
    this.onMatch,
    this.onMismatch,
    this.onGameWon,
  }) : _totalMatches = module.cardPaths.length;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _setupGame();
  }

  Future<void> _setupGame() async {
    _cards = [];
    _flippedCards = [];
    _matchesFound = 0;
    _isProcessing = false;

    // Create card pairs
    final cardData = <String>[];
    for (final path in module.cardPaths) {
      cardData.addAll([path, path]); // Add each card twice
    }
    cardData.shuffle(Random());

    // Create card components
    final cardSize = 100.0;
    final spacing = 15.0;
    final columns = 4;
    final rows = (cardData.length / columns).ceil();
    final startX = (size.x - (columns * cardSize + (columns - 1) * spacing)) / 2;
    final startY = (size.y - (rows * cardSize + (rows - 1) * spacing)) / 2;

    for (int i = 0; i < cardData.length; i++) {
      final row = i ~/ columns;
      final col = i % columns;
      
      final card = MemoryCard(
        imagePath: cardData[i],
        cardId: i,
        position: Vector2(
          startX + col * (cardSize + spacing),
          startY + row * (cardSize + spacing),
        ),
        size: Vector2(cardSize, cardSize),
        onTap: () => _onCardTapped(card),
      );
      
      _cards.add(card);
      add(card);
    }
  }

  void _onCardTapped(MemoryCard card) {
    if (_isProcessing || card.isFlipped || card.isMatched) return;

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
  }

  void _checkForMatch() {
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
        Future.delayed(const Duration(milliseconds: 500), () {
          onGameWon?.call();
        });
      }
    } else {
      // No match
      card1.flip();
      card2.flip();
      onMismatch?.call();
    }

    _flippedCards.clear();
    _isProcessing = false;
  }

  void restart() {
    removeAll(children);
    _setupGame();
  }
}

/// Individual memory card component
class MemoryCard extends PositionComponent with TapCallbacks {
  final String imagePath;
  final int cardId;
  final VoidCallback? onTap;

  bool _isFlipped = false;
  bool _isMatched = false;
  late SpriteComponent _backSprite;
  late SpriteComponent _frontSprite;

  bool get isFlipped => _isFlipped;
  bool get isMatched => _isMatched;

  MemoryCard({
    required this.imagePath,
    required this.cardId,
    required Vector2 position,
    required Vector2 size,
    this.onTap,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    try {
      // Create back sprite (card back)
      _backSprite = SpriteComponent(
        sprite: await Sprite.load('images/card_back.png'),
        size: size,
      );
      
      // Create front sprite (card image)
      _frontSprite = SpriteComponent(
        sprite: await Sprite.load(imagePath),
        size: size,
      );
      
      add(_backSprite);
    } catch (e) {
      print('Error loading sprites for card $cardId: $e');
      // Create fallback sprites
      _backSprite = SpriteComponent(
        sprite: await Sprite.load('images/card_back.png'),
        size: size,
      );
      _frontSprite = SpriteComponent(
        sprite: await Sprite.load('images/card_back.png'),
        size: size,
      );
      add(_backSprite);
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onTap?.call();
    return true;
  }

  void flip() {
    if (_isMatched) return;

    _isFlipped = !_isFlipped;
    
    if (_isFlipped) {
      remove(_backSprite);
      add(_frontSprite);
    } else {
      remove(_frontSprite);
      add(_backSprite);
    }
  }

  void setMatched() {
    _isMatched = true;
    // Add a glow effect or different visual state
    add(GlowEffect());
  }
}

/// Glow effect for matched cards
class GlowEffect extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add a simple glow effect using a colored rectangle
    final glow = RectangleComponent(
      size: parent!.size,
      paint: Paint()
        ..color = Colors.green.withOpacity(0.3)
        ..style = PaintingStyle.fill,
    );
    
    add(glow);
  }
}
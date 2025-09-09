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
  int _matchesFound = 0;
  bool _isProcessing = false;
  int _totalMatches = 0;

  MemoryGame({
    required this.module,
    this.onCardFlipped,
    this.onMatch,
    this.onMismatch,
    this.onGameWon,
  });

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

    _totalMatches = cardData.length ~/ 2;

    // Create card components
    final cardSize = _calculateCardSize();
    final spacing = 15.0;
    final columns = _calculateColumns(cardData.length);
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

  double _calculateCardSize() {
    // Calculate card size based on screen size and number of cards
    final screenWidth = size.x;
    final screenHeight = size.y;
    final totalCards = module.cardPaths.length * 2;
    
    // Estimate grid dimensions
    final aspectRatio = screenWidth / screenHeight;
    final columns = aspectRatio > 1.5 ? 4 : 3;
    final rows = (totalCards / columns).ceil();
    
    // Calculate available space
    final availableWidth = screenWidth * 0.9;
    final availableHeight = screenHeight * 0.7;
    
    final maxCardWidth = (availableWidth - (columns - 1) * 15) / columns;
    final maxCardHeight = (availableHeight - (rows - 1) * 15) / rows;
    
    return min(maxCardWidth, maxCardHeight).clamp(80.0, 150.0);
  }

  int _calculateColumns(int totalCards) {
    final aspectRatio = size.x / size.y;
    if (aspectRatio > 1.5) {
      return 4; // Landscape: 4 columns
    } else {
      return 3; // Portrait: 3 columns
    }
  }

  void _onCardTapped(MemoryCard card) {
    if (_isProcessing || card.isFlipped || card.isMatched) return;

    _isProcessing = true;
    
    // Add fun bounce effect when card is tapped
    add(BounceEffect(target: card));
    
    card.flip();
    _flippedCards.add(card);
    onCardFlipped?.call();

    if (_flippedCards.length < 2) {
      _isProcessing = false;
    } else {
      Future.delayed(const Duration(milliseconds: 1200), () {
        _checkForMatch();
      });
    }
  }

  void _checkForMatch() {
    if (_flippedCards.length != 2) return;

    final card1 = _flippedCards[0];
    final card2 = _flippedCards[1];

    if (card1.imagePath == card2.imagePath) {
      // Match found - add celebration effects!
      add(ConfettiEffect(position: card1.position));
      add(ConfettiEffect(position: card2.position));
      
      card1.setMatched();
      card2.setMatched();
      _matchesFound++;
      onMatch?.call();

      if (_matchesFound == _totalMatches) {
        // Game won - add big celebration!
        add(BigCelebrationEffect());
        Future.delayed(const Duration(milliseconds: 2000), () {
          onGameWon?.call();
        });
      }
    } else {
      // No match - add gentle shake effect
      add(ShakeEffect(target: card1));
      add(ShakeEffect(target: card2));
      
      Future.delayed(const Duration(milliseconds: 800), () {
        card1.flip();
        card2.flip();
        onMismatch?.call();
      });
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

  MemoryCard({
    required this.imagePath,
    required this.cardId,
    required Vector2 position,
    required Vector2 size,
    this.onTap,
  }) : super(position: position, size: size);

  bool get isFlipped => _isFlipped;
  bool get isMatched => _isMatched;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    try {
      // Create back sprite (card back)
      _backSprite = SpriteComponent(
        sprite: await Sprite.load('assets/images/common/card_back.png'),
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
        sprite: await Sprite.load('assets/images/common/card_back.png'),
        size: size,
      );
      _frontSprite = SpriteComponent(
        sprite: await Sprite.load('assets/images/common/card_back.png'),
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
    
    // Add smooth flip animation with rotation
    add(
      FlipAnimationComponent(
        onComplete: () {
          if (_isFlipped) {
            remove(_backSprite);
            add(_frontSprite);
          } else {
            remove(_frontSprite);
            add(_backSprite);
          }
        },
      ),
    );
  }

  void setMatched() {
    _isMatched = true;
    // Add a glow effect or different visual state
    add(GlowEffect());
  }
}

/// Smooth flip animation for cards
class FlipAnimationComponent extends Component {
  final VoidCallback onComplete;
  late AnimationController _controller;
  late Animation<double> _animation;
  
  FlipAnimationComponent({required this.onComplete});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.forward().then((_) {
      onComplete();
      removeFromParent();
    });
  }
  
  @override
  void render(Canvas canvas) {
    // Apply rotation transform for flip effect
    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(_animation.value * 3.14159); // 180 degrees
    canvas.translate(-size.x / 2, -size.y / 2);
    canvas.restore();
  }
  
  @override
  void onRemove() {
    _controller.dispose();
    super.onRemove();
  }
}

/// Enhanced glow effect for matched cards
class GlowEffect extends Component {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
    
    _glowController.repeat(reverse: true);
    
    // Add pulsing glow effect
    add(
      GlowComponent(
        animation: _glowAnimation,
      ),
    );
  }
  
  @override
  void onRemove() {
    _glowController.dispose();
    super.onRemove();
  }
}

/// Glow component with pulsing animation
class GlowComponent extends Component {
  final Animation<double> animation;
  
  GlowComponent({required this.animation});
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(animation.value * 0.5)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(12),
      ),
      paint,
    );
  }
}

/// Fun confetti effect for matches
class ConfettiEffect extends Component {
  final Vector2 position;
  late List<ConfettiParticle> particles;
  
  ConfettiEffect({required this.position});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    particles = List.generate(15, (index) => ConfettiParticle(
      color: [
        const Color(0xFFFFD700),
        const Color(0xFFFF6B35),
        const Color(0xFFE91E63),
        const Color(0xFF4CAF50),
        const Color(0xFF2196F3),
      ][index % 5],
    ));
    
    addAll(particles);
    
    // Remove effect after animation
    Future.delayed(const Duration(milliseconds: 2000), () {
      removeFromParent();
    });
  }
}

/// Individual confetti particle
class ConfettiParticle extends Component {
  final Color color;
  late Vector2 velocity;
  late double rotationSpeed;
  
  ConfettiParticle({required this.color});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    velocity = Vector2(
      (Random().nextDouble() - 0.5) * 200,
      -Random().nextDouble() * 300 - 100,
    );
    rotationSpeed = (Random().nextDouble() - 0.5) * 10;
    
    size = Vector2(8, 8);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    position += velocity * dt;
    velocity.y += 500 * dt; // Gravity
    angle += rotationSpeed * dt;
    
    if (position.y > parent!.size.y) {
      removeFromParent();
    }
  }
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
  }
}

/// Big celebration effect for game completion
class BigCelebrationEffect extends Component {
  late List<CelebrationParticle> particles;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    particles = List.generate(50, (index) => CelebrationParticle());
    addAll(particles);
    
    // Remove effect after animation
    Future.delayed(const Duration(milliseconds: 3000), () {
      removeFromParent();
    });
  }
}

/// Celebration particle for game completion
class CelebrationParticle extends Component {
  late Color color;
  late Vector2 velocity;
  late double rotationSpeed;
  late double scale;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    color = [
      const Color(0xFFFFD700),
      const Color(0xFFFF6B35),
      const Color(0xFFE91E63),
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
    ][Random().nextInt(6)];
    
    velocity = Vector2(
      (Random().nextDouble() - 0.5) * 400,
      -Random().nextDouble() * 400 - 200,
    );
    rotationSpeed = (Random().nextDouble() - 0.5) * 15;
    scale = Random().nextDouble() * 0.5 + 0.5;
    
    size = Vector2(16, 16) * scale;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    position += velocity * dt;
    velocity.y += 300 * dt; // Gravity
    angle += rotationSpeed * dt;
    
    if (position.y > parent!.size.y) {
      removeFromParent();
    }
  }
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
  }
}

/// Shake effect for mismatched cards
class ShakeEffect extends Component {
  final MemoryCard target;
  late AnimationController controller;
  late Animation<double> animation;
  
  ShakeEffect({required this.target});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticIn,
    ));
    
    controller.forward().then((_) {
      removeFromParent();
    });
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    final shakeOffset = (animation.value * 10 * (Random().nextDouble() - 0.5));
    target.position.x += shakeOffset;
  }
  
  @override
  void onRemove() {
    controller.dispose();
    super.onRemove();
  }
}

/// Bounce effect for card taps
class BounceEffect extends Component {
  final MemoryCard target;
  late AnimationController controller;
  late Animation<double> animation;
  
  BounceEffect({required this.target});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    ));
    
    controller.forward().then((_) {
      controller.reverse().then((_) {
        removeFromParent();
      });
    });
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    target.scale = Vector2.all(animation.value);
  }
  
  @override
  void onRemove() {
    controller.dispose();
    super.onRemove();
  }
}
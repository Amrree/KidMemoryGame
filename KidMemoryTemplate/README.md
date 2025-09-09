# 🎮 Kid Memory Template

A **super fun, smooth, and easy-to-use** Flutter + Flame template for creating educational memory card-matching games for kids! This template is designed to be the foundation for creating many different kids' learning games.

## ✨ Features

### 🎯 **Super Kid-Friendly Design**
- **Bouncy animations** that make everything feel alive and fun
- **Bright, colorful UI** with gradients and shadows
- **Large, easy-to-tap buttons** perfect for little fingers
- **Celebration effects** with confetti and particles when kids succeed
- **Smooth transitions** between all screens

### 🧠 **Educational Modules**
- **Modular system** - easily add new learning topics
- **6 ready-to-use modules**: Shapes, Colors, Animals, Jobs, Farm, Family
- **Customizable difficulty levels** for different age groups
- **Progress tracking** and achievement system

### 🎵 **Fun Audio System**
- **Sound effects** for every interaction (button clicks, card flips, matches)
- **Background music** for different modules
- **Audio pronunciation** for learning words
- **Volume controls** for parents

### 🎨 **Beautiful Art Integration**
- **AI-generated art** using Pollinations API
- **Consistent art style** across all modules
- **Easy art replacement** system
- **High-quality PNG assets** ready to use

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code
- Android device or emulator

### Installation
```bash
# Clone the template
git clone <your-repo-url> kid-memory-template
cd kid-memory-template

# Install dependencies
flutter pub get

# Generate code (for Hive models)
flutter packages pub run build_runner build

# Run the app
flutter run
```

## 🎮 How to Play

1. **Start the app** - See the fun loading screen with bouncing logo
2. **Choose a module** - Tap on any unlocked learning topic
3. **Match the cards** - Find pairs by flipping cards over
4. **Celebrate success** - Enjoy confetti and celebration effects when you win!

## 🛠️ Creating New Games

This template is designed to make it **super easy** to create new kids' games. Here's how:

### 1. Add a New Module

```dart
// In lib/core/managers/module_manager.dart
GameModule(
  id: 'space',
  name: 'Space',
  description: 'Learn about planets and stars',
  iconPath: 'images/space/icon.png',
  backgroundPath: 'images/space/background.png',
  cardPaths: [
    'images/space/sun.png',
    'images/space/moon.png',
    'images/space/earth.png',
    // ... more cards
  ],
  isUnlocked: true,
  difficultyLevel: 2,
  audioPaths: [
    'audio/space/sun.mp3',
    'audio/space/moon.mp3',
    // ... more audio
  ],
),
```

### 2. Generate Art Assets

Use the included art generator to create beautiful, consistent art:

```bash
# Generate all art for a new module
python art_generator/simple_art_generator.py --module space

# Or generate specific assets
python art_generator/simple_art_generator.py --type icon --module space
```

### 3. Add Audio Files

Place your audio files in the correct directories:
```
assets/audio/space/
├── sun.mp3
├── moon.mp3
├── earth.mp3
└── background_music.mp3
```

### 4. Customize Game Mechanics

The template includes many customizable features:

```dart
// Adjust card size and spacing
final cardSize = 120.0;  // Make cards bigger for younger kids
final spacing = 20.0;    // More space between cards

// Change game difficulty
final columns = 3;  // 3x2 grid for easier games
final rows = 2;

// Modify scoring system
_score += 10;  // More points for matches
```

## 🎨 Art Generation

The template includes powerful art generation tools:

### Simple Art Generator
```bash
python art_generator/simple_art_generator.py
```
Generates all art assets with kid-friendly prompts.

### Custom Art Generation
```python
from art_generator.pollinations_client import PollinationsClient

client = PollinationsClient()
image = client.generate_image(
    prompt="a cute cartoon sun, educational, child-friendly",
    width=256,
    height=256
)
```

## 🎵 Audio System

The audio system is designed to be fun and educational:

```dart
// Play sound effects
audioManager.playButtonClick();
audioManager.playCardFlip();
audioManager.playMatch();

// Play educational audio
audioManager.playCardName('shapes', 'circle');

// Background music
audioManager.playModuleMusic('shapes');
```

## 🎯 Game Mechanics

### Card Matching
- **Easy tap detection** - Large hit areas for little fingers
- **Smooth animations** - Cards flip and bounce naturally
- **Visual feedback** - Glowing effects for matches
- **Celebration effects** - Confetti and particles for success

### Scoring System
- **Points for matches** - Kids earn points for correct pairs
- **Time tracking** - See how fast they complete the game
- **Progress saving** - High scores and progress are saved locally

### Difficulty Levels
- **Level 1**: 6 cards (3 pairs) - Perfect for toddlers
- **Level 2**: 8 cards (4 pairs) - Great for preschoolers
- **Level 3**: 12 cards (6 pairs) - Challenging for older kids

## 🎨 Customization

### Colors and Themes
```dart
// Main app colors
const primaryColor = Color(0xFF4CAF50);  // Green
const accentColor = Color(0xFFFF6B35);   // Orange
const celebrationColor = Color(0xFFFFD700); // Gold

// Module-specific colors
const shapesColor = Color(0xFF2196F3);   // Blue
const colorsColor = Color(0xFFE91E63);   // Pink
```

### Animations
```dart
// Bouncy button animations
curve: Curves.bounceOut,

// Smooth transitions
curve: Curves.easeOutCubic,

// Fun elastic effects
curve: Curves.elasticOut,
```

## 📱 Platform Support

- **Android** ✅ Fully supported
- **iOS** ✅ Ready for easy porting
- **Fire OS** ✅ Optimized for tablets
- **Web** 🔄 Coming soon

## 🧪 Testing

```bash
# Run tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Check for issues
flutter analyze
```

## 📦 Dependencies

- **Flame** - 2D game engine
- **Provider** - State management
- **Hive** - Local storage
- **Audioplayers** - Audio playback
- **Google Fonts** - Beautiful typography

## 🎯 Template Structure

```
lib/
├── core/
│   ├── managers/          # Game managers (Audio, Save, etc.)
│   ├── models/            # Data models
│   └── screens/           # UI screens
├── game/                  # Flame game logic
├── modules/               # Educational modules
└── main.dart             # App entry point

assets/
├── images/               # All image assets
│   ├── shapes/          # Module-specific images
│   ├── colors/
│   └── ...
└── audio/               # All audio assets
    ├── sfx/             # Sound effects
    └── shapes/          # Module-specific audio
```

## 🚀 Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

## 🤝 Contributing

This template is designed to be extended! Here are some ideas:

1. **New Module Types**
   - Numbers and counting
   - Letters and spelling
   - Music and instruments
   - Sports and activities

2. **New Game Modes**
   - Timed challenges
   - Multiplayer modes
   - Story-based progression
   - Mini-games

3. **Enhanced Features**
   - Voice recognition
   - Augmented reality
   - Parental controls
   - Progress reports

## 📄 License

This template is free to use for educational and commercial purposes. Feel free to modify and distribute!

## 🎉 Have Fun!

This template is designed to make creating kids' games **super fun and easy**. The bouncy animations, bright colors, and celebration effects will make kids love learning!

Remember: **Keep it simple, keep it fun, and keep it colorful!** 🌈

---

**Made with ❤️ for kids who love to learn!**
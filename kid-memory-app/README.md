# Kid Memory Template

A reusable Flutter + Flame template for educational memory card-matching games designed for children ages 2-6. This template provides a solid foundation for creating engaging, educational memory games with a modular architecture that supports multiple learning modules.

## 🎯 Features

### Core Systems
- **AnalyticsManager**: Tracks correct/incorrect matches, session timestamps, and performance statistics
- **ModuleManager**: Handles module registration, unlocking, and management
- **SaveManager**: Hive-based local persistence for game progress and settings
- **AudioManager**: Comprehensive audio system for SFX, music, and card pronunciations

### Gameplay
- Card-flip memory matching mechanic with smooth animations
- Scoring system with move tracking and accuracy calculation
- Multiple difficulty levels and game sizes
- Win conditions with celebration animations

### GUI Screens
- **Main Menu**: Welcome screen with navigation options
- **Module Selector**: Grid-based module selection with unlock status
- **Parental Gate**: Math-based access control for parental oversight
- **Settings**: Comprehensive settings for audio, difficulty, and data management
- **Game Screen**: Immersive gameplay with Flame engine integration

### Modular Architecture
- `/lib/modules/` structure for easy module addition
- Pre-configured modules: shapes, colors, animals, jobs, farm, family
- Extensible system for adding new educational content

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- For iOS development: Xcode (macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd KidMemoryTemplate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: Latest
- Optimized for tablets and Fire OS devices
- Landscape orientation preferred

#### iOS
- Minimum iOS: 11.0
- Supports iPhone and iPad
- Landscape orientation for optimal gameplay

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── managers/                      # Core system managers
│   │   ├── analytics_manager.dart     # Analytics and tracking
│   │   ├── audio_manager.dart         # Audio playback system
│   │   ├── module_manager.dart        # Module management
│   │   └── save_manager.dart          # Data persistence
│   ├── models/                        # Data models
│   │   ├── game_module.dart           # Module and card models
│   │   └── game_module.g.dart         # Generated Hive adapters
│   ├── screens/                       # UI screens
│   │   ├── main_menu_screen.dart      # Main menu
│   │   ├── module_selector_screen.dart # Module selection
│   │   ├── game_screen.dart           # Game interface
│   │   ├── settings_screen.dart       # Settings and preferences
│   │   └── parental_gate_screen.dart  # Parental controls
│   └── components/                    # Reusable UI components
├── game/                              # Flame game engine
│   └── memory_game.dart               # Core game logic
└── modules/                           # Educational modules
    ├── shapes/                        # Shapes module
    ├── colors/                        # Colors module
    ├── animals/                       # Animals module
    ├── jobs/                          # Jobs module
    ├── farm/                          # Farm module
    └── family/                        # Family module
```

## 🎨 Adding New Modules

### 1. Create Module Structure
```bash
mkdir -p lib/modules/your_module
mkdir -p assets/images/your_module
mkdir -p assets/audio/your_module
```

### 2. Add Module Data
Create a module definition in `ModuleManager.initialize()`:

```dart
GameModule(
  id: 'your_module',
  name: 'Your Module',
  description: 'Module description',
  iconPath: 'assets/images/your_module/icon.png',
  backgroundPath: 'assets/images/your_module/background.png',
  cardPaths: [
    'assets/images/your_module/card1.png',
    'assets/images/your_module/card2.png',
    // ... more cards
  ],
  isUnlocked: false,
  difficultyLevel: 2,
  audioPaths: [
    'assets/audio/your_module/card1.mp3',
    'assets/audio/your_module/card2.mp3',
    // ... more audio files
  ],
),
```

### 3. Add Assets
- **Images**: Place card images in `assets/images/your_module/`
- **Audio**: Place pronunciation files in `assets/audio/your_module/`
- **Background**: Add background image for the module
- **Icon**: Create a module icon

### 4. Update pubspec.yaml
Add your asset paths to the `flutter.assets` section:

```yaml
assets:
  - assets/images/your_module/
  - assets/audio/your_module/
```

## 🎵 Audio Integration

### Supported Audio Formats
- **Music**: MP3, OGG, WAV
- **SFX**: MP3, OGG, WAV
- **Card Pronunciations**: MP3, OGG, WAV

### Audio File Structure
```
assets/audio/
├── sfx/                              # Sound effects
│   ├── card_flip.mp3
│   ├── match.mp3
│   ├── mismatch.mp3
│   ├── win.mp3
│   └── button_click.mp3
├── main_menu_music.mp3               # Main menu background music
├── game_music.mp3                    # Game background music
└── [module_name]/                    # Module-specific audio
    ├── background_music.mp3
    ├── card1.mp3
    ├── card2.mp3
    └── ...
```

### Using Audio in Code
```dart
// Play sound effect
audioManager.playCardFlip();

// Play card pronunciation
audioManager.playCardName('shapes', 'circle');

// Play module background music
audioManager.playModuleMusic('shapes');
```

## 🎨 Art Integration with Draw Things

### Recommended Art Specifications
- **Card Images**: 512x512px, PNG format with transparency
- **Background Images**: 1920x1080px, JPG/PNG format
- **Icons**: 256x256px, PNG format with transparency
- **Style**: Colorful, child-friendly, simple shapes and characters

### Draw Things Prompts
Here are some example prompts for creating assets:

#### Card Images
```
"Simple cartoon [object] on white background, bright colors, child-friendly style, no text, clean design"
```

#### Background Images
```
"Colorful educational background for [theme], playful design, suitable for children, landscape orientation"
```

#### Icons
```
"Simple icon representing [concept], colorful, child-friendly, minimal design, square format"
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Manual Testing Checklist
- [ ] All modules load correctly
- [ ] Audio plays without issues
- [ ] Game mechanics work properly
- [ ] Settings persist between sessions
- [ ] Parental gate functions correctly
- [ ] Analytics track properly
- [ ] Cross-platform compatibility

## 📱 Platform Considerations

### Android / Fire OS
- Optimized for tablets and Fire tablets
- Landscape orientation preferred
- Touch-friendly interface
- Offline functionality

### iOS
- iPhone and iPad support
- Landscape orientation for gameplay
- Portrait orientation for menus
- App Store compliance

### Performance
- Smooth 60fps animations
- Efficient memory usage
- Fast loading times
- Battery optimization

## 🔧 Customization

### Theming
Modify colors and styles in `main.dart`:

```dart
theme: ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: GoogleFonts.poppins().fontFamily,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4CAF50),
    brightness: Brightness.light,
  ),
),
```

### Game Mechanics
Customize game behavior in `memory_game.dart`:

```dart
// Adjust card size
final cardSize = 80.0;

// Modify scoring
_score += 10; // Points per match

// Change game grid
final columns = 4;
final rows = 3;
```

### Analytics
Add custom tracking in `analytics_manager.dart`:

```dart
void recordCustomEvent(String eventName, Map<String, dynamic> data) {
  // Custom analytics implementation
}
```

## 🚀 Deployment

### Android
1. Generate signed APK:
   ```bash
   flutter build apk --release
   ```

2. Generate App Bundle:
   ```bash
   flutter build appbundle --release
   ```

### iOS
1. Build for iOS:
   ```bash
   flutter build ios --release
   ```

2. Archive in Xcode for App Store submission

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For questions, issues, or contributions:
- Create an issue on GitHub
- Check the documentation
- Review the code comments

## 🔮 Future Enhancements

- [ ] Multiplayer support
- [ ] Cloud save synchronization
- [ ] Advanced analytics dashboard
- [ ] Custom module creator
- [ ] Voice recognition for card names
- [ ] Augmented reality features
- [ ] Accessibility improvements
- [ ] Multiple language support

---

**Happy coding and creating amazing educational games for kids! 🎮✨**
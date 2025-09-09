import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';
import '../managers/save_manager.dart';
import '../managers/parental_gate_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            final audioManager = context.read<AudioManager>();
            audioManager.playButtonClick();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Audio Settings
                  _buildSettingsSection(
                    'Audio Settings',
                    Icons.volume_up,
                    [
                      Consumer<AudioManager>(
                        builder: (context, audioManager, child) {
                          return _buildSwitchTile(
                            'Music',
                            'Background music',
                            audioManager.isMusicEnabled,
                            (value) {
                              audioManager.setMusicEnabled(value);
                            },
                            Icons.music_note,
                          );
                        },
                      ),
                      Consumer<AudioManager>(
                        builder: (context, audioManager, child) {
                          return _buildSwitchTile(
                            'Sound Effects',
                            'Game sound effects',
                            audioManager.isSoundEnabled,
                            (value) {
                              audioManager.setSoundEnabled(value);
                            },
                            Icons.speaker,
                          );
                        },
                      ),
                      Consumer<AudioManager>(
                        builder: (context, audioManager, child) {
                          return _buildSwitchTile(
                            'Voice',
                            'Voice narration',
                            audioManager.isVoiceEnabled,
                            (value) {
                              audioManager.setVoiceEnabled(value);
                            },
                            Icons.record_voice_over,
                          );
                        },
                      ),
                      Consumer<AudioManager>(
                        builder: (context, audioManager, child) {
                          return _buildSliderTile(
                            'Music Volume',
                            audioManager.musicVolume,
                            (value) {
                              audioManager.setMusicVolume(value);
                            },
                            Icons.volume_up,
                          );
                        },
                      ),
                      Consumer<AudioManager>(
                        builder: (context, audioManager, child) {
                          return _buildSliderTile(
                            'Sound Volume',
                            audioManager.soundVolume,
                            (value) {
                              audioManager.setSoundVolume(value);
                            },
                            Icons.volume_up,
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Game Settings
                  _buildSettingsSection(
                    'Game Settings',
                    Icons.games,
                    [
                      Consumer<SaveManager>(
                        builder: (context, saveManager, child) {
                          return _buildInfoTile(
                            'Games Played',
                            '${saveManager.totalGamesPlayed}',
                            Icons.play_circle,
                          );
                        },
                      ),
                      Consumer<SaveManager>(
                        builder: (context, saveManager, child) {
                          return _buildInfoTile(
                            'High Score',
                            '${saveManager.highScore}',
                            Icons.star,
                          );
                        },
                      ),
                      Consumer<SaveManager>(
                        builder: (context, saveManager, child) {
                          return _buildInfoTile(
                            'Unlocked Modules',
                            '${saveManager.unlockedModules.length}',
                            Icons.extension,
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Data Management
                  _buildSettingsSection(
                    'Data Management',
                    Icons.storage,
                    [
                      _buildActionTile(
                        'Clear Game Data',
                        'Reset all progress and settings',
                        Icons.delete_forever,
                        () => _showClearDataDialog(),
                      ),
                      _buildActionTile(
                        'Export Data',
                        'Backup your progress',
                        Icons.file_download,
                        () => _exportData(),
                      ),
                      _buildActionTile(
                        'Import Data',
                        'Restore from backup',
                        Icons.file_upload,
                        () => _importData(),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // App Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Kids Game Template',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Educational memory games for kids',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white60),
      ),
      trailing: Switch(
        value: value,
        onChanged: (newValue) {
          final audioManager = context.read<AudioManager>();
          audioManager.playButtonClick();
          onChanged(newValue);
        },
        activeColor: const Color(0xFF4CAF50),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    double value,
    ValueChanged<double> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Slider(
        value: value,
        onChanged: (newValue) {
          onChanged(newValue);
        },
        activeColor: const Color(0xFF4CAF50),
        inactiveColor: Colors.white30,
      ),
      trailing: Text(
        '${(value * 100).round()}%',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white60),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white30,
        size: 16,
      ),
      onTap: () {
        final audioManager = context.read<AudioManager>();
        audioManager.playButtonClick();
        onTap();
      },
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Game Data'),
        content: const Text(
          'This will permanently delete all your progress, scores, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final saveManager = context.read<SaveManager>();
              saveManager.clearAllData();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Game data cleared successfully'),
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    final saveManager = context.read<SaveManager>();
    final data = saveManager.exportData();
    
    // In a real implementation, this would save to a file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
      ),
    );
  }

  void _importData() {
    // In a real implementation, this would load from a file
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data import feature coming soon!'),
      ),
    );
  }
}
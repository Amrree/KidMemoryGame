import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';
import '../managers/save_manager.dart';
import '../managers/analytics_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

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
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<AudioManager>().playButtonClick();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
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
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSettingsCard(
                    'Audio Settings',
                    Icons.volume_up,
                    [
                      _buildSoundToggle(),
                      _buildMusicToggle(),
                      _buildSoundVolumeSlider(),
                      _buildMusicVolumeSlider(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSettingsCard(
                    'Game Settings',
                    Icons.games,
                    [
                      _buildDifficultySelector(),
                      _buildResetProgressButton(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSettingsCard(
                    'Statistics',
                    Icons.analytics,
                    [
                      _buildStatsDisplay(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSettingsCard(
                    'Data Management',
                    Icons.storage,
                    [
                      _buildClearDataButton(),
                      _buildExportDataButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF4CAF50), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSoundToggle() {
    return Consumer2<AudioManager, SaveManager>(
      builder: (context, audioManager, saveManager, child) {
        return SwitchListTile(
          title: const Text('Sound Effects'),
          subtitle: const Text('Enable/disable sound effects'),
          value: audioManager.isSoundEnabled,
          onChanged: (value) {
            audioManager.setSoundEnabled(value);
            saveManager.setSoundEnabled(value);
          },
          activeColor: const Color(0xFF4CAF50),
        );
      },
    );
  }

  Widget _buildMusicToggle() {
    return Consumer2<AudioManager, SaveManager>(
      builder: (context, audioManager, saveManager, child) {
        return SwitchListTile(
          title: const Text('Background Music'),
          subtitle: const Text('Enable/disable background music'),
          value: audioManager.isMusicEnabled,
          onChanged: (value) {
            audioManager.setMusicEnabled(value);
            saveManager.setMusicEnabled(value);
          },
          activeColor: const Color(0xFF4CAF50),
        );
      },
    );
  }

  Widget _buildSoundVolumeSlider() {
    return Consumer2<AudioManager, SaveManager>(
      builder: (context, audioManager, saveManager, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sound Volume: ${(audioManager.soundVolume * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: audioManager.soundVolume,
              onChanged: (value) {
                audioManager.setSoundVolume(value);
                saveManager.setSoundVolume(value);
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMusicVolumeSlider() {
    return Consumer2<AudioManager, SaveManager>(
      builder: (context, audioManager, saveManager, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Music Volume: ${(audioManager.musicVolume * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: audioManager.musicVolume,
              onChanged: (value) {
                audioManager.setMusicVolume(value);
                saveManager.setMusicVolume(value);
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDifficultySelector() {
    return Consumer<SaveManager>(
      builder: (context, saveManager, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Difficulty Level',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(3, (index) {
                final difficulty = index + 1;
                return Expanded(
                  child: RadioListTile<int>(
                    title: Text('Level $difficulty'),
                    value: difficulty,
                    groupValue: saveManager.selectedDifficulty,
                    onChanged: (value) {
                      if (value != null) {
                        saveManager.setSelectedDifficulty(value);
                      }
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResetProgressButton() {
    return ListTile(
      leading: const Icon(Icons.refresh, color: Colors.orange),
      title: const Text('Reset Progress'),
      subtitle: const Text('Clear all game progress and statistics'),
      onTap: () => _showResetDialog(),
    );
  }

  Widget _buildStatsDisplay() {
    return Consumer<AnalyticsManager>(
      builder: (context, analyticsManager, child) {
        final stats = analyticsManager.getPerformanceStats();
        return Column(
          children: [
            _buildStatRow('Total Sessions', '${stats['totalSessions']}'),
            _buildStatRow('Average Accuracy', '${(stats['averageAccuracy'] * 100).toStringAsFixed(1)}%'),
            _buildStatRow('Best Accuracy', '${(stats['bestAccuracy'] * 100).toStringAsFixed(1)}%'),
            _buildStatRow('Average Duration', '${(stats['averageDuration'] / 60).toStringAsFixed(1)} min'),
            _buildStatRow('Fastest Time', '${(stats['fastestTime'] / 60).toStringAsFixed(1)} min'),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Color(0xFF4CAF50))),
        ],
      ),
    );
  }

  Widget _buildClearDataButton() {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: const Text('Clear All Data'),
      subtitle: const Text('Delete all saved data and settings'),
      onTap: () => _showClearDataDialog(),
    );
  }

  Widget _buildExportDataButton() {
    return ListTile(
      leading: const Icon(Icons.download, color: Colors.blue),
      title: const Text('Export Data'),
      subtitle: const Text('Export your game data'),
      onTap: () => _exportData(),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'Are you sure you want to reset all progress? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AnalyticsManager>().clearAnalytics();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress reset successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete all saved data, settings, and progress. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SaveManager>().resetAllData();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    final saveManager = context.read<SaveManager>();
    final data = saveManager.exportSaveData();
    
    // In a real app, you would implement actual data export
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data export feature coming soon!'),
      ),
    );
  }
}
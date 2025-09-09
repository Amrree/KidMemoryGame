import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';
import '../managers/parental_gate_manager.dart';

class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _passcodeController = TextEditingController();
  bool _isUnlocked = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkUnlockStatus();
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

  void _checkUnlockStatus() {
    final parentalGateManager = context.read<ParentalGateManager>();
    setState(() {
      _isUnlocked = parentalGateManager.isUnlocked;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parental Controls',
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
              child: _isUnlocked ? _buildUnlockedView() : _buildLockedView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lock icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.lock,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        
        const Text(
          'Parental Controls',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        
        const Text(
          'Enter passcode to access parental settings',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        
        // Passcode input
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: TextField(
            controller: _passcodeController,
            obscureText: true,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Enter passcode',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        
        if (_errorMessage.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        
        const SizedBox(height: 32),
        
        // Unlock button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: ElevatedButton(
            onPressed: _attemptUnlock,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4CAF50),
              elevation: 8,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Unlock',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Forgot passcode
        TextButton(
          onPressed: () {
            _showForgotPasscodeDialog();
          },
          child: const Text(
            'Forgot passcode?',
            style: TextStyle(
              color: Colors.white70,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockedView() {
    return Consumer<ParentalGateManager>(
      builder: (context, parentalGateManager, child) {
        return Column(
          children: [
            // Success message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Text(
                    'Parental controls unlocked',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings sections
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSettingsSection(
                      'Privacy & Data',
                      Icons.privacy_tip,
                      [
                        _buildSwitchTile(
                          'Analytics',
                          'Track game usage and performance',
                          parentalGateManager.analyticsEnabled,
                          (value) => parentalGateManager.setAnalyticsEnabled(value),
                        ),
                        _buildSwitchTile(
                          'Data Collection',
                          'Collect usage data for improvements',
                          parentalGateManager.dataCollectionEnabled,
                          (value) => parentalGateManager.setDataCollectionEnabled(value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildSettingsSection(
                      'Purchases & Ads',
                      Icons.shopping_cart,
                      [
                        _buildSwitchTile(
                          'In-App Purchases',
                          'Allow purchases within the app',
                          parentalGateManager.purchasesEnabled,
                          (value) => parentalGateManager.setPurchasesEnabled(value),
                        ),
                        _buildSwitchTile(
                          'Advertisements',
                          'Show advertisements in the app',
                          parentalGateManager.advertisementsEnabled,
                          (value) => parentalGateManager.setAdvertisementsEnabled(value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildSettingsSection(
                      'Social Features',
                      Icons.people,
                      [
                        _buildSwitchTile(
                          'Social Features',
                          'Enable social sharing and features',
                          parentalGateManager.socialFeaturesEnabled,
                          (value) => parentalGateManager.setSocialFeaturesEnabled(value),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildSettingsSection(
                      'Security',
                      Icons.security,
                      [
                        _buildActionTile(
                          'Change Passcode',
                          'Update parental control passcode',
                          Icons.lock_reset,
                          () => _showChangePasscodeDialog(),
                        ),
                        _buildActionTile(
                          'Disable Parental Controls',
                          'Turn off all parental restrictions',
                          Icons.lock_open,
                          () => _showDisableDialog(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Lock button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  final audioManager = context.read<AudioManager>();
                  audioManager.playButtonClick();
                  parentalGateManager.lock();
                  setState(() {
                    _isUnlocked = false;
                  });
                },
                icon: const Icon(Icons.lock),
                label: const Text('Lock Parental Controls'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
  ) {
    return ListTile(
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

  void _attemptUnlock() async {
    final parentalGateManager = context.read<ParentalGateManager>();
    final audioManager = context.read<AudioManager>();
    
    audioManager.playButtonClick();
    
    final success = await parentalGateManager.attemptUnlock(_passcodeController.text);
    
    if (success) {
      setState(() {
        _isUnlocked = true;
        _errorMessage = '';
      });
      _passcodeController.clear();
    } else {
      setState(() {
        _errorMessage = 'Incorrect passcode. Please try again.';
      });
    }
  }

  void _showForgotPasscodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Passcode?'),
        content: const Text(
          'Default passcode is 1234. If you have changed it and forgotten it, you can reset the app data to restore default settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showChangePasscodeDialog() {
    final newPasscodeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Passcode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasscodeController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New passcode (4+ digits)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final parentalGateManager = context.read<ParentalGateManager>();
              final success = parentalGateManager.setPasscode(newPasscodeController.text);
              
              if (success) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passcode updated successfully'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passcode must be at least 4 digits'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDisableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Parental Controls'),
        content: const Text(
          'This will disable all parental controls and restrictions. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final parentalGateManager = context.read<ParentalGateManager>();
              parentalGateManager.setEnabled(false);
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Parental controls disabled'),
                ),
              );
            },
            child: const Text(
              'Disable',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
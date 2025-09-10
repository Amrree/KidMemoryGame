import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/audio_manager.dart';

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

  final TextEditingController _answerController = TextEditingController();
  final List<String> _questions = [
    'What is 2 + 3?',
    'What is 5 + 4?',
    'What is 7 - 2?',
    'What is 3 + 6?',
    'What is 8 - 3?',
  ];
  
  final List<int> _answers = [5, 9, 5, 9, 5];
  
  int _currentQuestionIndex = 0;
  int _attempts = 0;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _shuffleQuestions();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  void _shuffleQuestions() {
    final random = DateTime.now().millisecondsSinceEpoch % _questions.length;
    _currentQuestionIndex = random;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2E7D32),
              Color(0xFF1B5E20),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lock icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isCorrect ? Icons.check : Icons.lock,
                        size: 50,
                        color: _isCorrect ? const Color(0xFF4CAF50) : Colors.orange,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Title
                    Text(
                      'Parental Gate',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      'Please answer the math question to continue',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Question card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            _questions[_currentQuestionIndex],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Answer input
                          TextField(
                            controller: _answerController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your answer',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4CAF50),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4CAF50),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _checkAnswer(),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _checkAnswer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Submit Answer',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          // Attempts counter
                          if (_attempts > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                'Attempts: $_attempts/3',
                                style: TextStyle(
                                  color: _attempts >= 3 ? Colors.red : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Back button
                    TextButton(
                      onPressed: () {
                        context.read<AudioManager>().playButtonClick();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Go Back',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkAnswer() {
    final audioManager = context.read<AudioManager>();
    audioManager.playButtonClick();
    
    final answer = int.tryParse(_answerController.text.trim());
    final correctAnswer = _answers[_currentQuestionIndex];
    
    if (answer == correctAnswer) {
      setState(() {
        _isCorrect = true;
      });
      
      audioManager.playWin();
      
      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correct! Access granted.'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pop();
      });
    } else {
      setState(() {
        _attempts++;
      });
      
      audioManager.playMismatch();
      
      if (_attempts >= 3) {
        // Too many attempts, go back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Too many incorrect attempts. Access denied.'),
            backgroundColor: Colors.red,
          ),
        );
        
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).pop();
        });
      } else {
        // Show error and clear input
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect. Try again. (${3 - _attempts} attempts left)'),
            backgroundColor: Colors.orange,
          ),
        );
        
        _answerController.clear();
      }
    }
  }
}
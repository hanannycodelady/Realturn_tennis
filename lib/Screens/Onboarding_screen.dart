import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realturn_app/Screens/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of onboarding data with tennis-inspired content and blue-white gradient
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'image': 'assets/image/tennis-ball-disintegrating-with-copy-space2.jpg', 
      'title': 'Welcome to Real Turn tennis uganda',
      'description': 'Unleash your tennis passion! Join a vibrant community.',
      'gradient': [const Color.fromARGB(255, 18, 98, 245), const Color.fromARGB(255, 121, 181, 245)]
    },
    {
      'image': 'assets/image/tennis-racket-and-tennis-balls-on-tennis-hard-court-photo.jpg', 
      'title': 'Support the Game',
      'description': 'Make a difference! Your donations help players access training, equipment, and opportunities to shine on the court.',
      'gradient': [const Color.fromARGB(255, 18, 98, 245), const Color.fromARGB(255, 121, 181, 245)]
    },
    {
      'image': 'assets/image/tennis.jpeg', 
      'title': 'Inspire Others to Join Tennis',
      'description': 'Share your love for tennis! Motivate others to pick up a racket and play.',
      'gradient': [const Color.fromARGB(255, 18, 98, 245), const Color.fromARGB(255, 121, 181, 245)]
    }
  ];

  @override
  void initState() {
    super.initState();
    // Set system UI overlay style to match the theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Go to next page or finish onboarding
  void _goToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          return _buildOnboardingPage(
            image: _onboardingData[index]['image'],
            title: _onboardingData[index]['title'],
            description: _onboardingData[index]['description'],
            gradientColors: _onboardingData[index]['gradient'],
          );
        },
      ),
    );
  }

  Widget _buildOnboardingPage({
    required String image,
    required String title,
    required String description,
    required List<Color> gradientColors,
  }) {
    return Stack(
      children: [
        // Background image covering the entire screen
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),

        // Gradient overlay to ensure text readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  gradientColors[0].withOpacity(0.7),
                  gradientColors[1].withOpacity(0.9),
                  Colors.white.withOpacity(0.9), // Add white at the bottom
                ],
                stops: const [0.2, 0.5, 0.8, 1.0], // Adjusted stops to include white
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2), // Push content down

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4.0,
                        color: Color(0xFF000000),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Color(0xFF000000),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Indicators and buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 24.0, right: 24.0),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 24.0 : 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: _currentPage == index
                                ? Colors.white // White for better visibility on background image
                                : const Color.fromARGB(255, 243, 245, 247).withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Next button - Centered with specific width, white background, black text
                    Center(
                      child: SizedBox(
                        width: 180, // Specific width for the button
                        child: ElevatedButton(
                          onPressed: _goToNextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 13, 111, 240), // White background
                            foregroundColor: Colors.black, // Black text
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4, // Shadow for better visibility
                          ),
                          child: Text(
                            _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 248, 244, 244), // Explicitly set to black
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Skip button (not shown on last page)
                    if (_currentPage < _onboardingData.length - 1)
                      TextButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            _onboardingData.length - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 13, 13),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2.0,
                                color: Color.fromARGB(255, 255, 252, 252),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
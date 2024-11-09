import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'resources.dart';
import 'community.dart';
import 'roadmap.dart';
import 'settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => OnboardingState()..loadOnboardingState(),  // Load the onboarding state when app starts
      child: MyApp(),
    ),
  );
}

class OnboardingState extends ChangeNotifier {
  bool _isFirstTime = true;

  bool get isFirstTime => _isFirstTime;

  // Load the onboarding state from SharedPreferences
  Future<void> loadOnboardingState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    _isFirstTime = !seenOnboarding;
    notifyListeners();  // Notify listeners that the state has changed
  }

  // Set onboarding as complete
  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    _isFirstTime = false;
    notifyListeners();  // Notify listeners that the state has changed
  }

  // Reset onboarding state (for testing purposes or resetting the app)
  Future<void> resetOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', false);
    _isFirstTime = true;
    notifyListeners();  // Notify listeners that the state has changed
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portland Bike Hub',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Consumer<OnboardingState>(
        builder: (context, onboardingState, _) {
          return onboardingState.isFirstTime
              ? OnboardingScreen(onboardingComplete: () {
                  // Set onboarding complete and notify listeners
                  onboardingState.completeOnboarding();
                })
              : HomeScreen();
        },
      ),
    );
  }
}

// class MyAppState extends ChangeNotifier {
//   // Keeping the existing logic intact
// }

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onboardingComplete;

  const OnboardingScreen({required this.onboardingComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  String userName = "";

  void _goToNextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingPage(
            title: "Are you new to biking?",
            description: "No worries, we've got you covered.",
            // imagePath: "assets/onboarding1.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "Are you biking alone or in a group?",
            description: "Tell us more to personalize your experience.",
            // imagePath: "assets/onboarding2.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "Would you like to join a group?",
            description: "Find and join a biking community near you.",
            // imagePath: "assets/onboarding3.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "What's your name?",
            description: "Please enter your name to get started.",
            // imagePath: "assets/onboarding4.png",
            isInputPage: true,
            onInputSubmitted: (input) {
              setState(() {
                userName = input;
              });
              _goToNextPage();
            },
          ),
          OnboardingPage(
            title: "How can we help you today?",
            description: "Find routes, plan rides, or explore community resources.",
            // imagePath: "assets/onboarding5.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "We're all set! Let's get started on your biking journey, $userName!",
            description: "",
            // imagePath: "assets/onboarding6.png",
            onNext: () {
              widget.onboardingComplete();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  // final String imagePath;
  final bool isInputPage;
  final VoidCallback? onNext;
  final ValueChanged<String>? onInputSubmitted;

  const OnboardingPage({
    required this.title,
    required this.description,
    // required this.imagePath,
    this.isInputPage = false,
    this.onNext,
    this.onInputSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(imagePath),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          if (description.isNotEmpty)
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          if (isInputPage) ...[
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Name',
              ),
              onSubmitted: onInputSubmitted,
            ),
          ] else ...[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onNext,
              child: Text('Next'),
            ),
          ]
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    RoadmapScreen(),
    ResourcesScreen(),
    CommunityScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _resetOnboarding() async {
    // Access the OnboardingState and reset the onboarding state
    await Provider.of<OnboardingState>(context, listen: false).resetOnboarding();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(
            onboardingComplete: () {
              // Complete the onboarding logic
              Provider.of<OnboardingState>(context, listen: false).completeOnboarding();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portland Bike Hub'),
        actions: [
          IconButton(
            icon: Icon(Icons.restart_alt),
            onPressed: _resetOnboarding,
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: 'My Roadmap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pedal_bike),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}


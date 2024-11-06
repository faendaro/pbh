import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'resources.dart';
import 'community.dart';
import 'roadmap.dart';
import 'settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    setState(() {
      _isFirstTime = !seenOnboarding;
    });
  }

  Future<void> _setOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Portland Bike Hub',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: _isFirstTime ? OnboardingScreen(onboardingComplete: _setOnboardingComplete) : HomeScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // Keeping the existing logic intact
}

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
            imagePath: "assets/onboarding1.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "Are you biking alone or in a group?",
            description: "Tell us more to personalize your experience.",
            imagePath: "assets/onboarding2.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "Would you like to join a group?",
            description: "Find and join a biking community near you.",
            imagePath: "assets/onboarding3.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "What's your name?",
            description: "Please enter your name to get started.",
            imagePath: "assets/onboarding4.png",
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
            imagePath: "assets/onboarding5.png",
            onNext: _goToNextPage,
          ),
          OnboardingPage(
            title: "We're all set! Let's get started on your biking journey, $userName!",
            description: "",
            imagePath: "assets/onboarding6.png",
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
  final String imagePath;
  final bool isInputPage;
  final VoidCallback? onNext;
  final ValueChanged<String>? onInputSubmitted;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
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
          Image.asset(imagePath),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PBH'),
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


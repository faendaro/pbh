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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            disabledBackgroundColor: Colors.grey,
            disabledForegroundColor: Colors.black,
          ),
        ),
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
  int bikingExperience = 0; // Tracks if the user is new to biking
  String bikingPurpose = ""; // Tracks the user's biking purpose: "Recreation", "Commuting", or "Both"
  bool groupInterest = false; // Tracks if the user wants to join a group (Yes/No)
  List<String> selectedPriorities = []; // List to store selected priorities

  int currentPageIndex = 0;

  void _goToNextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _goToPreviousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _updatePageIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  Future<void> _finishOnboarding() async {
    widget.onboardingComplete();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userName', userName);
    await prefs.setString('bikingPurpose', bikingPurpose);
    await prefs.setInt('bikingExperience', bikingExperience);
    // Reset onboarding state (for testing purposes or resetting the app)
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar at the top
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: ((currentPageIndex + ((-0.1 * currentPageIndex) + 0.5)) / 5.0), // There are 6 screens, so max index is 5
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),
            
            // Bicycle icons for the progress bar
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Icon(
                    Icons.directions_bike,
                    color: index == currentPageIndex ? Colors.deepPurple : const Color.fromARGB(0, 255, 255, 255),
                    size: 30,
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _updatePageIndex,
                children: [
                  // First screen: Are you new to biking?
                  OnboardingPage(
                    title: "What best describes your experience with biking?",
                    description: "No matter your experience, we've got you covered.",
                    onBackPressed: null,
                    onNext: null, // Disable the "Next" button for this screen
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bikingExperience = 0;
                            });
                            _goToNextPage();
                          },
                          child: Text('I\'m brand new!'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bikingExperience = 1;
                            });
                            _goToNextPage();
                          },
                          child: Text('I have some experience'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bikingExperience = 2;
                            });
                            _goToNextPage();
                          },
                          child: Text('I already bike a lot'),
                        ),
                      ],
                    ),
                  ),
              
                  // Second screen: Biking Purpose (Recreation, Commuting, or Both)
                  OnboardingPage(
                    title: bikingExperience == 0
                        ? "Are you interested in biking recreationally, for commuting, or both?"
                        : "Do you bike recreationally, for commuting, or both?",
                    description: "Please choose one of the options below:",
                    onBackPressed: _goToPreviousPage,
                    onNext: null, // Disable the "Next" button for this screen
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bikingPurpose = "recreation"; // User selected "Recreation"
                            });
                            _goToNextPage();
                          },
                          child: Text('Mostly recreationally'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bikingPurpose = "commute"; // User selected "Commuting"
                            });
                            _goToNextPage();
                          },
                          child: Text('Mostly commuting'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bikingPurpose = "both"; // User selected "Both"
                            });
                            _goToNextPage();
                          },
                          child: Text('Both!'),
                        ),
                      ],
                    ),
                  ),
              
                  // Third screen: Would you like to join a group? (Yes/No)
                  OnboardingPage(
                    title: "Are you interested in connecting with other bikers?",
                    description: "The Portland Bike Hub offers ways to meet other bikers with similar interests and levels of experience.",
                    onBackPressed: _goToPreviousPage,
                    onNext: null, // Disable the "Next" button for this screen
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              groupInterest = true; // User selected "Yes"
                            });
                            _goToNextPage();
                          },
                          child: Text('I\'d love to!'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              groupInterest = false; // User selected "No"
                            });
                            _goToNextPage();
                          },
                          child: Text('Not right now'),
                        ),
                      ],
                    ),
                  ),
              
                  // Fourth screen: What's your name?
                  OnboardingPage(
                    title: "What's your name?",
                    description: "Please enter your name to get started.",
                    onBackPressed: _goToPreviousPage,
                    onNext: null,
                    isInputPage: true,
                    onInputSubmitted: (input) {
                      setState(() {
                        userName = input;
                      });
                      _goToNextPage();
                    },
                  ),
              
                  // Fifth screen: interests
                  OnboardingPage(
                    title: "What are your priorities?",
                    description: "Select the options that best describe your biking interests:",
                    onBackPressed: _goToPreviousPage,
                    onNext: _goToNextPage,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                          title: Text("Find a bike and/or gear"),
                          value: selectedPriorities.contains("Find a bike and/or gear"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedPriorities.add("Find a bike and/or gear");
                              } else {
                                selectedPriorities.remove("Find a bike and/or gear");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Find friends to bike with"),
                          value: selectedPriorities.contains("Find friends to bike with"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedPriorities.add("Find friends to bike with");
                              } else {
                                selectedPriorities.remove("Find friends to bike with");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Find routes to work"),
                          value: selectedPriorities.contains("Find routes to work"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedPriorities.add("Find routes to work");
                              } else {
                                selectedPriorities.remove("Find routes to work");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Use biking to explore Portland"),
                          value: selectedPriorities.contains("Use biking to explore Portland"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedPriorities.add("Use biking to explore Portland");
                              } else {
                                selectedPriorities.remove("Use biking to explore Portland");
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text("Get some exercise"),
                          value: selectedPriorities.contains("Get some exercise"),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedPriorities.add("Get some exercise");
                              } else {
                                selectedPriorities.remove("Get some exercise");
                              }
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: selectedPriorities.isNotEmpty
                              ? () {
                                  // Store selected priorities when moving to next page
                                  setState(() {
                                    // Store selected priorities
                                  });
                                  _goToNextPage();
                                }
                              : null, // Disable "Next" if no options are selected
                          child: Text('Next'),
                        ),
                      ],
                    ),
                  ),
              
                  // Sixth screen: We're all set! Let's get started
                  OnboardingPage(
                    title: "We're all set! Let's get started on your biking journey, $userName!",
                    description: "",
                    onBackPressed: _goToPreviousPage,
                    onNext: _finishOnboarding,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final bool isInputPage;
  final VoidCallback? onNext; // onNext is for the "Next" button (for other pages)
  final ValueChanged<String>? onInputSubmitted; // For submitting text input
  final Widget? child; // This is for custom widgets (e.g., the Yes/No buttons or multiple options)
  final VoidCallback? onBackPressed; // Callback for back button press

  const OnboardingPage({
    required this.title,
    required this.description,
    this.isInputPage = false,
    this.onNext,
    this.onInputSubmitted,
    this.child, // Custom content like buttons
    this.onBackPressed, // Callback for back button
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isTextFieldEmpty = true; // Track if the TextField is empty

  // Function to handle the change in TextField and enable/disable the Next button
  void _onTextChanged(String text) {
    setState(() {
      _isTextFieldEmpty = text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.onBackPressed != null
          ? IconButton(
              icon: Icon(Icons.arrow_back), // Back arrow icon
              onPressed: widget.onBackPressed, // Call the onBackPressed callback when back is pressed
            )
          : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
      
            // Description Text
            if (widget.description.isNotEmpty)
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
      
            // Custom content (like buttons) passed through the `child` property
            if (widget.child != null) ...[
              SizedBox(height: 20),
              widget.child!, // Render custom child widget here (e.g., Yes/No buttons)
            ]
      
            // Input page with TextField and Next button
            else if (widget.isInputPage) ...[
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Name',
                ),
                onChanged: _onTextChanged, // Listen for text changes
                onSubmitted: widget.onInputSubmitted, // When the user presses "Enter" on the keyboard
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isTextFieldEmpty ? null : () { // Disable button if the TextField is empty
                  widget.onInputSubmitted?.call(_controller.text); // Call the onInputSubmitted with the input text
                },
                child: Text('Next'),
              ),
            ] 
            
            // Default button for "Next" action on other pages
            else if (widget.onNext != null) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onNext,
                child: Text('Next'),
              ),
            ],
          ],
        ),
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


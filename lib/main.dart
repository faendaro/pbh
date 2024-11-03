import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: HomeScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // var current = WordPair.random();

  // void getNext() {
  //   current = WordPair.random();
  //   notifyListeners();
  // }

  // var favorites = <WordPair>[];

  // void toggleFavorite() {
  //   if (favorites.contains(current)) {
  //     favorites.remove(current);
  //   } else {
  //     favorites.add(current);
  //   }
  //   notifyListeners();
  // }

  // void resetFavorites() {
  //   favorites.clear();
  //   notifyListeners();
  // }
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

class RoadmapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('My Roadmap Screen'));
  }
}

class ResourcesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resources',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                ResourceTile(
                  color: Colors.blue,
                  icon: Icons.map,
                  label: 'Find a Route',
                  webResources: [
                    'https://example.com/routes',
                    'https://example.com/local_routes',
                    'https://example.com/popular_routes',
                  ],
                ),
                ResourceTile(
                  color: Colors.green,
                  icon: Icons.wb_sunny,
                  label: 'Weather Planning',
                  webResources: [
                    'https://weather.com',
                    'https://accuweather.com',
                    'https://localweather.com',
                  ],
                ),
                ResourceTile(
                  color: Colors.orange,
                  icon: Icons.shopping_bag,
                  label: 'Find Gear',
                  webResources: [
                    'https://example.com/gear_guide',
                    'https://example.com/local_shops',
                    'https://example.com/online_stores',
                  ],
                ),
                ResourceTile(
                  color: Colors.purple,
                  icon: Icons.directions_bike,
                  label: 'Find a Bike',
                  webResources: [
                    'https://example.com/find_a_bike',
                    'https://example.com/rentals',
                    'https://example.com/local_market',
                  ],
                ),
                ResourceTile(
                  color: Colors.red,
                  icon: Icons.group,
                  label: 'Find a Crew',
                  webResources: [
                    'https://example.com/local_clubs',
                    'https://example.com/online_communities',
                    'https://example.com/meetups',
                  ],
                ),
                ResourceTile(
                  color: Colors.teal,
                  icon: Icons.lock,
                  label: 'Bike Storage',
                  webResources: [
                    'https://example.com/storage_solutions',
                    'https://example.com/diy_storage',
                    'https://example.com/local_options',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResourceTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final List<String> webResources;

  const ResourceTile({
    required this.color,
    required this.icon,
    required this.label,
    required this.webResources,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResourceDetailScreen(
                label: label,
                webResources: webResources,
              ),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourceDetailScreen extends StatelessWidget {
  final String label;
  final List<String> webResources;

  const ResourceDetailScreen({required this.label, required this.webResources});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: ListView.builder(
        itemCount: webResources.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(webResources[index]),
            onTap: () {
              // Open the web resource in a browser
              // launchURL(Uri.parse(webResources[index]));
            },
          );
        },
      ),
    );
  }

  // void launchURL(Uri url) async {
  //   // Launch the URL in the default browser
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}


class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Community Screen'));
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Settings Screen'));
  }
}
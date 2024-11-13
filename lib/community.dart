import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Dummy data for community members and messages
  final List<Map<String, String>> _messages = [
    {
      'name': 'Alice',
      'message': 'Hey, how are you doing today?',
      'time': '2 mins ago',
      'avatar': './assets/woman1.jpg',
    },
    {
      'name': 'Bob',
      'message': 'I just finished my ride. Great weather today!',
      'time': '5 mins ago',
      'avatar': './assets/man1.jpg',
    },
    {
      'name': 'Charlie',
      'message': 'Let\'s plan a weekend ride!',
      'time': '10 mins ago',
      'avatar': './assets/man2.jpg',
    },
    {
      'name': 'Dana',
      'message': 'Can anyone recommend a good route for commuting?',
      'time': '15 mins ago',
      'avatar': './assets/woman2.jpg',
    },
    {
      'name': 'Eve',
      'message': 'I\'ve been using my bike for recreation mostly. Loving it!',
      'time': '20 mins ago',
      'avatar': './assets/woman3.jpg',
    },
  ];

  // Controller for the search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Column(
        children: [
          // Search Bar at the top
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search community members...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          
          // Message List
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(message['avatar']!),
                  ),
                  title: Text(message['name']!),
                  subtitle: Text(message['message']!),
                  trailing: Text(message['time']!),
                  onTap: () {
                    // Implement tap to open chat with that person
                    // For now, just print the name
                    print('Tapped on message from ${message['name']}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

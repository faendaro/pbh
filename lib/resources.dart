import 'package:flutter/material.dart';

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
                    Resource('Portland Bike Maps', 'https://www.portland.gov/transportation/bike-maps'),
                    Resource('Ride with GPS - Portland Routes', 'https://ridewithgps.com/regions/1095-portland'),
                    Resource('Strava - Popular Routes in Portland', 'https://www.strava.com/activities/popular'),
                  ],
                ),
                ResourceTile(
                  color: Colors.green,
                  icon: Icons.wb_sunny,
                  label: 'Weather Planning',
                  webResources: [
                    Resource('Weather.com - Portland Weather', 'https://weather.com/weather/today/l/Portland+OR'),
                    Resource('National Weather Service - Portland', 'https://www.weather.gov/totalforecast?site=PQR'),
                    Resource('Windy - Portland Weather', 'https://www.windy.com/'),
                  ],
                ),
                ResourceTile(
                  color: Colors.orange,
                  icon: Icons.shopping_bag,
                  label: 'Find Gear',
                  webResources: [
                    Resource('REI Portland Store', 'https://www.rei.com/stores/portland'),
                    Resource('Cycle Portland', 'https://cycleportland.com/'),
                    Resource('Bike Portland', 'https://bikeportland.org/'),
                  ],
                ),
                ResourceTile(
                  color: Colors.purple,
                  icon: Icons.directions_bike,
                  label: 'Find a Bike',
                  webResources: [
                    Resource('Bike Index - Portland', 'https://bikeindex.org/'),
                    Resource('Portland Bike Rentals', 'https://www.portlandbikerentals.com/'),
                    Resource('Community Cycling Center - Bike Sales', 'https://communitycyclingcenter.org/'),
                  ],
                ),
                ResourceTile(
                  color: Colors.red,
                  icon: Icons.group,
                  label: 'Find a Crew',
                  webResources: [
                    Resource('Portland Bicycling Club', 'https://www.portlandbicyclingclub.com/'),
                    Resource('Meetup - Portland Cycling Groups', 'https://www.meetup.com/topics/cycling/us/or/portland/'),
                    Resource('Bicycle Transportation Alliance', 'https://www.btaoregon.org/'),
                  ],
                ),
                ResourceTile(
                  color: Colors.teal,
                  icon: Icons.lock,
                  label: 'Bike Storage',
                  webResources: [
                    Resource('Portland Bicycle Storage Solutions', 'https://www.portlandoregon.gov/transportation/article/477151'),
                    Resource('U-Haul Storage - Portland Locations', 'https://www.uhaul.com/Storage/'),
                    Resource('Bike Locker Program - City of Portland', 'https://www.portland.gov/transportation/bike-lockers'),
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

class Resource {
  final String title;
  final String url;

  Resource(this.title, this.url);
}

class ResourceTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final List<Resource> webResources;

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
  final List<Resource> webResources;

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
            title: Text(
              webResources[index].title,
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              webResources[index].url,
              style: TextStyle(fontSize: 12),
            ),
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
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Boolean values for settings
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  bool _isPrivacyPublic = false;

  // Slider value for bike usage
  double _bikeUsageValue = 0.5; // 0.0 for "Commuting" and 1.0 for "Recreation"

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Function to toggle between light and dark mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  // Function to toggle notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  // Function to toggle privacy settings
  void _togglePrivacy(bool value) {
    setState(() {
      _isPrivacyPublic = value;
    });
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect the data
      final name = _nameController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;
      final address = _addressController.text;
      final bikeUsage = _bikeUsageValue <= 0.5 ? 'Commuting' : 'Recreation';

      // For now, just show a dialog with the updated info
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Settings Updated'),
          content: Text(
            'Name: $name\nEmail: $email\nPhone: $phone\nAddress: $address\n'
            'Dark Mode: ${_isDarkMode ? "Enabled" : "Disabled"}\n'
            'Notifications: ${_isNotificationsEnabled ? "Enabled" : "Disabled"}\n'
            'Privacy: ${_isPrivacyPublic ? "Public" : "Private"}\n'
            'Bike Usage: $bikeUsage',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value ?? '')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              
              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              
              // Address Field
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Home Address'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              // Dark Mode Switch
              SwitchListTile(
                title: Text('Dark Mode'),
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
              
              // Notifications Switch
              SwitchListTile(
                title: Text('Enable Notifications'),
                value: _isNotificationsEnabled,
                onChanged: _toggleNotifications,
              ),
              
              // Privacy Settings Switch
              SwitchListTile(
                title: Text('Make Profile Public'),
                value: _isPrivacyPublic,
                onChanged: _togglePrivacy,
              ),

              // Bike Usage Slider
              ListTile(
                title: Text('How do you primarily use your bike?'),
                subtitle: Text(_bikeUsageValue <= 0.5 ? 'Commuting' : 'Recreation'),
              ),
              Slider(
                value: _bikeUsageValue,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: _bikeUsageValue <= 0.5 ? 'Commuting' : 'Recreation',
                onChanged: (value) {
                  setState(() {
                    _bikeUsageValue = value;
                  });
                },
                thumbColor: Colors.blue,
                activeColor: Colors.blue,
              ),

              // Submit Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

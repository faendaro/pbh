import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // For radio buttons to represent biking purpose
  String _bikingPurpose = 'commuting'; // Default value
  String _userName = ''; // Default empty value

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Function to load the user's data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Load saved values from SharedPreferences
    String userName = prefs.getString('userName') ?? ''; // Default to empty string if not found
    String bikingPurpose = prefs.getString('bikingPurpose') ?? 'commuting'; // Default value
    
    setState(() {
      _userName = userName;
      _bikingPurpose = bikingPurpose;
    });
  }

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
            'Bike Usage: $_bikingPurpose',
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
  void initState() {
    super.initState();
    _loadUserData(); // Load the user's data from SharedPreferences
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
                // Name Field - pre-filled with userName from SharedPreferences
                TextFormField(
                  controller: _nameController..text = _userName, // Set the controller's text
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
          
                // Bike Usage Radio Buttons
                ListTile(
                  title: Text('How do you primarily use your bike?'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'commuting',
                          groupValue: _bikingPurpose,
                          onChanged: (value) {
                            setState(() {
                              _bikingPurpose = value!;
                            });
                          },
                        ),
                        Text('Commuting'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'recreation',
                          groupValue: _bikingPurpose,
                          onChanged: (value) {
                            setState(() {
                              _bikingPurpose = value!;
                            });
                          },
                        ),
                        Text('Recreation'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'both',
                          groupValue: _bikingPurpose,
                          onChanged: (value) {
                            setState(() {
                              _bikingPurpose = value!;
                            });
                          },
                        ),
                        Text('Both'),
                      ],
                    ),
                  ],
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
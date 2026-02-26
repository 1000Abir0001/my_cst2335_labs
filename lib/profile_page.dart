import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_repository.dart';

//
// LAB 5: profile page ->2nd page
//
class ProfilePage extends StatefulWidget {
  final String loginName;
  final ProfileRepository repository;

  const ProfilePage({super.key, required this.loginName, required this.repository});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // LAB 5: TextFields
  late final TextEditingController _firstController;
  late final TextEditingController _lastController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    //  loading data into the TextFields
    _firstController = TextEditingController(text: widget.repository.firstName);
    _lastController = TextEditingController(text: widget.repository.lastName);
    _phoneController = TextEditingController(text: widget.repository.phone);
    _emailController = TextEditingController(text: widget.repository.email);

    // LAB 5: addListener() to save data whenever text change
    _firstController.addListener(() => widget.repository.saveData('firstName', _firstController.text));
    _lastController.addListener(() => widget.repository.saveData('lastName', _lastController.text));
    _phoneController.addListener(() => widget.repository.saveData('phone', _phoneController.text));
    _emailController.addListener(() => widget.repository.saveData('email', _emailController.text));
  }

  // helper function to launch URLs and show AlertDialog if not supported
  Future<void> _launch(String scheme, String path) async {
    final Uri uri = Uri(scheme: scheme, path: path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text("URL is not supported on this device."),
          ),
        );
      }
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Profile Page")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // LAB 5: text widget saying "Welcome Back" followed by login name
          Text(
            "Welcome Back ${widget.loginName}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // first name
          TextField(
            controller: _firstController,
            decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          // last name
          TextField(
            controller: _lastController,
            decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          // LAB 5: phone number row with Flexible widget
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () => _launch('tel', _phoneController.text),
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () => _launch('sms', _phoneController.text),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // LAB 5: Email Address Row with Flexible widget
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email address', border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mail),
                onPressed: () => _launch('mailto', _emailController.text),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}
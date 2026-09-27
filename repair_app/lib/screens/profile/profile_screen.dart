import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../shop/create_shop_screen.dart'; // Import the create shop screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: authProvider.isAuthenticated && user != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text(user.email, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  Text(user.phone, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  
                  // Show Shop details if they have a shop, otherwise show Create Shop button
                  if (user.shop != null) ...[
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.store, color: Colors.blueAccent),
                        title: Text(user.shop!.name),
                        subtitle: Text(user.shop!.address),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreateShopScreen()),
                        );
                      },
                      icon: const Icon(Icons.store),
                      label: const Text('Create My Shop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  ElevatedButton.icon(
                    onPressed: () async {
                      await authProvider.logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are not logged in'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
    );
  }
}
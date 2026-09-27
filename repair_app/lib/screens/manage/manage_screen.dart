import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'create_shop_screen.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Shop & Product Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildBody(context, authProvider, user),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthProvider authProvider, dynamic user) {
    // 1. Guest User State
    if (!authProvider.isAuthenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Login Required',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please login or register to create and manage your shop or sell spare parts.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              child: const Text('Login / Register'),
            ),
          ],
        ),
      );
    }

    // 2. Logged-in User without a Shop
    if (user?.shop == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.storefront, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text(
              'You don\'t have a shop yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Open your own car or motor repair shop to start selling parts today!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateShopScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Shop'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }

    // 3. Shop Owner Dashboard
    final shop = user!.shop!;
    return ListView(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(shop.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () {
                        // TODO: Implement Edit Shop Screen
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('📍 ${shop.address}'),
                Text('📞 ${shop.phone}'),
                const SizedBox(height: 8),
                if (shop.description != null) Text(shop.description!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Manage Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement Create Product Screen
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Add Spare Part Product'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
        ),
      ],
    );
  }
}
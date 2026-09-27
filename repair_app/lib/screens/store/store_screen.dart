import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import 'product_detail_screen.dart';
import '../manage/shop_form_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String _searchQuery = '';
  String _selectedVehicle = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final filteredProducts = productProvider.products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (product.shop?.name.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesVehicle = _selectedVehicle == 'All' || product.vehicleType.toLowerCase() == _selectedVehicle.toLowerCase();
      return matchesSearch && matchesVehicle;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spare Parts Store'),
        actions: [
          // If logged in and has a shop, let them add products or manage shop here
          if (authProvider.isAuthenticated && user != null)
            IconButton(
              icon: const Icon(Icons.store),
              tooltip: 'Manage Shop',
              onPressed: () {
                if (user.shop == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ShopFormScreen()),
                  );
                } else {
                  // Navigate to your shop management or product addition screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You already have a shop registered!')),
                  );
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search spare parts or shops...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['All', 'Car', 'Motor'].map((type) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(type),
                  selected: _selectedVehicle == type,
                  onSelected: (selected) => setState(() => _selectedVehicle = type),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? const Center(child: Text('No spare parts found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      ),
                                      child: const Center(child: Icon(Icons.build, size: 40, color: Colors.grey)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                                        Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.blueAccent)),
                                        Text('Stock: ${product.stock}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/shop.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import 'product_form_screen.dart';
import 'shop_form_screen.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    Widget body;
    if (!authProvider.isAuthenticated) {
      body = _buildGuest(context);
    } else if (user?.shop == null) {
      body = _buildNoShop(context);
    } else {
      body = _buildDashboard(context, user!.shop!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shop & Product Management')),
      body: Padding(padding: const EdgeInsets.all(16.0), child: body),
    );
  }

  // 1. Guest User State
  Widget _buildGuest(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Login Required', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Please register or login to create and manage your shop or sell products.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: OutlinedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              child: const Text('Register'),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Logged-in User without a Shop
  Widget _buildNoShop(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.storefront, size: 64, color: Colors.blueAccent),
          const SizedBox(height: 16),
          const Text("You don't have a shop yet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Open your own car or motor repair shop to start selling parts today!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopFormScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Create Shop'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  // 3. Shop Owner Dashboard
  Widget _buildDashboard(BuildContext context, Shop shop) {
    final productProvider = Provider.of<ProductProvider>(context);
    final myProducts = productProvider.productsForShop(shop.id);

    return RefreshIndicator(
      onRefresh: () => productProvider.fetchProducts(),
      child: ListView(
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
                    children: [
                      Expanded(
                        child: Text(shop.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        tooltip: 'Edit Shop',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ShopFormScreen(shop: shop)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('📍 ${shop.address}'),
                  Text('📞 ${shop.phone}'),
                  if (shop.description != null && shop.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(shop.description!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'My Products (${myProducts.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductFormScreen())),
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (productProvider.isLoading && myProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (productProvider.loadError != null && myProducts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(productProvider.loadError!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            )
          else if (myProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No products yet. Tap "Add Product" to start selling spare parts.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...myProducts.map((product) => _buildProductTile(context, product)),
        ],
      ),
    );
  }

  Widget _buildProductTile(BuildContext context, Product product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(
            product.vehicleType.toLowerCase() == 'motor' ? Icons.two_wheeler : Icons.directions_car,
            color: Colors.blueAccent,
          ),
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('\$${product.price.toStringAsFixed(2)} · Stock: ${product.stock} · ${product.category}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              tooltip: 'Edit',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context, product),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product?'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final error = await Provider.of<ProductProvider>(context, listen: false).deleteProduct(product.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Product deleted'),
        backgroundColor: error != null ? Colors.red : null,
      ),
    );
  }
}

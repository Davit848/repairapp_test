import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/shop.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shop_provider.dart';
import '../../services/location_service.dart';
import '../../utils/validators.dart';

// Create a new shop, or edit an existing one when [shop] is given.
class ShopFormScreen extends StatefulWidget {
  final Shop? shop;
  const ShopFormScreen({super.key, this.shop});

  bool get isEditing => shop != null;

  @override
  State<ShopFormScreen> createState() => _ShopFormScreenState();
}

class _ShopFormScreenState extends State<ShopFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _descriptionController;

  double? _latitude;
  double? _longitude;
  String? _address;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final shop = widget.shop;
    _nameController = TextEditingController(text: shop?.name);
    _phoneController = TextEditingController(text: shop?.phone);
    _descriptionController = TextEditingController(text: shop?.description);
    _latitude = shop?.latitude;
    _longitude = shop?.longitude;
    _address = shop?.address;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : null),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final position = await LocationService.getCurrentPosition();
      final address = await LocationService.addressFromCoordinates(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _address = address;
      });
    } on LocationException catch (e) {
      if (mounted) _showMessage(e.message, isError: true);
    } catch (e) {
      debugPrint('Location Error: $e');
      if (mounted) _showMessage('Could not get your location. Please try again.', isError: true);
    }
    if (mounted) setState(() => _isLoadingLocation = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_latitude == null || _longitude == null || _address == null) {
      _showMessage('Please select your real shop location using GPS', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    final data = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'description': _descriptionController.text.trim(),
      'latitude': _latitude,
      'longitude': _longitude,
      'address': _address,
    };

    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final error = widget.isEditing
        ? await shopProvider.updateShop(widget.shop!.id, data)
        : await shopProvider.createShop(data);

    if (error == null) {
      // Refresh user profile so the shop shows immediately (no re-login needed)
      await authProvider.fetchUserProfile();
      if (!mounted) return;
      _showMessage(widget.isEditing ? 'Shop updated successfully!' : 'Shop created successfully!');
      Navigator.pop(context);
      return;
    }

    if (!mounted) return;
    _showMessage(error, isError: true);
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Shop' : 'Create Your Shop')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Shop / Garage Name', border: OutlineInputBorder()),
                validator: (value) => Validators.required(value, 'a shop name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => Validators.required(value, 'a description'),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Shop Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_address ?? 'No location selected yet'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: Text(_isLoadingLocation
                          ? 'Fetching GPS...'
                          : (_latitude == null ? 'Select Real GPS Location' : 'Update to Current Location')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                      child: Text(widget.isEditing ? 'Save Changes' : 'Create Shop'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

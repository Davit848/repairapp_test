import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_provider.dart';
import '../../models/shop.dart';
import '../../services/location_service.dart';

// google_maps_flutter only supports Android, iOS and Web (not Windows/macOS/Linux desktop)
bool get _isMapSupported =>
    kIsWeb || defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(11.5564, 104.9282); // Default fallback (Phnom Penh)
  bool _hasLocation = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).fetchShops();
    });
  }

  Future<void> _determinePosition() async {
    if (!_isMapSupported) return;

    final Position position;
    try {
      position = await LocationService.getCurrentPosition();
    } catch (e) {
      debugPrint('Map Location Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is LocationException ? e.message : 'Could not get your location.')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _hasLocation = true;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition, 14),
    );
  }

  void _showShopDetails(Shop shop) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shop.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('📍 ${shop.address}'),
              Text('📞 ${shop.phone}'),
              const SizedBox(height: 12),
              if (shop.description != null) Text(shop.description!),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                      child: const Text('View Shop Details'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMapSupported) return _buildUnsupported();

    final shopProvider = Provider.of<ShopProvider>(context);

    Set<Marker> markers = shopProvider.shops.map((shop) {
      return Marker(
        markerId: MarkerId(shop.id.toString()),
        position: LatLng(shop.latitude, shop.longitude),
        infoWindow: InfoWindow(title: shop.name, snippet: shop.address),
        onTap: () => _showShopDetails(shop),
      );
    }).toSet();

    if (_hasLocation) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    }

    return Scaffold(
      body: shopProvider.isLoading && shopProvider.shops.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14,
              ),
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) => _mapController = controller,
            ),
    );
  }

  Widget _buildUnsupported() {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Map is not available on desktop', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                'Google Maps works on Android, iPhone and Chrome.\nRun the app on an Android emulator/phone or in Chrome to see the map.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
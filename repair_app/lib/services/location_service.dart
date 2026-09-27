import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// Thrown with a message that can be shown directly to the user
class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}

class LocationService {
  // Asks for permission if needed, then returns the device's real GPS position.
  static Future<Position> getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationException('GPS is turned off. Please enable location services.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw LocationException('Location permission denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationException('Location permission is blocked. Please allow it in your phone settings.');
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Converts coordinates to a readable address; falls back to the coordinates.
  static Future<String> addressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [place.street, place.subLocality, place.locality, place.country]
            .where((part) => part != null && part.trim().isNotEmpty)
            .toList();
        if (parts.isNotEmpty) return parts.join(', ');
      }
    } catch (_) {}
    return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
  }

  // Straight-line distance in kilometres between two coordinates.
  static double distanceInKm(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
  }
}

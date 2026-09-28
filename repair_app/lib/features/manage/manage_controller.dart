import 'package:flutter/foundation.dart';

import '../../data/static_data.dart';

/// In-memory state for the provider portal, seeded from [StaticData].
///
/// All mutations are local; swap the bodies for API calls when the
/// Laravel endpoints are wired in.
class ManageController extends ChangeNotifier {
  ManageController() : _inventory = [...StaticData.ownerInventory], _services = [...StaticData.ownerServices];

  final List<SparePart> _inventory;
  final List<MechanicService> _services;
  bool _acceptingCallouts = true;
  int _nextId = 0;

  static const calloutRadiusKm = 15;

  List<SparePart> get inventory => List.unmodifiable(_inventory);
  List<MechanicService> get services => List.unmodifiable(_services);
  bool get acceptingCallouts => _acceptingCallouts;
  int get activeServiceCount => _services.where((s) => s.isActive).length;

  String newId(String prefix) => '$prefix-new-${_nextId++}';

  // ---------------------------------------------------------- Inventory

  void adjustStock(String id, int delta) {
    _updatePart(id, (part) => part.copyWith(stock: (part.stock + delta).clamp(0, 9999)));
  }

  void savePart(SparePart part) {
    final index = _inventory.indexWhere((p) => p.id == part.id);
    if (index == -1) {
      _inventory.insert(0, part);
    } else {
      _inventory[index] = part;
    }
    notifyListeners();
  }

  void removePart(String id) {
    _inventory.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void _updatePart(String id, SparePart Function(SparePart) update) {
    final index = _inventory.indexWhere((p) => p.id == id);
    if (index == -1) return;
    _inventory[index] = update(_inventory[index]);
    notifyListeners();
  }

  // ----------------------------------------------------------- Services

  void setAcceptingCallouts(bool value) {
    _acceptingCallouts = value;
    notifyListeners();
  }

  void toggleService(String id) {
    final index = _services.indexWhere((s) => s.id == id);
    if (index == -1) return;
    _services[index] = _services[index].copyWith(isActive: !_services[index].isActive);
    notifyListeners();
  }

  void addService(MechanicService service) {
    _services.add(service);
    notifyListeners();
  }

  void removeService(String id) {
    _services.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}

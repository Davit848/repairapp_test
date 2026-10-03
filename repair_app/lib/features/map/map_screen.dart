import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/feedback.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/pill_selector.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/static_data.dart';
import 'widgets/map_markers.dart';
import 'widgets/shop_preview_card.dart';

/// Page 1 — GPS discovery hub with categorized garage pins.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.onViewShop});

  final VoidCallback onViewShop;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  ShopType? _filter;
  String _query = '';
  Shop? _selected = StaticData.abcGarage;
  _MapLayer _layer = _MapLayer.standard;
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  List<Shop> get _visibleShops {
    final query = _query.trim().toLowerCase();
    return StaticData.shops.where((shop) {
      final matchesType = _filter == null || shop.types.contains(_filter);
      final matchesQuery = query.isEmpty || shop.name.toLowerCase().contains(query);
      return matchesType && matchesQuery;
    }).toList();
  }

  void _applyFilter(ShopType? type) {
    setState(() {
      _filter = type;
      if (_selected != null && !_visibleShops.contains(_selected)) _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(subtitle: 'GPS Map'),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          const Padding(padding: AppSpacing.screen, child: _LocationBar()),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: AppSpacing.screen,
            child: SearchField(
              hint: 'Search garages, parts, or services…',
              onChanged: (value) => setState(() => _query = value),
              trailing: IconButton(
                tooltip: 'Voice search',
                icon: const Icon(Icons.mic_none, color: AppColors.slate),
                onPressed: () => context.showFeedback('Voice search is coming soon'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          PillSelector<ShopType?>(
            selected: _filter,
            onSelected: _applyFilter,
            options: [
              const PillOption(null, 'All'),
              for (final type in ShopType.values) PillOption(type, type.label, icon: type.icon),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildMap()),
        ],
      ),
    );
  }

  void _selectShop(Shop shop) {
    setState(() => _selected = shop);
    _mapController.fitCamera(_fitTo([StaticData.userLocation, shop.location]));
  }

  void _toggleLayer() {
    setState(() => _layer = _layer == _MapLayer.standard ? _MapLayer.humanitarian : _MapLayer.standard);
    context.showFeedback('${_layer.label} map');
  }

  /// Frames [points], keeping them clear of the controls and the preview card.
  static CameraFit _fitTo(List<LatLng> points) => CameraFit.coordinates(
    coordinates: points,
    padding: const EdgeInsets.fromLTRB(90, 110, 90, 260),
    maxZoom: 17,
  );

  Widget _buildMap() {
    final selected = _selected;
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCameraFit: _fitTo([StaticData.userLocation, for (final shop in StaticData.shops) shop.location]),
            minZoom: 4,
            maxZoom: 19,
            onTap: (_, _) => setState(() => _selected = null),
          ),
          children: [
            TileLayer(
              urlTemplate: _layer.urlTemplate,
              userAgentPackageName: 'com.example.repair_app',
              maxNativeZoom: 19,
            ),
            if (selected != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [StaticData.userLocation, selected.location],
                    color: AppColors.blue,
                    strokeWidth: 4,
                    strokeCap: StrokeCap.round,
                    pattern: StrokePattern.dashed(segments: const [7, 5]),
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                // Box is twice the dot's offset from the bottom so the GPS dot sits on the point.
                const Marker(
                  point: StaticData.userLocation,
                  width: 60,
                  height: 88,
                  child: Align(alignment: Alignment.bottomCenter, child: UserMarker()),
                ),
                for (final shop in _visibleShops)
                  Marker(
                    point: shop.location,
                    width: 280,
                    height: 112,
                    alignment: Alignment.topCenter,
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      alignment: Alignment.bottomCenter,
                      child: ShopMarker(shop: shop, isSelected: shop == selected, onTap: () => _selectShop(shop)),
                    ),
                  ),
              ],
            ),
          ],
        ),
        // Required by the OSM tile usage policy.
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            color: AppColors.card.withValues(alpha: 0.85),
            child: Text('© OpenStreetMap contributors', style: AppTextStyles.labelSm.copyWith(color: AppColors.slate)),
          ),
        ),
        Positioned(
          top: 12,
          right: AppSpacing.md,
          child: _MapControls(
            onCompassReset: () => _mapController.rotate(0),
            onToggleLayer: _toggleLayer,
            onRecenter: () => _mapController.move(StaticData.userLocation, 16),
          ),
        ),
        if (selected != null)
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md + 24,
            child: ShopPreviewCard(shop: selected, onViewShop: widget.onViewShop),
          ),
      ],
    );
  }
}

enum _MapLayer {
  standard('Standard', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
  humanitarian('Humanitarian', 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png');

  const _MapLayer(this.label, this.urlTemplate);

  final String label;
  final String urlTemplate;
}

class _LocationBar extends StatelessWidget {
  const _LocationBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: AppDecorations.card.copyWith(borderRadius: AppRadius.lg),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: AppColors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CURRENT LOCATION', style: AppTextStyles.labelSm.copyWith(color: AppColors.steel)),
                Text(StaticData.currentLocation, style: AppTextStyles.titleMd),
              ],
            ),
          ),
          const StatusBadge(label: 'GPS Active', tone: BadgeTone.info, dotColor: AppColors.amber),
        ],
      ),
    );
  }
}

class _MapControls extends StatelessWidget {
  const _MapControls({required this.onCompassReset, required this.onToggleLayer, required this.onRecenter});

  final VoidCallback onCompassReset;
  final VoidCallback onToggleLayer;
  final VoidCallback onRecenter;

  @override
  Widget build(BuildContext context) {
    Widget control(IconData icon, String label, VoidCallback onPressed) => Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: const BoxDecoration(color: AppColors.card, borderRadius: AppRadius.lg, boxShadow: AppShadows.level2),
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.amberDeep),
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      ),
    );

    return Column(
      children: [
        control(Icons.explore_outlined, 'Compass reset', onCompassReset),
        control(Icons.layers_outlined, 'Map layers', onToggleLayer),
        control(Icons.near_me_outlined, 'Recenter on my location', onRecenter),
      ],
    );
  }
}

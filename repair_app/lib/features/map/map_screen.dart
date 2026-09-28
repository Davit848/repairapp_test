import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/feedback.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/pill_selector.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/street_map_painter.dart';
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

  Widget _buildMap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep pins clear of the preview card docked at the bottom.
        const cardReserve = 230.0;
        final viewport = Rect.fromLTWH(
          0,
          8,
          constraints.maxWidth,
          (constraints.maxHeight - cardReserve).clamp(160, double.infinity),
        );
        Offset toCanvas(Offset n) =>
            Offset(viewport.left + n.dx * viewport.width, viewport.top + n.dy * viewport.height);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _selected = null),
                child: CustomPaint(
                  painter: StreetMapPainter(
                    viewport: viewport,
                    routeFrom: StaticData.userMapPosition,
                    routeTo: _selected?.mapPosition,
                  ),
                ),
              ),
            ),
            _anchored(toCanvas(StaticData.userMapPosition), const UserMarker(), dy: -0.6),
            for (final shop in _visibleShops)
              _anchored(
                toCanvas(shop.mapPosition),
                ShopMarker(shop: shop, isSelected: shop == _selected, onTap: () => setState(() => _selected = shop)),
              ),
            const Positioned(top: 12, right: AppSpacing.md, child: _MapControls()),
            if (_selected != null)
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: ShopPreviewCard(shop: _selected!, onViewShop: widget.onViewShop),
              ),
          ],
        );
      },
    );
  }

  /// Places [child] so its bottom-center sits on [point].
  Widget _anchored(Offset point, Widget child, {double dy = -1}) {
    return Positioned(
      left: point.dx,
      top: point.dy,
      child: FractionalTranslation(translation: Offset(-0.5, dy), child: child),
    );
  }
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
  const _MapControls();

  @override
  Widget build(BuildContext context) {
    Widget control(IconData icon, String label) => Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: const BoxDecoration(color: AppColors.card, borderRadius: AppRadius.lg, boxShadow: AppShadows.level2),
      child: IconButton(
        tooltip: label,
        onPressed: () => context.showFeedback(label),
        icon: Icon(icon, color: AppColors.amberDeep),
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      ),
    );

    return Column(
      children: [
        control(Icons.explore_outlined, 'Compass reset'),
        control(Icons.layers_outlined, 'Map layers'),
        control(Icons.near_me_outlined, 'Recenter on my location'),
      ],
    );
  }
}

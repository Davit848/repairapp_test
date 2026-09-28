import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/feedback.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/street_map_painter.dart';
import '../../../data/static_data.dart';
import '../manage_controller.dart';
import 'inventory_tile.dart';
import 'product_form_sheet.dart';

/// "Parts & Items" mode: shop overview, GPS pin and inventory CRUD.
class PartsView extends StatefulWidget {
  const PartsView({super.key, required this.controller, required this.owner});

  final ManageController controller;
  final OwnerProfile owner;

  @override
  State<PartsView> createState() => _PartsViewState();
}

class _PartsViewState extends State<PartsView> {
  String _query = '';

  ManageController get _controller => widget.controller;

  Future<void> _openForm([SparePart? part]) async {
    final saved = await ProductFormSheet.show(context, id: part?.id ?? _controller.newId('m'), initial: part);
    if (saved == null || !mounted) return;
    _controller.savePart(saved);
    context.showFeedback(part == null ? '${saved.name} is now live' : 'Saved ${saved.name}');
  }

  Future<void> _delete(SparePart part) async {
    final confirmed = await confirmAction(
      context,
      title: 'Remove product?',
      message: '${part.name} will be removed from your live catalog.',
    );
    if (confirmed) _controller.removePart(part.id);
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final items = _controller.inventory.where((p) => p.name.toLowerCase().contains(query)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OverviewCard(owner: widget.owner, onAddProduct: _openForm),
        const SizedBox(height: AppSpacing.md),
        _GpsCard(shop: widget.owner.shop),
        const SizedBox(height: AppSpacing.md),
        const _DiscoverabilityNote(),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(
          title: 'Shop Inventory',
          badge: StatusBadge(label: '${_controller.inventory.length} Active', tone: BadgeTone.warning),
          trailing: IconButton(
            tooltip: 'Filter',
            icon: const Icon(Icons.filter_list),
            onPressed: () => context.showFeedback('Inventory filters are coming soon'),
          ),
        ),
        const SizedBox(height: 12),
        SearchField(hint: 'Search in my shop stock…', onChanged: (value) => setState(() => _query = value)),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              'No products found.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.textMuted),
            ),
          ),
        for (final part in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InventoryTile(
              part: part,
              onAdjust: (delta) => _controller.adjustStock(part.id, delta),
              onEdit: () => _openForm(part),
              onDelete: () => _delete(part),
            ),
          ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.owner, required this.onAddProduct});

  final OwnerProfile owner;
  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    final stats = owner.stats;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatusBadge(
            label: 'GPS Live Map Verified',
            tone: BadgeTone.warning,
            icon: Icons.verified_outlined,
            uppercase: true,
          ),
          const SizedBox(height: 8),
          Text(
            'Owner ID: ${owner.ownerCode} • Motorcycle & Auto Spares',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.lg),
            child: Row(
              children: [
                Expanded(
                  child: StatTile(value: '${stats.productsListed}', label: 'Products Listed'),
                ),
                Expanded(
                  child: StatTile(value: '${stats.mapViewsToday}', label: 'Map Views Today', highlight: true),
                ),
                Expanded(
                  child: StatTile(value: '${stats.inquiries}', label: 'Direct Inquiries'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Add New Product to Live Catalog',
            icon: Icons.add_circle_outline,
            height: 54,
            expand: true,
            onPressed: onAddProduct,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Edit Shop Info',
                  icon: Icons.edit_note,
                  variant: AppButtonVariant.tonal,
                  onPressed: () => context.showFeedback('Shop editor is coming soon'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'View on Map',
                  icon: Icons.explore_outlined,
                  variant: AppButtonVariant.tonal,
                  onPressed: () => context.showFeedback('Your shop is pinned on the Map tab'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GpsCard extends StatelessWidget {
  const _GpsCard({required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.amberDeep),
              const SizedBox(width: 8),
              Expanded(child: Text('Shop GPS Coordinates', style: AppTextStyles.titleMd)),
              const StatusBadge(label: 'Real-Time Signal'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: AppColors.surfaceLow, borderRadius: AppRadius.lg),
            child: Row(
              children: [
                const Icon(Icons.storefront_outlined, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shop.address, style: AppTextStyles.labelLg, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(
                        'Lat: ${shop.latitude} • Long: ${shop.longitude}',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.textMuted,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: AppRadius.lg,
            child: SizedBox(
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CustomPaint(painter: StreetMapPainter(showLabels: false)),
                  const Center(child: Icon(Icons.location_on, size: 40, color: AppColors.amber)),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: StatusBadge(
                      label: 'Accuracy: within 4 meters',
                      tone: BadgeTone.light,
                      icon: Icons.gps_fixed,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Update Shop Location on Map',
            icon: Icons.edit_location_alt_outlined,
            variant: AppButtonVariant.tonal,
            onPressed: () => context.showFeedback('GPS pin recalibrated'),
          ),
        ],
      ),
    );
  }
}

class _DiscoverabilityNote extends StatelessWidget {
  const _DiscoverabilityNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: AppColors.surfaceMid, borderRadius: AppRadius.lg),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: AppColors.amber),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Adding a product makes it ',
                children: [
                  TextSpan(
                    text: 'immediately discoverable',
                    style: AppTextStyles.labelMd.copyWith(color: AppColors.amberDeep),
                  ),
                  const TextSpan(
                    text:
                        ' to drivers and riders stranded within '
                        '${ManageController.calloutRadiusKm} km of your garage.',
                  ),
                ],
              ),
              style: AppTextStyles.bodySm,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/utils/feedback.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/pill_selector.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/segmented_toggle.dart';
import '../../data/static_data.dart';
import 'widgets/part_card.dart';
import 'widgets/part_details_sheet.dart';

/// Page 3 — spare parts catalog from verified local workshops.
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  VehicleType? _vehicle;
  PartCategory? _category;
  String _query = '';
  final Set<String> _saved = {};

  List<SparePart> get _results {
    final query = _query.trim().toLowerCase();
    return StaticData.parts.where((part) {
      final matchesVehicle =
          _vehicle == null || part.vehicleType == _vehicle || part.vehicleType == VehicleType.universal;
      final matchesCategory = _category == null || part.category == _category;
      final matchesQuery =
          query.isEmpty || part.name.toLowerCase().contains(query) || part.fitment.toLowerCase().contains(query);
      return matchesVehicle && matchesCategory && matchesQuery;
    }).toList();
  }

  void _contact(SparePart part) => context.showFeedback('Calling ${part.shop.shortName} · ${part.shop.phone}');

  void _toggleSaved(SparePart part) {
    setState(() => _saved.contains(part.id) ? _saved.remove(part.id) : _saved.add(part.id));
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: const AppHeader(subtitle: 'Parts Store'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildFilters()),
          if (results.isEmpty)
            const SliverFillRemaining(hasScrollBody: false, child: _EmptyResults())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid.builder(
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisExtent: 352,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final part = results[index];
                  return PartCard(
                    part: part,
                    isSaved: _saved.contains(part.id),
                    onToggleSaved: () => _toggleSaved(part),
                    onContact: () => _contact(part),
                    onDetails: () => PartDetailsSheet.show(context, part: part, onContact: () => _contact(part)),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.md),
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.screen,
            child: SearchField(
              hint: 'Search spare parts (e.g. Brake pad)',
              onChanged: (value) => setState(() => _query = value),
              trailing: AppIconButton(
                icon: Icons.qr_code_scanner,
                tooltip: 'Scan barcode',
                variant: AppButtonVariant.dark,
                size: 40,
                onPressed: () => context.showFeedback('Barcode scanner is coming soon'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: AppSpacing.screen,
            child: SegmentedToggle<VehicleType?>(
              selected: _vehicle,
              onSelected: (value) => setState(() => _vehicle = value),
              options: [
                const PillOption(null, 'All Vehicles'),
                PillOption(VehicleType.motorcycle, 'Motorcycle', icon: VehicleType.motorcycle.icon),
                PillOption(VehicleType.car, 'Car', icon: VehicleType.car.icon),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PillSelector<PartCategory?>(
            selected: _category,
            onSelected: (value) => setState(() => _category = value),
            activeColor: AppColors.amberDeep,
            uppercase: true,
            options: [
              const PillOption(null, 'All Parts'),
              for (final category in PartCategory.values) PillOption(category, category.label),
            ],
          ),
          const SizedBox(height: 12),
          const Padding(padding: AppSpacing.screen, child: _NetworkBanner()),
        ],
      ),
    );
  }
}

class _NetworkBanner extends StatelessWidget {
  const _NetworkBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.surfaceHigh),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: AppColors.amber, borderRadius: AppRadius.md),
            child: const Icon(Icons.verified_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AUTHORIZED NETWORK', style: AppTextStyles.labelSm.copyWith(color: AppColors.amberDeep)),
                Text('Direct from local verified workshops • Live inventory', style: AppTextStyles.bodySm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: AppColors.steel),
          const SizedBox(height: 12),
          Text('No parts match your filters', style: AppTextStyles.titleMd),
          const SizedBox(height: 4),
          Text(
            'Try another category or vehicle type.',
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

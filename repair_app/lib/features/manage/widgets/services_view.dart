import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/dialogs.dart';
import '../../../core/utils/feedback.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/static_data.dart';
import '../manage_controller.dart';
import 'owner_service_tile.dart';
import 'quick_add_service_form.dart';

/// "Services" mode: callout availability and labor catalog CRUD.
class ServicesView extends StatefulWidget {
  const ServicesView({super.key, required this.controller, required this.owner});

  final ManageController controller;
  final OwnerProfile owner;

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  final _formKey = GlobalKey();

  ManageController get _controller => widget.controller;

  void _scrollToForm() {
    final formContext = _formKey.currentContext;
    if (formContext != null) {
      Scrollable.ensureVisible(formContext, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  Future<void> _delete(MechanicService service) async {
    final confirmed = await confirmAction(
      context,
      title: 'Delete service?',
      message: '${service.title} will no longer be bookable by motorists.',
    );
    if (confirmed) _controller.removeService(service.id);
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.owner.stats;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Catalog',
                icon: Icons.fact_check_outlined,
                value: '${_controller.activeServiceCount}',
                caption: 'Live Services',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                label: 'Jobs',
                icon: Icons.calendar_month_outlined,
                value: '${stats.jobsThisWeek}',
                caption: 'This Week',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                label: 'Revenue',
                icon: Icons.payments_outlined,
                value: '\$${stats.laborRevenue.toStringAsFixed(0)}',
                caption: 'Labor Gross',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _CalloutSwitch(value: _controller.acceptingCallouts, onChanged: _controller.setAcceptingCallouts),
        const SizedBox(height: 12),
        AppButton(
          label: 'Add New Mechanic Service',
          icon: Icons.add_circle_outline,
          height: 54,
          expand: true,
          onPressed: _scrollToForm,
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(
          title: 'Active Services',
          subtitle: 'Live booking catalog for motorists',
          trailing: TextButton.icon(
            onPressed: () => context.showFeedback('Service filters are coming soon'),
            icon: const Icon(Icons.tune, size: 16),
            label: const Text('Filter'),
          ),
        ),
        const SizedBox(height: 12),
        for (final service in _controller.services)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OwnerServiceTile(
              service: service,
              onEdit: () => context.showFeedback('Editing "${service.title}" is coming soon'),
              onToggle: () => _controller.toggleService(service.id),
              onDelete: () => _delete(service),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        QuickAddServiceForm(
          key: _formKey,
          newId: () => _controller.newId('o'),
          onPublish: (service) {
            _controller.addService(service);
            context.showFeedback('${service.title} is now live');
          },
          onSaveDraft: (service) {
            _controller.addService(service);
            context.showFeedback('${service.title} saved as paused draft');
          },
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.icon, required this.value, required this.caption});

  final String label;
  final IconData icon;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppDecorations.card.copyWith(borderRadius: AppRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: AppTextStyles.labelMd.copyWith(color: AppColors.textMuted)),
              ),
              Icon(icon, size: 16, color: AppColors.amber),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.headlineMd),
          Text(caption, style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _CalloutSwitch extends StatelessWidget {
  const _CalloutSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: AppColors.surfaceMid, borderRadius: AppRadius.lg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AppColors.card, borderRadius: AppRadius.md),
            child: const Icon(Icons.location_on_outlined, color: AppColors.amberDeep),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Accepting Callouts', style: AppTextStyles.titleMd),
                Text(
                  value
                      ? 'In-Shop & Mobile (${ManageController.calloutRadiusKm} km radius)'
                      : 'Paused — motorists cannot dispatch you',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

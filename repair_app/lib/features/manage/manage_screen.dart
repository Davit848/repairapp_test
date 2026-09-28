import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/widgets/app_header.dart';
import '../../data/static_data.dart';
import 'manage_controller.dart';
import 'widgets/parts_view.dart';
import 'widgets/services_view.dart';
import 'widgets/shop_identity_card.dart';

/// Page 4 — seller & provider portal for stock and labor services.
class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final _controller = ManageController();
  ManageMode _mode = ManageMode.parts;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const owner = StaticData.owner;
    return Scaffold(
      appBar: AppHeader(subtitle: _mode == ManageMode.parts ? 'Vehicle Management' : 'Service Hub'),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            ShopIdentityCard(
              owner: owner,
              mode: _mode,
              activeServices: _controller.activeServiceCount,
              onModeChanged: (mode) => setState(() => _mode = mode),
            ),
            const SizedBox(height: AppSpacing.md),
            switch (_mode) {
              ManageMode.parts => PartsView(controller: _controller, owner: owner),
              ManageMode.services => ServicesView(controller: _controller, owner: owner),
            },
          ],
        ),
      ),
    );
  }
}

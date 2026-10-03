import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/main_shell.dart';

void main() => runApp(const RepairApp());

class RepairApp extends StatelessWidget {
  const RepairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repair',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainShell(),
    );
  }
}

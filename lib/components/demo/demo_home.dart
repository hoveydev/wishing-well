import 'package:flutter/material.dart';
import 'package:wishing_well/components/demo/component_registrations.dart';
import 'package:wishing_well/components/demo/component_registry.dart';
import 'package:wishing_well/theme/app_spacer_size.dart';

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  late List<DemoMetadata> _demos;

  @override
  void initState() {
    super.initState();
    _initializeDemos();
  }

  void _initializeDemos() {
    // Register all demos and verify completeness
    // This will throw if any component is missing a demo
    registerAllDemos();

    // Get all registered demos and create a modifiable copy
    _demos = List<DemoMetadata>.from(ComponentDemoRegistry.getAllDemos());

    // Sort demos alphabetically by title for consistent ordering
    _demos.sort((a, b) => a.title.compareTo(b.title));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Component Demo App'),
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      actions: [
        Icon(Icons.developer_mode, color: Colors.red[700]),
        const SizedBox(width: AppSpacerSize.small),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(AppSpacerSize.large),
      children: [
        _buildHeader(),
        const SizedBox(height: AppSpacerSize.xxlarge),
        ..._demos.map((demo) => _buildDemoTile(context, demo)),
      ],
    ),
  );

  Widget _buildHeader() => Column(
    children: [
      const Text(
        '🚨 DEVELOPER DEMO ONLY 🚨',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: AppSpacerSize.small),
      const Text(
        'This app is for component testing and development only.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: AppSpacerSize.medium),
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacerSize.large,
          vertical: AppSpacerSize.small,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.blue[700], size: 20),
            const SizedBox(width: AppSpacerSize.small),
            Text(
              'All ${_demos.length} components have demos registered',
              style: TextStyle(color: Colors.blue[700], fontSize: 14),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _buildDemoTile(BuildContext context, DemoMetadata demo) => Card(
    margin: const EdgeInsets.only(bottom: AppSpacerSize.small),
    child: ListTile(
      leading: Icon(demo.icon, size: 32),
      title: Text(
        demo.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: demo.description != null
          ? Text(
              demo.description!,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _navigateToDemo(context, demo),
    ),
  );

  void _navigateToDemo(BuildContext context, DemoMetadata demo) {
    Navigator.push(context, MaterialPageRoute(builder: demo.builder));
  }
}

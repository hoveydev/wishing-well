import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';

/// Demo-only success screen shown after successful login simulation.
///
/// This screen replaces the home screen in the demo since the full
/// app navigation isn't available.
class DemoSuccessScreen extends StatelessWidget {
  const DemoSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Login Successful'),
      automaticallyImplyLeading: false,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Login Successful!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'In production, the app would now navigate to the home screen.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                context.goNamed(Routes.login.name);
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    ),
  );
}

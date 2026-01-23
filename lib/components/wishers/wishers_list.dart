import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

class Wisher {
  const Wisher(this.name);
  final String name;
}

class WishersList extends StatelessWidget {
  const WishersList({super.key});

  static const List<Wisher> _wishers = [
    Wisher('Alice'),
    Wisher('Bob'),
    Wisher('Charlie'),
    Wisher('Diana'),
    Wisher('Alice'),
    Wisher('Bob'),
    Wisher('Charlie'),
    Wisher('Diana'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final colorScheme = context.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.wishers, style: textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _wishers.length,
              itemBuilder: (context, index) {
                final wisher = _wishers[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          wisher.name[0],
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(wisher.name, style: textTheme.bodySmall),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

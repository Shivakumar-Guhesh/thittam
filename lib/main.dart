import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_IN', null);
  runApp(const ProviderScope(child: ThittamApp()));
}

class ThittamApp extends ConsumerWidget {
  const ThittamApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thittam',
      themeMode: ref.watch(themeProvider),
      darkTheme: AppTheme.build(Brightness.dark),
      theme: AppTheme.build(Brightness.light),
      home: const Scaffold(
        body: Center(child: Text('Thittam Dashboard Shell Ready')),
      ),
    );
  }
}

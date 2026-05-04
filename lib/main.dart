import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:invoice_app/core/services/notification_service.dart';
import 'package:invoice_app/core/theme/app_theme.dart';
import 'package:invoice_app/providers/buyer_provider.dart';
import 'package:invoice_app/providers/invoice_provider.dart';
import 'package:invoice_app/providers/seller_provider.dart';
import 'package:invoice_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SellerProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => BuyerProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()..initialize()),
      ],
      child: const InvoiceApp(),
    ),
  );
}

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvoiceKu',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

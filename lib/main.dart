import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:little_invoice/core/services/notification_service.dart';
import 'package:little_invoice/core/theme/app_theme.dart';
import 'package:little_invoice/core/theme/app_colors.dart';
import 'package:little_invoice/providers/buyer_provider.dart';
import 'package:little_invoice/providers/invoice_provider.dart';
import 'package:little_invoice/providers/seller_provider.dart';
import 'package:little_invoice/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await NotificationService().initialize();
    tz.initializeTimeZones();
  }

  // Match the DESIGN status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
      title: 'Invoicely',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

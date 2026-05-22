# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Little Invoice is an offline-first Flutter/Dart mobile application for invoice management targeting freelancers and small businesses in Indonesia (currency: Indonesian Rupiah "Rp"). Application ID: `com.penacode.little_invoice`.

## Common Commands

```bash
# Dependencies
flutter pub get

# Run
flutter run                    # Default device
flutter run -d android         # Android
flutter run -d chrome          # Web

# Test
flutter test                   # All tests
flutter test test/database_test.dart  # Single test file

# Lint
flutter analyze

# Build
flutter build apk              # Android APK
flutter build web              # Web

# Launcher icons
flutter pub run flutter_launcher_icons
```

## Architecture

### Data Flow

```
UI (Screens/Widgets)
    ↓
Providers (ChangeNotifierProvider) — BuyerProvider, InvoiceProvider, SellerProvider
    ↓
DAOs (Data Access Objects) — BuyerDao, InvoiceDao, InvoiceItemDao, SellerDao
    ↓
DatabaseHelper (SQLite singleton) — invoice_app.db
```

### Key Layers

- **`lib/core/database/`** — SQLite database singleton (`database_helper.dart`) with DAO pattern for all CRUD operations. Foreign keys enforced. On web (`kIsWeb`), falls back to in-memory lists.
- **`lib/providers/`** — Three `ChangeNotifier` providers manage state: `SellerProvider` (single profile, loaded on startup), `BuyerProvider` (client list), `InvoiceProvider` (invoices + line items + notification scheduling).
- **`lib/models/`** — Data models: `Buyer`, `Invoice`, `InvoiceItem`, `SellerProfile`.
- **`lib/screens/`** — UI screens. `HomeScreen` uses `IndexedStack` with bottom nav (Dashboard, Invoices, Clients, Profile). FAB on tabs 0-1 navigates to `InvoiceFormScreen`.
- **`lib/features/pdf/`** — PDF generation via `PdfGenerator` orchestrator with two templates: `TemplateClassic` (serif, bordered) and `TemplateModern` (band header). A4 format.
- **`lib/core/services/`** — `FileService` (image/PDF file ops), `InvoiceCalculator` (subtotal/discount/tax/DP), `NotificationService` (singleton, schedules reminders 1 day before due date at 9 AM).
- **`lib/core/theme/`** — Design system: `app_colors.dart` (Material 3, Navy primary, Amber secondary), `app_text_styles.dart` (Manrope headings, Inter body via `google_fonts`), `app_theme.dart` (ThemeData + spacing/radius constants).

### Database Schema (4 tables)

- `seller_profiles` — id, name, address, phone, email, bank, logo_path, stamp_path, signature_path
- `buyers` — id, name, address, phone, email
- `invoices` — id, seller_id (FK), buyer_id (FK), invoice_number (UNIQUE), city_date, due_date, status (paid/unpaid), subtotal, discount, tax, dp, total, notes
- `invoice_items` — id, invoice_id (FK, CASCADE DELETE), description, quantity, price, line_total

### Invoice Number Format

Generated in `lib/core/utils/constants.dart`: `INV-YYYYMMDD-XXXX` (random 4-digit suffix).

## Platform Notes

- Android build uses Groovy DSL (not Kotlin DSL), Java 17, core library desugaring enabled for `flutter_local_notifications`.
- `NotificationService` has two identical files (`notification_service.dart` and `notification_service_mobile.dart`).
- Design reference: `Ref/DESIGN.md` (formal spec) and `DESIGN` (HTML mockups).

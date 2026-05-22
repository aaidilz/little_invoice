# Little Invoice — Comprehensive Flutter App Review

---

## 1. Ringkasan Masalah Utama

| # | Masalah | Severity | Kategori |
|---|---------|----------|----------|
| 1 | **Excessive `setState` rebuilds** di `InvoiceFormScreen` — setiap keystroke memicu full recalculate + rebuild | 🔴 High | Performance |
| 2 | **`InvoiceItemRow` menggunakan `initialValue` bukan `controller`** — state hilang saat rebuild | 🔴 High | Bug |
| 3 | **Tidak ada search functionality** yang benar-benar bekerja di `BuyerListScreen` — TextField ada tapi tidak terkoneksi | 🔴 High | UX |
| 4 | **Dashboard stat cards tidak match DESIGN** — DESIGN menunjukkan "Total Amount Due" card besar, implementasi hanya 4 card kecil | 🟡 Medium | UI Drift |
| 5 | **Bottom nav custom tapi tidak Material 3 `NavigationBar`** — inkonsisten dengan M3 spec | 🟡 Medium | M3 Compliance |
| 6 | **`_FieldLabel` widget diduplikasi** di `invoice_form_screen.dart` dan `seller_profile_screen.dart` | 🟡 Medium | Architecture |
| 7 | **`PdfPreviewScreen` adalah `StatelessWidget` dengan mutable field** (`FileService`) | 🟡 Medium | Bug Risk |
| 8 | **`isLoading` di-set true untuk operasi read** (`getItemsForInvoice`) — blocking UI unnecessarily | 🟡 Medium | UX |
| 9 | **Duplicate notification service files** (`notification_service.dart` & `notification_service_mobile.dart`) | 🟡 Medium | Maintenance |
| 10 | **Missing asset directories** (`assets/images/`, `assets/fonts/`) — build warnings | 🟡 Medium | Build |
| 11 | **No error state UI** — `errorMessage` di providers tidak pernah ditampilkan ke user | 🔴 High | UX |
| 12 | **Dismissible tanpa confirmation** di `BuyerListScreen` — delete langsung tanpa dialog | 🟡 Medium | UX Safety |

---

## 2. Prioritas Fix

### P0 — Fix Segera (Crash/Data Loss Risk)

1. **`InvoiceItemRow` `initialValue` bug**: Karena menggunakan `initialValue` bukan `TextEditingController`, saat parent rebuild (setiap `_recalculate()`), form field bisa kehilangan atau menampilkan stale data.

   **Fix**: Gunakan `TextEditingController` yang dikelola di parent, atau wrap dalam `StatefulWidget` internal.

2. **Error state tidak ditampilkan**: Semua provider punya `errorMessage` tapi tidak ada screen yang menampilkannya. User tidak tahu kalau save gagal.

   **Fix**: Tambahkan error listener/snackbar di setiap Consumer.

3. **`use_build_context_synchronously`** di `invoice_form_screen.dart:68` — bisa crash jika widget unmounted.

### P1 — Fix Penting (UX/Performance)

4. **Debounce `_recalculate()`** — saat ini setiap keystroke di qty/price/discount/tax field memicu `setState` + recalculate.
5. **Buyer search** — implement filter logic yang sudah ada UI-nya.
6. **Delete confirmation** untuk buyer (saat ini Dismissible langsung delete).
7. **Loading state granularity** — `getItemsForInvoice` tidak perlu set `isLoading = true`.

### P2 — Improvement (Quality)

8. Extract `_FieldLabel` ke shared widget.
9. Hapus duplicate notification service file.
10. Create `assets/images/` dan `assets/fonts/` directories.
11. Fix semua `deprecated_member_use` warnings (`withOpacity` → `withValues`).

---

## 3. UI/UX Review

### 3.1 Consistency Antar Screen

| Aspek | Status | Detail |
|-------|--------|--------|
| Color palette | ✅ Konsisten | Semua screen menggunakan `AppColors` |
| Typography | ✅ Konsisten | `AppTextStyles` digunakan konsisten |
| Spacing | ⚠️ Mostly OK | Beberapa hardcoded values (e.g. `vertical: 6` di StatusBadge) |
| Card style | ✅ Konsisten | Pattern Container+decoration digunakan konsisten |
| AppBar | ⚠️ Inkonsisten | HomeScreen pakai custom title Row, detail screen pakai text biasa |

### 3.2 Widget Hierarchy Issues

- **`HomeScreen`** terlalu banyak responsibility — mengelola bottom nav, FAB visibility, dan tab state. Pertimbangkan pisahkan navigation shell.
- **`_HomeTab`** nested di dalam `home_screen.dart` — seharusnya file terpisah untuk readability.
- **`InvoiceDetailScreen`** punya 596 lines — terlalu besar untuk satu screen. Extract card sections ke widgets.

### 3.3 Visual Hierarchy

- ✅ **Summary card** (dark navy + amber total) sangat efektif — focal point yang jelas.
- ⚠️ **Dashboard stat cards** semua ukuran sama — DESIGN menunjukkan "Total Amount Due" seharusnya card besar (2 column span).
- ⚠️ **Invoice list** kurang visual differentiation antara paid/unpaid selain badge kecil.

### 3.4 Apakah Design Terasa Outdated?

**Tidak.** Color scheme navy + amber, rounded cards dengan subtle shadows, Material Symbols icons — ini terasa modern dan professional. Namun beberapa area bisa di-enhance:

- Tidak ada **micro-animations** (card press effects, shimmer loading, page transitions).
- Tidak ada **skeleton loading** — hanya `CircularProgressIndicator` polos.
- Bottom nav custom sudah bagus tapi kurang **indicator animation** saat switch tab.

### 3.5 UX yang Membingungkan

1. **"Create" tab di bottom nav (DESIGN) vs tidak ada di implementasi** — DESIGN menunjukkan 5 tabs (Dashboard, Invoices, Create, Clients, Profile), implementasi hanya 4 tabs. FAB menggantikan "Create" tab, tapi FAB hilang di tab Clients dan Profile.

2. **Invoice detail → PDF export** — user harus tap "Export PDF" lalu preview lalu save/share. Ini 3 langkah — bisa disederhanakan.

3. **Seller Profile harus diisi dulu** sebelum bisa membuat invoice — tidak ada onboarding/prompt yang mengarahkan user baru.

### 3.6 Responsive & Adaptive

- ⚠️ **Tidak ada responsive breakpoint** di Flutter code — semua screen hanya portrait mobile layout.
- DESIGN file menunjukkan `md:grid-cols-2`, `lg:grid-cols-12` tapi Flutter implementation semuanya single-column.
- **Tablet** akan terasa kosong dan stretched.

### 3.7 Accessibility

| Aspek | Status |
|-------|--------|
| Semantic labels | ❌ Missing — tidak ada `Semantics` widget |
| Touch target size | ⚠️ Beberapa IconButton terlalu kecil |
| Color contrast | ✅ Navy on white = excellent contrast |
| Screen reader | ❌ Tidak diuji — `InvoiceCard` Stack+Positioned bisa confusing |
| Font scaling | ⚠️ Hardcoded font sizes, tidak respect `MediaQuery.textScaleFactor` |

---

## 4. Onboarding / Tutorial Recommendation

### Library Comparison

| Library | Pub Likes | Use Case | Complexity | Recommendation |
|---------|-----------|----------|------------|----------------|
| `showcaseview` | ⭐⭐⭐ | Feature highlight overlay | Low | **✅ Best fit** |
| `tutorial_coach_mark` | ⭐⭐ | Guided tour overlay | Medium | Good alternative |
| `introduction_screen` | ⭐⭐⭐ | Initial walkthrough slides | Low | Combine with above |

### Recommended Strategy: 2-Layer Onboarding

**Layer 1: First-launch intro** (`introduction_screen`)
- 3 slides max: "Create Profile" → "Add Clients" → "Make Invoices"
- Muncul hanya sekali saat pertama install

**Layer 2: Contextual feature discovery** (`showcaseview`)
- Highlight FAB, bottom nav tabs, export button
- Trigger saat user pertama kali masuk screen tertentu

### Implementation Plan

```
lib/
├── core/
│   └── services/
│       └── onboarding_service.dart    # SharedPreferences wrapper
├── features/
│   └── onboarding/
│       ├── onboarding_screen.dart     # introduction_screen wrapper
│       └── showcase_keys.dart         # GlobalKey registry
```

**State persistence**: Gunakan `shared_preferences` dengan keys:
```dart
class OnboardingService {
  static const _introCompleteKey = 'onboarding_intro_complete';
  static const _dashboardTourKey = 'onboarding_dashboard_tour';
  static const _invoiceTourKey = 'onboarding_invoice_tour';
  
  Future<bool> isIntroComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_introCompleteKey) ?? false;
  }
  
  Future<void> completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introCompleteKey, true);
  }
}
```

**Kapan muncul**:
- Intro screen: `main.dart` — check `isIntroComplete()` sebelum show `HomeScreen`
- Feature tour: `initState()` di setiap screen — check per-screen flag

**Best practices**:
- Selalu ada "Skip" button
- Jangan block user dari menggunakan app
- Max 4 steps per tour
- Jangan ulang setelah selesai
- Bisa di-trigger ulang dari Settings/Help

---

## 5. Bug Analysis

### 🔴 Critical Bugs

#### BUG-1: `InvoiceItemRow` State Loss
- **File**: `lib/widgets/invoice_item_row.dart`
- **Issue**: Menggunakan `initialValue` pada `TextFormField` di dalam `StatelessWidget`. Setiap kali parent `setState()` (yang terjadi setiap keystroke via `_recalculate()`), widget ini di-rebuild dan `initialValue` bisa conflict dengan current user input.
- **Reproduce**: Edit quantity → ketik angka price → quantity field bisa reset.
- **Fix**: Convert ke `StatefulWidget` dengan internal `TextEditingController`, atau gunakan `AutomaticKeepAliveClientMixin`.

#### BUG-2: Context Used Across Async Gap
- **File**: `lib/screens/invoice_form_screen.dart:62-86`
- **Issue**: `context.read<BuyerProvider>()` dipanggil setelah `await` tanpa `mounted` check yang memadai. Line 69 mengakses context setelah async gap.
- **Fix**: Store reference sebelum await, atau check `mounted` sebelum setiap akses context.

#### BUG-3: `firstWhere` Without `orElse` Can Throw
- **File**: `invoice_detail_screen.dart:138-139`, `invoice_form_screen.dart:64-65`
- **Issue**: `provider.invoices.firstWhere((i) => i.id == widget.invoiceId)` — jika invoice sudah di-delete (e.g. dari screen lain), ini akan throw `StateError`.
- **Fix**: Tambahkan `orElse` dan handle null case.

### 🟡 Medium Bugs

#### BUG-4: Search Bar Non-functional
- **File**: `lib/screens/buyer_list_screen.dart:27`
- **Issue**: `TextField` untuk search tidak punya `onChanged` handler atau filter logic.

#### BUG-5: `PdfPreviewScreen` Mutable in StatelessWidget
- **File**: `lib/screens/pdf_preview_screen.dart:12`
- **Issue**: `FileService _fileService = FileService()` — non-final field di StatelessWidget. Technically works tapi violates contract.
- **Fix**: Make `final` atau convert ke `StatefulWidget`.

#### BUG-6: `isLoading` Blocks All UI Operations
- **File**: `lib/providers/invoice_provider.dart`
- **Issue**: Single `_isLoading` flag untuk semua operasi. `getItemsForInvoice()` sets `isLoading = true` yang bisa block UI di screen lain yang watch provider ini.

#### BUG-7: Buyer Delete Without Cascade Check
- **File**: `lib/screens/buyer_list_screen.dart:141`
- **Issue**: `Dismissible.onDismissed` langsung delete buyer tanpa check apakah ada invoice yang reference buyer ini. Database FK constraint akan fail silently atau throw.

#### BUG-8: `DropdownButtonFormField` Deprecated `value` Parameter
- **File**: `lib/screens/invoice_form_screen.dart:225-226`
- **Issue**: Analyzer warning — `value` deprecated, harus pakai `initialValue`.

### 🟢 Low Severity

#### BUG-9: Unused Imports (4 files)
- All DAO files import `sqflite` unnecessarily.

#### BUG-10: Missing Asset Directories
- `assets/images/` dan `assets/fonts/` tidak exist — build warning.

---

## 6. Architecture Improvement

### 6.1 Current Architecture Assessment

```
Grade: B-
```

**Strengths**:
- Clean DAO pattern untuk database access
- Provider pattern konsisten
- Theme system well-organized (AppColors, AppTextStyles, AppTheme)
- Reusable widgets (StatusBadge, EmptyState, CalculationSummary)

**Weaknesses**:

#### A. Provider Overload
Setiap provider melakukan terlalu banyak: loading state, error state, business logic, notification scheduling. `InvoiceProvider` punya 233 lines dengan mixed concerns.

**Recommendation**: Pisahkan ke repository pattern:
```
Provider (UI state) → UseCase/Service (business logic) → Repository → DAO
```

#### B. No Dependency Injection
Semua DAO di-instantiate langsung: `final InvoiceDao _invoiceDao = InvoiceDao()`. Ini membuat testing sulit.

**Fix**: Inject via constructor atau gunakan `get_it`/`injectable`.

#### C. Widget File Size
| File | Lines | Verdict |
|------|-------|---------|
| `invoice_detail_screen.dart` | 596 | ❌ Too large — extract sections |
| `invoice_form_screen.dart` | 552 | ❌ Too large — extract sections |
| `home_screen.dart` | 396 | ⚠️ Borderline — extract `_HomeTab` |
| `seller_profile_screen.dart` | 350 | ⚠️ OK but extractable |

#### D. Recommended Refactors

1. **Extract `_FieldLabel`** ke `lib/widgets/field_label.dart`
2. **Extract `_FormSection`** ke `lib/widgets/form_section.dart`  
3. **Extract `_StatCard`** ke `lib/widgets/stat_card.dart`
4. **Extract `_BuyerCard`** ke `lib/widgets/buyer_card.dart`
5. **Move `_HomeTab`** ke `lib/screens/dashboard_tab.dart`

### 6.2 Suggested Design System Improvements

```dart
// lib/core/theme/app_spacing.dart (new)
abstract class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  
  // Semantic spacing
  static const cardPadding = lg;
  static const sectionGap = lg;
  static const screenPadding = lg;
  static const fieldGap = sm;
}
```

### 6.3 Theme Management

Current: ✅ Good — sudah ada `AppTheme.lightTheme` yang centralized.

Missing:
- **Dark theme** — DESIGN file punya `dark:` classes tapi tidak ada `darkTheme` di Flutter.
- **Dynamic color** — Material 3 mendukung `ColorScheme.fromSeed()` tapi tidak digunakan.
- **TextTheme mapping** agak confusing — `displayMedium` mapped ke `h2`, `headlineMedium` ke `h1`.

---

## 7. QA Checklist

### Manual Testing Scenarios

#### 7.1 Invoice CRUD
- [ ] Create invoice tanpa seller profile → harus show error
- [ ] Create invoice tanpa buyer → harus show validation
- [ ] Create invoice tanpa items → harus show validation
- [ ] Edit existing invoice → semua field harus pre-filled
- [ ] Delete invoice → confirmation dialog → list updated
- [ ] Toggle status paid ↔ unpaid → badge updated immediately

#### 7.2 Buyer CRUD
- [ ] Add buyer → appears in list
- [ ] Edit buyer → navigate ke form with pre-filled data
- [ ] Swipe-delete buyer yang punya invoice → harus show error/warning
- [ ] Swipe-delete buyer tanpa invoice → delete sukses

#### 7.3 Seller Profile
- [ ] First launch tanpa profile → form kosong
- [ ] Save profile → snackbar success
- [ ] Upload logo/stamp/signature → image ditampilkan
- [ ] Save tanpa required fields → validation error

#### 7.4 PDF Generation
- [ ] Export PDF dari invoice detail → preview muncul
- [ ] Save PDF to device → file saved + snackbar
- [ ] Share PDF → share sheet muncul

#### 7.5 Edge Cases
- [ ] Create invoice with very long description → no overflow
- [ ] Create invoice with 0 quantity → handle gracefully  
- [ ] Create invoice with negative price → validate
- [ ] Invoice number collision (same timestamp) → handle UNIQUE constraint
- [ ] Rotate device mid-form → data preserved
- [ ] Kill app mid-save → data consistency
- [ ] 100+ invoices → scroll performance OK
- [ ] 100+ buyers → search works, scroll OK

#### 7.6 Notification
- [ ] Create unpaid invoice with future due date → notification scheduled
- [ ] Mark as paid → notification cancelled
- [ ] Due date in past → no notification scheduled
- [ ] App killed → notification still fires (system-level)

### Widget Testing Priorities

```dart
// Priority 1: Business logic
test('InvoiceCalculator calculates correctly with discount + tax + DP');
test('CurrencyFormatter handles 0, negatives, large numbers');
test('Invoice number generation is unique');

// Priority 2: Provider logic  
test('InvoiceProvider.createInvoice adds to list');
test('InvoiceProvider.toggleStatus switches correctly');
test('BuyerProvider.deleteBuyer removes from list');

// Priority 3: Widget rendering
testWidgets('StatusBadgeWidget shows correct color for paid/unpaid');
testWidgets('EmptyStateWidget shows CTA when provided');
testWidgets('InvoiceCard displays all invoice info');
testWidgets('CalculationSummaryWidget shows correct totals');
```

### Recommended Tools

| Tool | Purpose |
|------|---------|
| `flutter test` | Unit + widget tests |
| Flutter DevTools | Performance profiling, widget inspector |
| `flutter analyze` | Static analysis (sudah ada output) |
| `flutter test --coverage` | Code coverage |
| `patrol` | Integration/E2E testing |

---

## 8. Next Steps Implementasi

### Sprint 1 (1-2 hari): Critical Fixes
1. Fix `InvoiceItemRow` initialValue bug → convert ke StatefulWidget
2. Add error state display (snackbar on provider error)
3. Fix `firstWhere` tanpa `orElse` di detail/form screens
4. Fix async context usage di `invoice_form_screen.dart`

### Sprint 2 (2-3 hari): UX Improvements
5. Implement buyer search filter
6. Add delete confirmation dialog untuk buyer swipe
7. Add buyer cascade-delete check
8. Implement skeleton/shimmer loading
9. Add `isLoading` granularity (separate flags per operation)

### Sprint 3 (2-3 hari): Onboarding
10. Add `shared_preferences` dependency
11. Create `OnboardingService`
12. Implement first-launch intro screen (`introduction_screen`)
13. Add `showcaseview` feature tours pada Dashboard dan Invoice Form

### Sprint 4 (1-2 hari): Code Quality
14. Extract duplicated widgets (`_FieldLabel`, `_FormSection`, dll)
15. Clean up lint warnings (deprecated APIs, unused imports, const constructors)
16. Delete duplicate notification service file
17. Create missing asset directories

### Sprint 5 (2-3 hari): Polish
18. Add page transition animations
19. Implement responsive layout for tablet
20. Add dark theme support
21. Accessibility pass (Semantics, touch targets)

---

> [!IMPORTANT]
> **Masalah paling kritis** yang harus segera diperbaiki adalah `InvoiceItemRow` state loss bug (BUG-1) dan missing error state display (masalah #11). Kedua ini langsung mempengaruhi data integrity dan user trust.

> [!TIP]
> Untuk dashboard, pertimbangkan mengubah layout stat cards dari 2×2 grid menjadi pattern dari DESIGN: satu card besar "Total Amount Due" spanning 2 kolom di atas, diikuti stats kecil di bawah. Ini memberikan visual hierarchy yang lebih kuat dan menjadi focal point yang jelas.

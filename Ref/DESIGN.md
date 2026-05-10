---
name: Professional Ledger
colors:
  surface: '#fbf9fb'
  surface-dim: '#dbd9dc'
  surface-bright: '#fbf9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3f5'
  surface-container: '#efedf0'
  surface-container-high: '#e9e7ea'
  surface-container-highest: '#e4e2e4'
  on-surface: '#1b1b1e'
  on-surface-variant: '#44474d'
  inverse-surface: '#303032'
  inverse-on-surface: '#f2f0f3'
  outline: '#75777e'
  outline-variant: '#c5c6ce'
  surface-tint: '#4e5f7c'
  primary: '#04162f'
  on-primary: '#ffffff'
  primary-container: '#1a2b45'
  on-primary-container: '#8293b2'
  inverse-primary: '#b6c7e8'
  secondary: '#865300'
  on-secondary: '#ffffff'
  secondary-container: '#fea520'
  on-secondary-container: '#694000'
  tertiary: '#201400'
  on-tertiary: '#ffffff'
  tertiary-container: '#3a2702'
  on-tertiary-container: '#aa8d5e'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d6e3ff'
  primary-fixed-dim: '#b6c7e8'
  on-primary-fixed: '#091c35'
  on-primary-fixed-variant: '#374763'
  secondary-fixed: '#ffddb9'
  secondary-fixed-dim: '#ffb961'
  on-secondary-fixed: '#2b1700'
  on-secondary-fixed-variant: '#663e00'
  tertiary-fixed: '#ffdeab'
  tertiary-fixed-dim: '#e3c28e'
  on-tertiary-fixed: '#271900'
  on-tertiary-fixed-variant: '#59431b'
  background: '#fbf9fb'
  on-background: '#1b1b1e'
  surface-variant: '#e4e2e4'
typography:
  h1:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  h2:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-bold:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  stat-display:
    fontFamily: Manrope
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  safe-margin: 16px
  gutter: 12px
---

## Brand & Style
The brand personality is rooted in reliability, efficiency, and professional integrity. As an offline invoice application, the UI must instill a sense of security and "local-first" stability. The target audience includes freelancers, small business owners, and contractors who require a dependable tool for financial management on the go.

The visual style is **Corporate / Modern**. It leverages a clean, flat aesthetic that prioritizes content legibility and functional hierarchy. The interface avoids unnecessary flourishes, focusing instead on high-quality typography and a structured information architecture. Subtle shadows and soft corners are used to provide a modern, tactile feel without the visual clutter of skeuomorphism. The design evokes a feeling of calm competence, ensuring users feel in control of their business data.

## Colors
The palette is led by a deep **Navy (#1A2B45)**, used for primary actions, headers, and the core brand identity to project authority. The **Amber (#F39C12)** accent is used sparingly for high-impact call-to-actions, pending statuses, and highlighting critical data points like total amounts due.

Backgrounds utilize a **Very Light Gray (#F9FAFB)** to reduce eye strain and distinguish surface cards from the application floor. Status-specific colors (Emerald for Paid, Rose for Unpaid) complement the core palette to provide instant visual feedback on invoice states. Text uses a high-contrast charcoal for maximum readability against white surfaces.

## Typography
This design system utilizes a dual-font approach to balance character with utility. **Manrope** is used for headlines and financial figures to provide a refined, modern, and trustworthy feel. Its geometric nature makes currency values appear stable and clear.

**Inter** is the workhorse for all body text, inputs, and labels. Its high x-height and neutral design ensure excellent legibility on mobile screens, even at smaller sizes. A strict hierarchy is maintained through weight variation (Bold for headers/labels, Regular for body) and purposeful whitespace. Numerical data in invoices should utilize tabular figures to ensure columns align perfectly.

## Layout & Spacing
The layout follows a **Fluid Grid** model designed for mobile-first interactions. Content is contained within a 16px safe margin on both left and right edges. The vertical rhythm is governed by an 8px base unit, ensuring consistent scaling across different device sizes.

Elements are grouped in logical cards with 16px internal padding. Lists of invoices use 12px gutters between items to maintain a dense but readable information flow. Large touch targets (minimum 48px height) are mandatory for all interactive elements to facilitate easy offline data entry.

## Elevation & Depth
Depth is communicated through **Tonal Layers** and **Ambient Shadows**. The application uses a flat base (Level 0) for the background. Interactive elements like invoice cards and input fields sit on Level 1, utilizing a very soft, diffused shadow (0px 4px 12px, 5% opacity Navy) to appear slightly lifted.

High-priority actions, such as "Create New Invoice" floating buttons, occupy Level 2 with a more pronounced shadow to indicate higher z-index priority. Modal overlays and bottom sheets use a backdrop blur (10px) to maintain context while focusing user attention on the task at hand.

## Shapes
The shape language is **Rounded**, utilizing a 0.5rem (8px) base radius for standard components like buttons and input fields. This softened geometry makes the professional navy palette feel more approachable and modern.

Larger containers, such as invoice summary cards and bottom sheets, use `rounded-xl` (24px) on top corners to create a distinct, modern container feel. Success/Error badges and tags utilize a full pill-shape (circular ends) to contrast against the more structured rectangular forms of the primary UI.

## Components

### Buttons
- **Primary:** Solid Navy (#1A2B45) background with white text. High emphasis.
- **Secondary:** White background with Navy border and text. Used for secondary actions.
- **Accent:** Solid Amber (#F39C12) background for "Pay Now" or "Finalize" actions.

### Status Badges
- **Paid:** Emerald green background (10% opacity) with dark green text.
- **Unpaid/Overdue:** Rose red background (10% opacity) with dark red text.
- **Draft:** Slate gray background (10% opacity) with dark gray text.
- *Shape:* Pill-shaped with uppercase label-bold typography.

### Input Fields
- **Style:** Outlined with a subtle gray border that transitions to Navy on focus. 
- **Touch Target:** 56px height to ensure ease of use for manual entry.
- **Labels:** Floating or top-aligned small caps for persistent context.

### Brand Assets & Signature
- **Logo (IMAGE_2):** Positioned at the top left of the dashboard and centered on the login screen.
- **Signature (IMAGE_1):** Integrated at the bottom of PDF templates and invoice detail screens as a "Verified" mark.

### PDF Templates
- **Classic:** Uses a serif font (Source Serif) for the header, formal grid lines, and the Navy primary color for the header bar. The signature is placed at the bottom right.
- **Modern:** Uses Manrope for all text, a "band" style header using the Navy color, and Amber highlights for the "Total Due" section. High whitespace and a more editorial layout.
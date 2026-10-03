---
name: Utilitarian Kinetic Workshop
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#45464d'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#76777d'
  outline-variant: '#c6c6cd'
  surface-tint: '#565e74'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#131b2e'
  on-primary-container: '#7c839b'
  inverse-primary: '#bec6e0'
  secondary: '#a73a00'
  on-secondary: '#ffffff'
  secondary-container: '#fd651e'
  on-secondary-container: '#571a00'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#00174b'
  on-tertiary-container: '#497cff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#ffdbce'
  secondary-fixed-dim: '#ffb599'
  on-secondary-fixed: '#370e00'
  on-secondary-fixed-variant: '#7f2b00'
  tertiary-fixed: '#dbe1ff'
  tertiary-fixed-dim: '#b4c5ff'
  on-tertiary-fixed: '#00174b'
  on-tertiary-fixed-variant: '#003ea8'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: 0em
  title-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0em
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0em
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  gutter-lg: 1.5rem
  margin: 1rem
  margin-sm: 0.75rem
  margin-lg: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system is engineered for roadside urgency, physical mechanical reliability, and outdoor clarity. It serves drivers, riders, fleet operators, and certified independent mechanics operating under direct sunlight, low-light roadside breakdowns, and grease-laden physical settings. 

The aesthetic is **Tactile Modern Utilitarian**—grounded in industrial equipment interfaces, workshop tooling, and high-visibility road safety markers. The interface balances high-contrast functionality with refined digital craftsmanship:
- **Emergency Readiness:** High-contrast kinetic cues, aggressive legibility, and unmistakable interactive targets prevent cognitive overload during vehicle distress.
- **Physical-Digital Metaphor:** Squircle surfaces, subtle tactile press offsets, and structural mechanical framing evoke heavy-duty diagnostic tools rather than ethereal consumer software.
- **Precision Confidence:** Deep industrial foundations coupled with acute safety amber and diagnostic signal colors communicate professional-grade execution and logistical dependability.

## Colors

The palette balances stark industrial slates with safety pigments engineered for field contrast (WCAG AAA for critical indicators, AA for secondary telemetry).

### Color Roles & Semantic Application
- **Primary (`#0F172A` - Industrial Deep Slate):** Anchors core chrome, navigation shells, primary headers, dominant floating action buttons, and active vehicle context headers.
- **Secondary (`#EA580C` - Safety Road Amber):** Reserved for immediate roadside dispatch, primary CTA confirmation ("Request Mechanic Now"), active mechanical warnings, and live route status. A lighter shift (`#F97316`) is used strictly for interactive hover/press states and dark-surface badges.
- **Tertiary (`#2563EB` - Precision Diagnostic Blue):** Governs parts catalog pricing, garage verification badges, telemetry status updates, and secondary functional links.
- **Neutral (`#64748B` - Mechanical Steel Slate):** Governs secondary metadata, border frames, inactive navigation items, and spec sheet rules.
- **Semantic Accents:**
  - **Operational Emerald (`#10B981`):** Indicates open garages, in-stock parts, certified mechanics, and normal OBD-II telemetry.
  - **Critical Hazard (`#DC2626`):** Dedicated to vehicle immobilization alerts, failed diagnostics, and payment halts.
  - **Surface Canvas (`#F8FAFC`):** Low-glare, cool industrial tint ensuring zero washout in extreme daylight environments.

## Typography

Typography prioritizes micro-legibility during high vibration, movement, and variable ambient lighting:
- **Plus Jakarta Sans** is leveraged for Display and Headline tiers. Its geometric clarity and sculpted apertures maintain assertive brand presence without sacrificing structure.
- **Inter** provides high x-height readability across Body and Data tiers. Monospaced tabular numerals are standard for part numbers, odometer telemetry, pricing matrices, and countdown dispatch timers.
- **Hierarchy Rules:** Emergency statuses, VIN inputs, and dynamic parts matrices must always pair `label-md` or `label-sm` in all-caps tracking with bold tabular numerical outputs.

## Layout & Spacing

The spatial engine is built on an absolute 4px/8px incremental grid, calibrated specifically for thumb-driven one-handed reach zones on mobile hardware:
- **Mobile Grid:** Single fluid column with 16px (`1rem`) outer screen margins, expandable to a 4-column sub-grid for catalog listings and inventory screens.
- **Tablet/Foldable Grid:** 8-column layout with 24px margins, establishing split-pane views (left pane: map/locator view; right pane: technician sheet/parts list).
- **Hit Boundaries:** Interactive targets must enforce a minimum dimension of 48x48px, surrounded by at least `space-sm` (8px) of clear distance to ensure accurate activation under roadside stress or when wearing work gloves.

## Elevation & Depth

Visual hierarchy does not use soft, fuzzy blurs that wash out under sunlight. Instead, this system applies sharp, physical layering via multi-layered directional ambient occlusion and crisp 1px structural framing:

- **Level 0 (Base Canvas):** `#F8FAFC`, flat, zero shadow.
- **Level 1 (Structural Cards & Inputs):** Pure white `#FFFFFF` surface enclosed by a 1px solid border of `#E2E8F0`. Shadow: `0px 1px 3px rgba(15, 23, 42, 0.06), 0px 1px 2px rgba(15, 23, 42, 0.04)`.
- **Level 2 (Map Overlays, Floating Filters, Bottom Nav):** `#FFFFFF` surface. Shadow: `0px 4px 12px -2px rgba(15, 23, 42, 0.08), 0px 2px 6px -1px rgba(15, 23, 42, 0.04)`.
- **Level 3 (Modal Sheets, Urgent Roadside Drawers):** `#FFFFFF` surface with `#0F172A` structural backdrop veil at 48% opacity. Shadow: `0px 20px 25px -5px rgba(15, 23, 42, 0.12), 0px 10px 10px -5px rgba(15, 23, 42, 0.04)`.
- **Level 4 (Tactile Depressed State):** Active buttons shift Y-offset down by `1px` with an inward inset line `inset 0px 2px 4px rgba(15, 23, 42, 0.16)`, communicating positive mechanical engagement.

## Shapes

The geometric signature uses deliberate continuous curvature squircle geometry:
- **Default Structural Surfaces (Inputs, Buttons, Cards):** Squircle curvature calibrated to `rounded-lg` (16px) and `rounded-xl` (24px for major container cards and persistent bottom navigation).
- **Interactive Badges & Chips:** Enforced at `rounded-md` (8px) or complete circular pills for micro status tags.
- **Modal Drawers & Map Floating Sheets:** Top corners sculpted at 24px (`rounded-xl`), creating an integrated cradle for critical vehicle diagnostics and technician routing profiles.

## Components

### Buttons
- **Primary Dispatch Action:** `#EA580C` background, `#FFFFFF` text, `label-lg` font. Height: 54px. Full-width on mobile. 16px squircle radius. Pressed state: `#C2410C` with 1px positive translation downwards.
- **Secondary Industrial Action:** `#0F172A` background, `#FFFFFF` text, paired with dynamic leading mechanic/part icons.
- **Ghost Tooling Action:** Border 1.5px `#E2E8F0`, surface `#FFFFFF`, text `#0F172A`. Active state turns border to `#0F172A`.

### Chips & Stock Indicators
- **Mechanic Status:** Background `#ECFDF5`, text `#065F46`, left-anchored 8px filled emerald circle pulse (`#10B981`) for "Available On-Site".
- **Part Availability:** Pill badges showing stock thresholds. Green (`#10B981`) for immediate stock; Slate (`#64748B`) for 24h order dispatch.

### Form Fields & Diagnostic Inputs
- **Text Inputs:** Height 52px, surface `#FFFFFF`, border 1.5px `#CBD5E1`, roundedness 12px. Floating label transitioning from `body-md` to `label-sm`. Focus state: 2px border `#0F172A` with zero blurry outline rings.
- **VIN/Part Number Scanner Input:** Features monospaced font family, right-aligned camera icon CTA with `#0F172A` slate housing.

### Map Marker Cards & Garage Preview
- **Floating Map Cards:** Anchored 16px above bottom navigation. Level 2 elevation. Squircle 20px radius. Left column: 64x64px vehicle/bay thumbnail. Right column: Title, verified mechanic badge (`#2563EB`), star telemetry, and instant roadside dispatch ETA button.

### Elevated Bottom Navigation Bar
- **Architecture:** Floating dock layout offset 16px from screen perimeter or flush docked with a 1px border-t (`#E2E8F0`).
- **Surface:** `#0F172A` (Slate contrast mode) or `#FFFFFF` (Daylight high-readability mode).
- **Active State Indicator:** Active tab hosts a 4px safety amber (`#EA580C`) pill pill-notch directly beneath or highlighting the active icon with high-contrast tinted pill background.

### Selection Controls (Checkboxes & Radios)
- **Checkboxes:** 22x22px square with 6px squircle rounding. Border 2px `#94A3B8`. Selected: `#0F172A` fill with white heavy checkmark.
- **Radio Buttons:** 22x22px circular frame. Selected: 2px `#EA580C` active perimeter enclosing an 8px solid safety amber core.
# Timegrapher Logging

A SwiftUI iOS app designed for watchmakers to log and analyze timegrapher readings.

## Features

- **Position Readings Table**: Enter rate (s/d), amplitude, and beat error for standard 6 positions or 8 with diagonals.
- **Custom Pickers**: Lift angle and beat rate with custom entry support.
- **Calculations**:
  - Average rate, max delta, horizontal/vertical averages, vertical drop.
  - Largest deltas.
- **Dynamic Poising**:
  - Identifies fastest vertical position at low amplitude.
  - Visual balance wheel graphic with heavy spot (red arrow "REMOVE WEIGHT").
  - Crown stem orientation based on position.
  - Poise delta (vertical rate spread) with guidelines: <10 excellent, 10-20 good, ≤25 acceptable for vintage.
- **Isochronism Measurements**:
  - Toggle to enable 24-hour later readings table.
  - Computes rate changes (Δ) per position between full wind and after 24h.
  - Results include 24h average rate, avg isochronism rate change, isochronism max delta, amplitude drop.
  - Guidelines and per-cell coloring (red/orange for poor/acceptable deltas).
- **Export**: Save full results (including tables and analyses) as image to camera roll.
- **UX**: Tap anywhere to dismiss keyboard, clean table layout without borders.

## Usage

1. Enter Timepiece/Movement name.
2. Set lift angle and beat rate (or custom).
3. Fill in the Position Readings table (use low amplitude ~140-160° for poising).
4. Enable "Include Diagonal orientations" and/or "Include Isochronism measurements" as needed.
5. View Results and Dynamic Poising / Isochronism sections.
6. Tap "Save Timegrapher results to camera roll" to export.

For isochronism: After 24 hours, re-measure the same positions without rewinding and enter the values.

## Building

Open `Timegrapher Logging.xcodeproj` in Xcode 16+ (or compatible).

Requires iOS 17+ (or adjust deployment target).

## Publishing Notes

- Bundle ID: Currently `Dan-Ricks.Timegrapher-Logging` — change to your own (e.g. `com.yourname.timegrapherlogging`).
- App Icons: Add proper icons in `Assets.xcassets/AppIcon.appiconset/` (1024x1024 PNG recommended; Xcode can generate others).
- Privacy: Full policy in `Privacy_Policy.md` + `Privacy_Policy.html`. No website needed — use GitHub Gist or Netlify Drop (see bottom of Privacy_Policy.md).
- Version: Currently 1.0 (1). Increment for releases.
- Screenshots: Provide for iPhone 6.7", 6.5", 5.5", etc. in App Store Connect.
- Categories: Utilities or Productivity. Age rating: 4+ (no objectionable content).
- Description draft available upon request.

## Credits

Created by Dan Ricks, 2026.

For watchmakers and horology enthusiasts.

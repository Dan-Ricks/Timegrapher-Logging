# Timegrapher Logging - App Store Publishing Guide

## Backup Status
- Git commit: 5d1e72c (or latest)
- Tag: backup-2026-06-23
- Zip: ~/Backups/Timegrapher-Logging-backup-2026-06-23.zip

## Current Project Status (as of 2026-06-23)
- Version: 1.0 (Build 1)
- Bundle ID: Dan-Ricks.Timegrapher-Logging (change this!)
- Deployment: iOS (check target settings)
- Key features complete: Full position logging, poising, isochronism with Δ, export to photos, clean UI.

## Pre-Publishing Checklist

### 1. Xcode Project Setup
- [ ] Change Bundle Identifier to your own (e.g. com.yourcompany.timegrapherlogging or com.danricks.timegrapherlogging)
  - In Xcode: Project > Targets > Timegrapher Logging > General > Bundle Identifier
- [ ] Update Display Name if desired ("Timegrapher Logging")
- [ ] Set Version to 1.0, Build to 1 (increment for each release)
- [ ] Add your Apple Developer Team under Signing & Capabilities
- [ ] Enable Automatic signing
- [ ] Verify capabilities (Photo Library Add is required)

### 2. App Icons & Assets
- [ ] **Critical**: AppIcon.appiconset currently only has Contents.json — no images!
  - Add a 1024x1024 px PNG (with rounded corners or use Icon Composer)
  - Xcode can generate the rest (1x, 2x, 3x for all sizes)
- [ ] Splash background is included

### 3. Privacy & Permissions
- NSPhotoLibraryAddUsageDescription is already set in project.
- Add a Privacy Manifest if required (Xcode 15+).
- Consider a simple privacy policy (host on GitHub Pages or personal site).

### 4. App Store Connect
- Create new App in App Store Connect using the Bundle ID.
- App Information:
  - Name: Timegrapher Logging
  - Subtitle: (e.g. "Log & Analyze Timegrapher Readings")
  - Primary Category: Utilities or Productivity
  - Secondary: Reference
- Age Rating: 4+ (no violence, etc.)
- Copyright: 2026 Dan Ricks

### 5. Screenshots & Previews
Required sizes (at minimum):
- iPhone 6.9" (iPhone 16 Pro Max)
- iPhone 6.5" (iPhone 11 Pro Max / XS Max)
- iPhone 5.5" (iPhone 8 Plus)
- Optional: iPad sizes if supporting iPad

Take clean screenshots showing:
1. Main table + results
2. Dynamic Poising view with wheel
3. Isochronism table + colored deltas
4. Saved image example
5. Custom pickers / settings

### 6. App Store Listing Text (Draft)

**Subtitle:** Professional Timegrapher Logging for Watchmakers

**Description:**
Timegrapher Logging is the dedicated tool for watchmakers who want precise, professional records of their timegrapher work.

Log rates, amplitudes, and beat errors across all six (or eight with diagonals) positions. Instantly see calculated averages, deltas, and vertical drop.

**Dynamic Poising**
- Automatically detects the fastest vertical position at low amplitude
- Beautiful balance wheel graphic showing heavy spot location and crown orientation
- Clear guidelines for acceptable poise delta

**Isochronism Analysis**
- Dedicated 24-hour later readings table
- Per-position rate change (Δ) calculation
- Summary stats: average change, max delta, amplitude drop
- Color-coded cells and guidelines (<5 excellent, 10-15 acceptable, etc.)

**Export**
Save complete, publication-quality results images directly to your camera roll — perfect for client records or your own archives.

Features:
• Custom lift angle (50/52/53 + custom) and beat rate pickers
• Tap anywhere to dismiss keyboard
• Clean, borderless tables optimized for data entry
• Support for both modern and vintage movements

Built by a watch enthusiast, for watch enthusiasts.

**Keywords:** timegrapher, watchmaking, horology, poising, isochronism, regulation, watch repair, movement, amplitude, beat error

**Support URL:** (your email or site)
**Marketing URL:** (optional)

### 7. Screenshots Description Ideas
1. "Log all positions with rates, amplitude, and beat error"
2. "Instant dynamic poising analysis with visual guide"
3. "Measure isochronism with 24h delta calculations"
4. "Export professional results to your camera roll"

### 8. Release Process
1. In Xcode: Product > Archive
2. In Organizer: Distribute App > App Store Connect
3. Upload
4. In App Store Connect: add screenshots, description, pricing (Free)
5. Submit for Review (or TestFlight first)

### 9. Post-Launch
- Monitor reviews
- Add more positions or features based on feedback
- Consider watchOS companion? (advanced)

## Next Steps
Tell me what you'd like to tackle first:
- Draft more detailed store text
- Add version number display in the app
- Help prepare placeholder screenshots descriptions
- Clean up any remaining code
- Add a simple "About" screen
- Change bundle ID / prepare for your team
- Generate icon ideas or requirements

This app is in excellent shape for a 1.0 release!

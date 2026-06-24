# Timegrapher Logging - App Store Publishing Guide

## Backup Status
- Git commit: latest
- Tag: backup-2026-06-24 (if created)
- Full project zip: ~/Backups/Timegrapher-Logging-backup-2026-06-24.zip
- Publishing files backup: ~/Backups/Timegrapher-Logging-Publishing-2026-06-24/ (AppStore_Listing_Copy.txt, Privacy_Policy.txt, etc.)

## Current Project Status (as of 2026-06-24)
- Version: 1.0 (Build 1)
- Bundle ID: com.danricks.timegrapher-logging (already updated in project)
- Development Team ID: 7L6Z9XSNW8 (confirmed by you)
- Deployment: iOS (check target settings)
- Key features complete: Full position logging (with diagonals), dynamic poising with visual, isochronism measurements with 24h deltas and coloring, results export to camera roll, clean UI with keyboard dismiss.
- App icon: Added (vintage technical sketch style)
- **User status**: Apple Developer Program enrollment APPROVED and registered! (2026-06-24)

## Pre-Publishing Checklist

### 1. Xcode Project Setup
- [x] Bundle Identifier set to com.danricks.timegrapher-logging
- [x] Version 1.0 (Build 1)
- [x] Team ID 7L6Z9XSNW8 confirmed and already set in project.pbxproj
- [ ] Open project in Xcode → select your Team under Signing & Capabilities (Automatic)
- [ ] Verify capabilities (Photo Library Add is required)

### 2. App Icons & Assets
- [x] App icon added (vintage technical sketch / old watchbook style based on splash background).
- [x] Splash background is included (custom SwiftUI view)

### 3. Privacy & Permissions
- NSPhotoLibraryAddUsageDescription is already set in project.
- Privacy policy files created:
  - `Privacy_Policy.md` (full policy + hosting instructions)
  - `Privacy_Policy.html` (single-file version — perfect for drag-and-drop hosting)
  - `Privacy_Policy.txt` (plain text fallback)
- You do **not** need your own website. Use one of these free methods:
  - Netlify Drop (drag `Privacy_Policy.html`)
  - GitHub Gist (paste content → use Raw URL)
- Detailed steps are inside `Privacy_Policy.md` at the bottom.
- Paste the resulting public URL into App Store Connect → App Information → Privacy Policy.

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
**Key point**: Screenshots are **not added inside your app's code**. They are marketing assets you upload in **App Store Connect** (they show up on the store page). You do this **after** you have created the app record.

Required sizes (portrait, at minimum):
- iPhone 6.9" (iPhone 16 Pro Max / 15 Pro Max): 1290 × 2796 px
- iPhone 6.5" (iPhone 14 Plus / 11 Pro Max): 1242 × 2688 px
- iPhone 5.5" (iPhone 8 Plus): 1242 × 2208 px
- Optional: iPad 12.9" and 11" if you want iPad support

**How to take high-quality screenshots:**

1. In Xcode, open the Simulator (Window > Devices and Simulators).
2. Choose the correct device sizes above (use iPhone 16 Pro Max, etc.).
3. Run the app on Simulator.
4. Enter sample data manually (or use the values from the removed demo data set for consistency with previous shots).
5. Take screenshots with **Cmd + S** in Simulator (or File > Save Screenshot). They will be the exact required resolution.
6. Crop/trim if needed but keep the UI clean (no status bar overlays if possible, use Simulator's clean mode).

**Recommended screenshots (in order):**

1. **Main table + Results**  
   - Show the full Position Readings table (with diagonals) + the Results section below it.  
   - Make sure timepiece name is visible.

2. **Dynamic Poising section**  
   - The entire Dynamic Poising card with the balance wheel graphic visible, guidelines, and "Fastest vertical position" text.  
   - Scroll so the wheel is centered nicely.

3. **Isochronism table + results**  
   - The Isochronism Readings table (showing the Δ column and colored numbers).  
   - Include the poise/isochronism summary stats in Results if space.

4. **Saved image preview** (optional but strong)  
   - After tapping "Save Timegrapher results to camera roll", show the Photos app or the alert, or a screenshot of the exported image itself if you save it separately.

5. **Custom pickers**  
   - Show the Lift Angle and Beat Rate pickers open or with custom fields visible.

**Tips for clean shots:**
- Use a light mode simulator.
- Tap to dismiss keyboard.
- Avoid scrolling mid-shot if possible.
- Take multiple and pick the best.
- You can edit out the simulator frame later if needed, but App Store prefers full device frames sometimes.

After taking, upload the correct resolution files to App Store Connect under the iPhone screenshots section.

### 6. App Store Listing Text (Ready to Copy)

See the new file **AppStore_Listing_Copy.txt** (in the project root) for polished, ready-to-paste text. It includes:

- Subtitle
- Promotional Text
- Full Description (written to match the screenshots you just captured)
- Keywords
- What's New (v1.0)
- Support/Marketing URL placeholders

The description highlights the visuals from your screenshots (main table, results, poising wheel, isochronism table + stats, and export).

**Support URL:** https://paypal.me/DanRicks444
**Marketing URL:** (optional)

### 7. Recommended Screenshot Order & Captions
Upload in this order for best visual flow (use the files in your iPhone_6.9 folder, then duplicate for other sizes):

1. **01-Main-Table.png**  
   Caption idea: "Log rate, amplitude & beat error for all positions"

2. **02-Results.png**  
   Caption idea: "Instant calculations: averages, deltas & vertical drop"

3. **03-Poising-Wheel.png**  
   Caption idea: "Visualize heavy spot with the dynamic poising wheel"

4. **04-Isochronism-Table.png**  
   Caption idea: "Isochronism testing: 24-hour rate change analysis"

5. **05-Isochronism-Stats.png**  
   Caption idea: "Color-coded deltas with expert guidelines"

6. **06-Export-Preview.png**  
   Caption idea: "Export professional results images to your camera roll"

For consistent data across screenshots, use the sample values from the previous demo data set (Rolex 3135 examples in Screenshots_Guide.md or earlier git history) or enter realistic readings manually.

### 8. What's New (for v1.0)
"Initial release: Professional timegrapher logging with dynamic poising visuals, isochronism analysis, and one-tap export to camera roll."

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

## Recommended Next Steps (in order)

1. **Verify Team & Signing in Xcode** (do this first - now that you have the Team ID)
2. **Create the app record in App Store Connect**
3. **Upload screenshots** (you already have a set for 6.9")
4. **Fill App Information + description**
5. **Add Privacy Policy** (required by Apple)
   - You do **not** need your own website.
   - Best quick options:
     - **Netlify Drop** (recommended for a clean URL): Drag `Privacy_Policy.html` onto https://app.netlify.com/drop
     - **GitHub Gist**: Paste the content at https://gist.github.com and use the "Raw" link
   - Full instructions are at the bottom of `Privacy_Policy.md`
   - Once you have the URL, go to App Store Connect → App Information → Privacy Policy URL and enter it.
6. **Test on device + Archive & Upload to ASC**
7. **Submit for Review** (or TestFlight first)

This app is in excellent shape for a 1.0 release!

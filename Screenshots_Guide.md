# Timegrapher Logging - App Store Screenshots Guide

## Current Screenshots (as of 2026-06-24)

You have a complete set of 6 screenshots for **iPhone 6.9"** (iPhone 17 Pro Max) in:
`~/Desktop/Timegrapher_Screenshots/iPhone_6.9/`

Files:
01-Main-Table.png
02-Results.png
03-Poising-Wheel.png
04-Isochronism-Table.png
05-Isochronism-Stats.png
06-Export-Preview.png

These are ready for upload. You still need matching sets for 6.5" and 5.5".

### Recommended Final Set

For each device size you need to provide screenshots in App Store Connect:

**Required Device Sizes:**
- iPhone 6.9" (iPhone 16 Pro Max etc.) - 1290 × 2796
- iPhone 6.5" - 1242 × 2688
- iPhone 5.5" - 1242 × 2208

**Ideal 6-8 Screenshots per size** (use the same content across sizes for consistency):

1. **Home / Timepiece + Main Table**  
   Show the Timepiece field + full Position Readings table with data (diagonals enabled).

2. **Main Table + Results**  
   Scroll to show the complete table and the Results section (averages, deltas, vertical drop).

3. **Dynamic Poising**  
   The entire Dynamic Poising section with the balance wheel graphic visible, "Heavy Spot" text, and guidelines.

4. **Isochronism Table**  
   Show the "Isochronism Readings (After 24 Hours)" table, including the Δ column and colored cells.

5. **Isochronism + Results**  
   The isochronism stats in the Results area (24h Average, Rate Change, Max Delta, Amplitude Drop).

6. **Custom Pickers**  
   Lift Angle picker + Beat Rate picker (or custom fields).

7. **Export / Saved Results** (strong one)  
   Either the "Save Timegrapher results to camera roll" button or a screenshot of the exported image in Photos.

8. **Optional**: Full screen with good data visible.

## How to Capture

1. Use Simulator with the exact device.
2. Manually enter realistic sample data (the temporary "Load Demo Data" button has been removed for the release build). Use values from prior demo data if desired for consistency.
3. Use **Cmd + S** to take clean screenshots.
4. For best results:
   - Use light mode
   - Dismiss keyboard
   - Scroll to show full relevant content
   - Take multiple and pick the cleanest

## File Naming Suggestion (for easy upload)

Use this pattern:
`01-Main-Table.png`
`02-Results.png`
`03-Poising-Wheel.png`
`04-Isochronism-Table.png`
`05-Isochronism-Stats.png`
`06-Export.png`

Then duplicate the set into the other size folders.

## Uploading Screenshots to App Store Connect

Screenshots are **not added in Xcode** or inside your app. They are uploaded as marketing material **after** you create the app record.

Steps:
1. Make sure your Apple Developer enrollment is fully approved.
2. Go to [App Store Connect](https://appstoreconnect.apple.com) → My Apps.
3. Create New App using Bundle ID `com.danricks.timegrapher-logging`.
4. In the new app → **App Store** tab → **iPhone Screenshots** section.
5. Upload the PNGs from the folders (one set per device size).

We have already prepared:
- Organized files in `~/Desktop/Timegrapher_Screenshots/`
- Detailed guide in `Screenshots_Guide.md` (in this project folder)

See the main `PUBLISHING.md` for the full step-by-step after you have the app record.

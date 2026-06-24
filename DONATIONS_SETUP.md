# Donations & Free App Setup

This app is provided completely free with **no ads and no in-app purchases**.

## How Donations Work

- A "Support Development" section is included at the bottom of the main screen.
- Tapping it opens your PayPal donation page in Safari.
- This is fully compliant with App Store guidelines because:
  - No features are locked behind payment.
  - All core functionality is free.
  - Donations are entirely optional.

## How to Set Your PayPal Link

1. Open `ContentView.swift`
2. Find this line (around line 980 area):
   ```swift
   Link(destination: URL(string: "https://paypal.me/DanRicks444")!)
   ```
3. The link is already set to your PayPal ID (DanRicks444). If you want to suggest a specific amount, you can change it to:
   `https://paypal.me/DanRicks444/5` (suggests $5 donation)

## App Store Description Wording

Use this kind of language in your App Store description:

"This app is 100% free with no ads or subscriptions.  
If you find it useful, optional donations via PayPal are greatly appreciated."

See `AppStore_Listing_Copy.txt` for the full polished description.

## Best Practices

- Be transparent: Clearly state the app is free.
- Don't pressure users.
- Consider adding a "Thank you" message or list of recent supporters later if you want.
- You can also add a link to your website or Ko-fi/BuyMeACoffee if you prefer other platforms.

## Legal / Tax Note

Donations received may be considered taxable income depending on your country. Keep records.


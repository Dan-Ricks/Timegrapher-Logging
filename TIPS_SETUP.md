# Tips & Free App Setup

This app is provided completely free with **no ads and no subscriptions**. Tips are offered via In-App Purchase.

## How Tips Work

- A "Support Development" section is included at the bottom of the main screen.
- Users can tap buttons to purchase small tip amounts using In-App Purchase (consumable).
- This is fully compliant with App Store guidelines (see 3.1.1).
- No features are locked behind payment.
- All core functionality is free.
- Tips are entirely optional.

## Setting Up In-App Purchases in App Store Connect

1. In App Store Connect, go to your app > In-App Purchases > Create New.
2. Create consumable IAPs:
   - ID: `tip099` - Price Tier 1 ($0.99) - Display Name: "Tip $0.99"
   - ID: `tip199` - Price Tier 2 ($1.99) - Display Name: "Tip $1.99"
   - ID: `tip499` - Price Tier 4 ($4.99) - Display Name: "Tip $4.99"
3. Submit for review (along with the app).

## In Code

The products are loaded with IDs "tip099", "tip199", "tip499".
Buttons show the localized price and trigger purchase.

See `ContentView.swift` for the implementation.

## App Store Description Wording

Use this kind of language:

"This app is 100% free with no ads or subscriptions.  
If you find it useful, optional tips are greatly appreciated."

See `AppStore_Listing_Copy.txt` for the full polished description.

## Best Practices

- Be transparent: Clearly state the app is free.
- Don't pressure users.
- Consider adding a "Thank you" message after purchase.

## Legal / Tax Note

Tips received may be considered taxable income depending on your country. Keep records. Apple takes a cut on IAP.


# Hardcodes
Hardcodes directory is a place for hardcoded values mostly for promotions.

This hardcodes directory exists to keep the hardcoded values in one place, so that they can be easily managed and updated.
It is also meant to be temporary, NOT PERMANENT, and should be removed once the backend has the sufficient functionality to create different promotions.

## Step by Step
1. Create a new directory under `lib/hardcodes/promotions` with the name of the promotion and the start date of the promotion.
2. Create a new class with mostly static values that defines the promotions: what qualifies to get the promotion, the banner image url, the rewards, etc.
3. Most promotions will show up as a side panel in CartPage (`lib/presentation/pages/cart/index.dart`), so define a SidePanel widget that will show the promotion.

You can see other promotions for examples.

## Good to Know
Promotions are involved in `HomePageBanner`, `DesktopPromotionPage`, and `HomePromotionBannerData`.
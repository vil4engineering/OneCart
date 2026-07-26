# Product flow

## Positioning vs Apple Family

| Allowed | Forbidden |
|---------|-----------|
| Soft line “Made for families on Apple” / “Для семьи на Apple” | Claiming Family Sharing membership APIs |
| CloudKit + `CKShare` + system Share Sheet | Public join ACL (`publicPermission` permissive) |
| Private invite via Messages / AirDrop / Mail | “Share with entire Apple Family in one API call” |

**Missing Apple APIs (do not invent):** list Family members, verify two users share a Family, push share to whole Family.

Apple Family does **not** merge carts by itself — participants need an in-app `CKShare` invite.

## Technical invite path

```text
Create shared list → Create CKShare (publicPermission = .none)
  → System Share Sheet → Messages / AirDrop / Mail → Accept
```

Legacy `onecart://invite/...` tokens and the old invite endpoint are gone.

## User flow

1. Install → Welcome: Sign in with Apple + short onboarding copy (iCloud errors + Retry on the same screen).
2. After sign-in → main screen with one household cart (`isHouseholdDefault`, «Наши покупки» / localized). Empty until the user adds products.
3. If iCloud already has a cart for this account, show that cart instead of creating a duplicate empty one when possible.
4. Invite from Settings → Members → Invite (system Share Sheet).
5. Invitee: SIWA → open share link → Accept in iCloud → **active cart is replaced** by the shared family cart (empty private starter archived; private items with content auto-merged into shared, then private archived). No merge sheet.

Up to four people share one list; changes sync via CloudKit.

## Account and profile

- Session: Sign in with Apple credentials in Keychain.
- Sync: requires iCloud on device (`CKContainer.accountStatus`). No email/password forms.
- Display name, avatar, banner: **device-local** — not in CloudKit, not in migration.

## Default cart identity

- Display: localized `cart.default_title` («Наши покупки» / «Наші покупки» / Our shopping)
- Identity: `isHouseholdDefault`
- Legacy names `"Наша семья"` / `"Наша группа"` migrated once to the flag

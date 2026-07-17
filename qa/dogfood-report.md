# Dogfood Report: OneCart

| Field | Value |
|-------|-------|
| Date | 2026-07-16 |
| App URL | http://127.0.0.1:4173 |
| Final session | onecart-revision |
| Final bundle | index-CZnui-VL.js |
| Scope | Full local interactive prototype plus store marks, history layout, themes and Capacitor/Xcode shell |

## Summary

| Severity | Count |
|----------|-------|
| Critical | 0 |
| High | 0 |
| Medium | 0 |
| Low | 0 |
| Total | 0 |

## Issues

No unresolved reproducible issues remain in the tested scope.

## Verified flows

- Splash and three-step onboarding into the seeded home state.
- Hash navigation, active bottom-navigation states and reload persistence through `localStorage`.
- General/store lists, frequent-product destination selection, product add, swipe purchase/undo and swipe delete/undo.
- Standard and custom store setup, URL validation, optional active-list creation and direct list creation.
- Exact-list sharing, invitations, roles and member persistence.
- History details and repeat purchase without duplicate active lists.
- Store-list More sheet, pin action, store management and official-link action.
- Notifications, RU/UK settings, JSON backup and protected CSV generation.
- Offline banner and continued access to locally stored data.
- Keyboard/dialog focus paths, reduced motion and the Clear History deep-link at 320×400 with 200% text.

## Viewports and evidence

- 390×844 mobile: `qa/screenshots/final-home-390.png`
- 768×1024 tablet: `qa/screenshots/final-home-768.png`
- 320×400, 200% text, reduced motion: `qa/screenshots/final-clear-history-320x400-200.png`
- Final browser console errors: 0
- Final browser console messages: 0

## First revision verification

- Original inline SVG marks are used for АТБ, Сільпо, Auchan, NOVUS, VARUS, Фора and METRO; custom stores retain a monogram fallback.
- Purchase-history date, store identity and actions no longer overlap at 390×844.
- Light, dark and system theme preferences persist locally; the system option reacts live to both light and dark media preferences.
- Capacitor synced the current production bundle into the iOS project.
- Xcode Debug build for the generic iOS Simulator completed successfully with code signing disabled.
- Revision screenshots:
  - `qa/screenshots/first-revision/store-catalog-icons-final.png`
  - `qa/screenshots/first-revision/history-date-final.png`
  - `qa/screenshots/first-revision/settings-dark-final.png`

## Resolved during dogfooding

Destination-list fallbacks, duplicate active lists, sharing persistence, placeholder exports, dialog focus cleanup, onboarding target size, narrow-view bottom navigation and the Clear History focus target were corrected and rechecked before this report was closed.

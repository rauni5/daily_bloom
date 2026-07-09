# Daily Bloom — Wellness Quotes App

A Flutter app where an Admin curates quotes by category/author, and a User
picks the categories they care about and receives a personalized feed,
favorites, a streak-tracked profile, and a mini-game — built to practice
form handling, navigation, CRUD, and end-to-end data flow from Admin to User.

## Getting Started

```
flutter pub get
flutter run -d chrome     # or any connected device/emulator
```

Admin panel is reachable from Profile → Admin Panel. Password: `admin123`.

## Tech / Architecture

- State management: `provider` (`ChangeNotifier` via `AppState`)
- All data (categories, authors, quotes, current user) lives in-memory in
  `AppState`, seeded from `lib/data/seed_data.dart`
- Responsive layout: side `NavigationRail` + multi-column quote grid on
  tablet/desktop/web widths, original bottom-tab single-column layout on
  phones (see `lib/utils/responsive.dart`)

## Implemented

**User side**
- Splash screen → Login/Signup (client-side validation: empty fields,
  email format, password match) → Preference Picker (min. 3 categories)
- Home / "For You" feed: quotes from preferred categories interleaved with
  a wildcard quote from an unselected category, plus live search and
  category filter chips (Section 6.1: *Wildcard discovery slot*)
- Quote Detail: full quote, author info, categories, favorite toggle,
  external "Learn More" link to the author's Wikipedia page
- Author deep-dive: tapping an author on Quote Detail opens their bio and
  every quote by them (Section 6.4: *Author deep-dive*)
- Favorites list
- Game Mode — **Quote Quest**, two modes with shared score/streak state:
  - *Guess the Author* — quote shown, pick the correct author from 4
  - *Complete the Quote* — quote shown with a word blanked out, pick the
    correct word from 3 options
- Profile: name (set at login/signup), XP, game score, streak, favorite
  count, dark/light theme toggle, entry point to Admin Panel

**Admin side**
- Admin login (password-gated)
- Dashboard: live counts (categories/authors/quotes/published) and a
  quotes-per-category bar chart
- Categories CRUD (add/edit/delete)
- Authors CRUD (add/edit/delete)
- Quotes CRUD — text, author (dropdown), categories (multi-select chips),
  draft/published status, has-image/has-audio flags
- Admin → User data loop: publishing a quote in Admin makes it appear
  immediately in the User Home feed (the core lesson of the assignment)

## Future Work

Scoped out to keep the build focused; listed here per the assignment's
Section 6 instruction to name unbuilt "broaden your thinking" features
rather than build all of them.

- **Explore screen** — dedicated By Category / By Author / Trending tabs
  (Home currently covers search + category filtering only)
- **Mood Check-in** — daily mood prompt that temporarily re-ranks the feed
- **Collections** — named, organizable groups of saved quotes beyond the
  current flat Favorites list
- **Share quote as image**
- **Real audio narration / background images** — quotes currently store
  `hasImage`/`hasAudio` as booleans rather than actual media files
- **Game Mode C — Mood Match** — the third game mode from the spec
- **XP levels** ("Seedling → Sprout → Bloom → Evergreen"), streak
  multipliers, unlockable quote packs
- **Admin: Users screen** — view/deactivate registered users
- **Admin: Game Content CRUD** — author `GameItem`s instead of generating
  game questions from existing quotes in code
- **Offline "Quote Jar"** — cache the last 20 fetched quotes for
  local/offline use
- **Smart notification timing** — learn the user's most active hour
  instead of a fixed daily reminder time
- **Accessibility mode** — larger type + audio-first navigation
- **Quote of the Day home-screen widget** — concept only, not built

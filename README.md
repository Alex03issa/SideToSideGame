# Side To Side

A portrait-mode arcade game for Android/iOS built with Flutter and the Flame engine, where you drag the character around the screen to collect embers and dodge obstacles over a vertically scrolling parallax background.

## Overview

Side To Side is a mobile game project from November 2024. It started from the official Flutter Casual Games Toolkit **Endless Runner** template (Flame) and was reworked into a portrait game:

- the camera uses a fixed **720 x 1600** portrait resolution and the app locks the device to portrait,
- the tap-to-jump mechanic was replaced by **drag-to-move** controls (the player is moved freely with a finger and clamped to the visible play area),
- the parallax background scrolls **vertically** using custom scenery layers, and obstacles and embers fall from the top of the screen to match,
- new **Profile**, **Sign In**, **Sign Up** and **Skins** screens were added to the menu flow, with their own colour palette.

## Features

- Main menu with Play, Settings and Profile, plus an audio on/off toggle
- Level selection with two levels (win score 3 and 5; level 2 can spawn tall obstacles) and saved progress/best times
- Gameplay: drag the character anywhere on the screen to collect embers (points) and dodge obstacles that fall from the top; touching an obstacle resets the score
- Win dialog when the level's ember target is reached
- Vertical multi-layer parallax background
- Background music and sound effects (score, damage, button clicks) via `flame_audio` / `audioplayers`
- Settings screen (player name, music/sound toggles) persisted with `shared_preferences`
- Profile screen, Sign In / Sign Up forms and a Skins screen with player and background skin tabs (UI only — no authentication backend is wired up yet)
- Retro NES-style UI (`nes_ui`) with the Press Start 2P font

## Tech Stack

- Flutter (Dart SDK ^3.3)
- [Flame](https://flame-engine.org/) game engine + `flame_audio`
- `go_router` for navigation, `provider` for state
- `shared_preferences` for persistence
- `nes_ui`, `google_fonts`
- `flutter_launcher_icons` for app icons

## Project Structure

```
lib/
├── main.dart                     # App entry, providers, theme, portrait lock
├── router.dart                   # go_router routes (menu, play, settings, profile/*)
├── flame_game/
│   ├── endless_runner.dart       # FlameGame: camera, score HUD, background
│   ├── endless_world.dart        # World: spawning obstacles/points, scoring, win logic
│   ├── game_screen.dart          # GameWidget + overlays
│   ├── components/               # player (drag controls), obstacle, point, background
│   └── effects/                  # hurt effect
├── level_selection/              # Levels and level selection screen
├── main_menu/                    # Main menu
├── profile/                      # Profile, sign-in, sign-up, skins screens
├── settings/                     # Settings + persistence
├── player_progress/              # Level progress + persistence
├── audio/                        # Audio controller, songs, sfx
└── style/                        # Palette, responsive layout, transitions
assets/                           # Sprites, scenery, skins, music, sfx, fonts
test/smoke_test.dart              # Widget/game smoke test
android/ ios/ web/ linux/ macos/ windows/   # Platform runners
```

## Getting Started

Prerequisites: [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.19+ and an Android emulator/device (or Xcode for iOS).

```bash
git clone https://github.com/Alex03issa/SideToSideGame.git
cd SideToSideGame
flutter pub get
flutter run
```

Run tests:

```bash
flutter test
```

Regenerate launcher icons from `assets/icons/icon.png` (optional):

```bash
dart run flutter_launcher_icons
```

## Notes

- Sign In / Sign Up / Profile are front-end screens only; the profile shows placeholder name and best-score values.
- Music tracks are CC0 from OpenGameArt (see `assets/music/CREDITS.TXT`); base sprites and template structure come from the Flutter Endless Runner template.
- The Dart package is `side_to_side` and the Android application id / iOS bundle id is `com.alexissa.sidetoside` (renamed from the template's `com.example.endless_runner`; change it before publishing to a store if you prefer another id). The desktop and web runners still use the template's `endless_runner` binary name.
- Some deeply nested Android files (`MainActivity.kt`, launch background, styles, launcher icons) were restored from the standard Flutter template when preparing this repository. Run `dart run flutter_launcher_icons` to apply the custom icon in `assets/icons/icon.png`.

## Branches

- `main` — the current drag-to-move version (this README). Continue development here.
- `wadih-nov-2024` — Wadih's November 2024 experiment with jumping onto platforms, kept for reference. It does not build as-is (`my_game.dart` is missing).

## Authors

A joint project by **Alexander Issa** ([@Alex03issa](https://github.com/Alex03issa)) and **Wadih Issa**:

- **Wadih Issa** built the core gameplay (the Flame game world, player, obstacles and scoring).
- **Alexander Issa** built the settings, profile, sign-in/sign-up and skins screens, and is continuing development of the game.

The game's back-end (accounts and API) lives in a separate repository: [InternshipProject](https://github.com/Alex03issa/InternshipProject).

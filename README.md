# zemyblue/tap

**English** | [한국어](ko/README.md)

zemyblue's Homebrew tap. It carries one program: **deckhand**, the Mac app for the cmux / Claude Code macro keypad.

User guide (keys, screen, LEDs, troubleshooting): <https://zemyblue.github.io/deckhand-guide/>

## Install

```sh
brew install zemyblue/tap/deckhand
deckhand doctor        # checks the install (cmux, session files, ...)
```

- macOS only. Homebrew installs Python with it, so there is nothing else to prepare.
- No `brew` command? Install [Homebrew](https://brew.sh) first.
- **Start at login (recommended)**: `deckhand setup`. It shows what it will change and asks before doing it:
  it switches cmux's access mode to `automation` (one marked line in `~/.config/cmux/cmux.json`) and adds a login item.
  It does not take up a cmux tab. To undo: `deckhand uninstall`
- Without setup, run it from a terminal inside cmux (by default cmux only accepts programs started inside it).
- If the keypad was showing the install guide and a QR code, it switches to the session list a few seconds after
  `deckhand setup` finishes.
- To look around without a keypad: `deckhand simulate --web --demo` (made-up sessions, cmux is not touched)

## Update

```sh
brew upgrade deckhand
brew services restart deckhand   # if setup runs it in the background (otherwise the new version starts at next login)
```

## This repository

- `Formula/<program>.rb`: one install recipe per program. The deckhand source bundle is in this repository's
  Releases (`v<version>`).
- Prebuilt installs (bottles) are made by GitHub Actions: `brew test-bot` builds on a pull request that changes a
  formula, and the `brew pr-pull` workflow uploads the bottle to Releases and commits the `bottle do` block.

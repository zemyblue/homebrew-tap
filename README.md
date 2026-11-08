# zemyblue/tap

zemyblue의 Homebrew tap입니다. 지금 들어 있는 프로그램: **deckhand** (cmux / Claude Code 매크로 키패드의 Mac 프로그램).

## 설치

```sh
brew install zemyblue/tap/deckhand
deckhand doctor        # 설치 점검 (cmux, 세션 파일 등)
```

- macOS 전용입니다. Python은 Homebrew가 함께 설치하므로 따로 준비할 것이 없습니다.
- **로그인할 때 자동으로 켜기 (추천)**: `deckhand setup`. 무엇을 바꾸는지 보여 주고 동의를 받은 뒤
  cmux 접근 방식을 `automation`으로 바꾸고(`~/.config/cmux/cmux.json`에 표시된 한 줄) 로그인 항목을 등록합니다.
  cmux 탭을 차지하지 않습니다. 되돌리기: `deckhand uninstall`
- setup 없이 쓸 때는 cmux 안의 터미널에서 실행합니다(cmux 기본 설정은 cmux 안에서 시작한 프로그램만 받음).
- 키패드 없이 둘러보기: `deckhand simulate --web --demo` (가상 세션, cmux를 건드리지 않음)

## 업데이트

```sh
brew upgrade deckhand
brew services restart deckhand   # setup으로 백그라운드 실행 중이면 (안 하면 다음 로그인 때 새 버전으로 켜짐)
```

## 이 저장소

- `Formula/<프로그램>.rb`: 프로그램마다 설치 방법 파일 하나. deckhand 소스 묶음은 이 저장소의 Releases(`v<버전>`)에 있습니다.
- 미리 만든 설치본(bottle)은 GitHub Actions가 만듭니다: formula를 바꾸는 PR에서 `brew test-bot`이 빌드하고,
  `brew pr-pull` 워크플로가 Releases에 올리고 `bottle do` 블록을 커밋합니다.

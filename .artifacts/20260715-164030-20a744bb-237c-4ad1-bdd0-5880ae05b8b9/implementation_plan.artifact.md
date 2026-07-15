# Project Size Reduction Plan

The project is currently ~5GB compressed due to accumulated build artifacts (~7GB) and these artifacts being accidentally tracked in Git history (~1.2GB). This plan aims to clean the project and optionally reset the Git repository to achieve a minimal footprint.

## User Review Required

> [!IMPORTANT]
> - **Git Reset**: I propose deleting the `.git` folder and re-initializing it to permanently remove 1.2GB of build history. This will erase all 12 previous commits. Please confirm if you are okay with losing this history.
> - **Flutter Clean**: Running `flutter clean` will delete all build outputs. You will need to re-build the app the next time you run it.

## Proposed Changes

### Maintenance Tasks

#### Flutter Cleanup
- Execute `flutter clean` to remove current build artifacts in `/build/`, `/android/build/`, and `/android/app/build/`.

#### Git Optimization (Recommended)
- Delete the `.git` directory.
- Run `git init` to start a fresh repository.
- Ensure `.gitignore` is correctly preventing future build artifact tracking.
- Create an initial "Clean state" commit.

#### Additional Cleanup
- Remove `.dart_tool/` folder.
- Remove `android/.gradle/` folder.

---

## Verification Plan

### Manual Verification
- **Size Check**: Use PowerShell commands to verify that the project size has dropped from ~7GB to < 50MB (excluding Git if reset).
- **Git Status**: Verify that `git status` does not show any files from `build/` or `android/**/build/` being tracked.
- **Build Verification**: Run `flutter pub get` to ensure the project still functions correctly after cleaning.

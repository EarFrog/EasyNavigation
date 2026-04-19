# EasyNavigation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a standalone `EasyNavigation` HarmonyOS repository with a reusable HAR navigation library and an example app that validates multi-level route flows.

**Architecture:** Reuse the current single-root `Navigation` abstraction, package it inside `library/` as a HAR module, and consume it from `example/` through a file dependency. Keep the example intentionally small so each route flow is obvious in both code and runtime behavior.

**Tech Stack:** ArkTS, ArkUI `Navigation` / `NavPathStack`, HarmonyOS stage model modules, HAR local dependency

---

## File Map

- Create: `library/Index.ets`
- Create: `library/hvigorfile.ts`
- Create: `library/build-profile.json5`
- Create: `library/oh-package.json5`
- Create: `library/src/main/module.json5`
- Create: `library/src/main/ets/navigation/RouteTypes.ets`
- Create: `library/src/main/ets/navigation/RouteRegistry.ets`
- Create: `library/src/main/ets/navigation/NavigationManager.ets`
- Create: `library/src/main/ets/navigation/EasyNavigation.ets`
- Create: `example/hvigorfile.ts`
- Create: `example/build-profile.json5`
- Create: `example/oh-package.json5`
- Create: `example/src/main/module.json5`
- Create: `example/src/main/ets/entryability/EntryAbility.ets`
- Create: `example/src/main/ets/entrybackupability/EntryBackupAbility.ets`
- Create: `example/src/main/ets/pages/Index.ets`
- Create: `example/src/main/ets/pages/Home.ets`
- Create: `example/src/main/ets/pages/Detail.ets`
- Create: `example/src/main/ets/pages/SecondDetail.ets`
- Create: `example/src/main/ets/pages/ResultPage.ets`
- Modify: `build-profile.json5`
- Modify: `oh-package.json5`
- Modify: `AppScope/app.json5`
- Modify: `AppScope/resources/base/element/string.json`
- Modify: `README.md`

## Verification Baseline

Primary build verification:

```bash
cd example && ohpm install
cd ..
hvigorw assembleHap --mode module -p module=example@default -p product=default -p buildMode=debug --no-daemon
```

Manual runtime verification:
- Launch the example app and confirm the root page is `Home`.
- Tap `Open Detail` and confirm params render on the detail page.
- Tap `Open Second Detail` and confirm the second-level params render.
- Tap `Pop To Home` and confirm the stack returns directly to the root page.
- Tap `Open Result Page For Result` and confirm `Home` shows the returned payload.
- Tap `Replace With Result Page` from detail and confirm the page replaces detail, then `pop(result)` safely returns to home.

### Task 1: Wire the repository modules

**Files:**
- Modify: `build-profile.json5`
- Create: `library/hvigorfile.ts`
- Create: `library/build-profile.json5`
- Create: `library/oh-package.json5`
- Create: `library/src/main/module.json5`
- Create: `example/hvigorfile.ts`
- Create: `example/build-profile.json5`
- Create: `example/oh-package.json5`
- Create: `example/src/main/module.json5`
- Modify: `AppScope/app.json5`
- Modify: `AppScope/resources/base/element/string.json`

- [ ] Write the module metadata so the repo contains one HAR module (`library`) and one entry module (`example`).
- [ ] Point `example/oh-package.json5` at the HAR with `"@easy/navigation": "file:../library"`.
- [ ] Rename the copied application metadata from `ImageComponent` to `EasyNavigation`.
- [ ] Run the example build once to expose any missing-module errors before feature code is added.

### Task 2: Implement the HAR navigation layer

**Files:**
- Create: `library/Index.ets`
- Create: `library/src/main/ets/navigation/RouteTypes.ets`
- Create: `library/src/main/ets/navigation/RouteRegistry.ets`
- Create: `library/src/main/ets/navigation/NavigationManager.ets`
- Create: `library/src/main/ets/navigation/EasyNavigation.ets`

- [ ] Port the current route payload, route record, and init option contracts into the HAR.
- [ ] Port the route registry and keep duplicate-route validation.
- [ ] Port the single-root `NavigationManager`, removing app-specific logger dependencies.
- [ ] Rename the root component export to `EasyNavigation` while preserving the current stack-binding behavior.
- [ ] Export the public API from `library/Index.ets` so the example app consumes the package like a real downstream project.

### Task 3: Build the example route flow

**Files:**
- Create: `example/src/main/ets/entryability/EntryAbility.ets`
- Create: `example/src/main/ets/entrybackupability/EntryBackupAbility.ets`
- Create: `example/src/main/ets/pages/Index.ets`
- Create: `example/src/main/ets/pages/Home.ets`
- Create: `example/src/main/ets/pages/Detail.ets`
- Create: `example/src/main/ets/pages/SecondDetail.ets`
- Create: `example/src/main/ets/pages/ResultPage.ets`

- [ ] Set up `Index.ets` with a centralized route table that imports from `@easy/navigation`.
- [ ] Keep `Home.ets` focused on the demo entry points and result display.
- [ ] Keep `Detail.ets` focused on first-level params plus `push` and `replace` actions.
- [ ] Keep `SecondDetail.ets` focused on second-level params plus `pop` and `popTo`.
- [ ] Keep `ResultPage.ets` focused on returning a typed result payload and showing whether the route was opened via `pushForResult`.

### Task 4: Document consumer usage

**Files:**
- Modify: `README.md`

- [ ] Document the repository layout.
- [ ] Document the public HAR API.
- [ ] Document the example flows and the build command.

### Task 5: Verify and commit

**Files:**
- Modify: repository files listed above

- [ ] Run the example app build command and confirm exit code `0`.
- [ ] Run `git status --short` and `git diff --check` to confirm the final tree is cleanly authored.
- [ ] Commit the docs and implementation in focused commits.

# EasyNavigation

A standalone HarmonyOS component repository that packages a lightweight, route-table-driven navigation layer as a HAR library and ships an example app to validate the main route flows.

## Repository Layout

- `library/`: reusable HAR package
- `example/`: consumer-style demo app
- `docs/superpowers/specs/2026-04-18-easy-navigation-design.md`: design record
- `docs/superpowers/plans/2026-04-18-easy-navigation.md`: implementation plan

## Library API

```ts
import {
  EasyNavDestinationOptions,
  EasyNavigation,
  EasyNavigationOptions,
  NavigationManager,
  RoutePayload,
  RouteRecord,
  createRoute
} from '@easy/navigation'

const detailDestination: EasyNavDestinationOptions = {
  hideTitleBar: false,
  mode: NavDestinationMode.STANDARD,
  title: {
    value: 'Detail'
  },
  onShown: () => console.info('Detail shown'),
  onHidden: () => console.info('Detail hidden'),
  onBackPressed: () => false
}

@Builder
function buildDialogTitle() {
  Row({ space: 8 }) {
    Text('Result').fontSize(18).fontWeight(FontWeight.Bold)
    Text('custom title').fontSize(12)
  }
}

const dialogDestination: EasyNavDestinationOptions = {
  hideTitleBar: false,
  mode: NavDestinationMode.DIALOG,
  title: {
    value: wrapBuilder(buildDialogTitle)
  }
}

const navigationOptions: EasyNavigationOptions = {
  hideNavBar: false,
  title: {
    value: 'EasyNavigation'
  },
  menus: [
    {
      value: 'Home',
      action: () => NavigationManager.popTo('home')
    }
  ],
  onTitleModeChange: (titleMode: NavigationTitleMode) => {
    console.info(`title mode changed ${titleMode}`)
  },
  onNavBarStateChange: (isVisible: boolean) => {
    console.info(`nav bar visible ${isVisible}`)
  }
}

const routes: RouteRecord[] = [
  createRoute('home', wrapBuilder(buildHomeRoute)),
  createRoute('detail', wrapBuilder(buildDetailRoute), detailDestination),
  createRoute('second-detail', wrapBuilder(buildSecondDetailRoute)),
  createRoute('result-page', wrapBuilder(buildResultRoute), dialogDestination)
]

EasyNavigation({
  routes,
  root: 'home',
  options: navigationOptions
})
```

Route-level `EasyNavDestinationOptions` supports `hideTitleBar`, `mode`, `title`, `onReady`,
`onBackPressed`, and the common `NavDestination` visibility callbacks:
`onWillAppear`, `onAppear`, `onWillShow`, `onShown`, `onWillHide`, `onHidden`,
`onWillDisappear`, and `onDisAppear`.

Container-level `EasyNavigationOptions` supports `hideNavBar`, `title`, `menus`,
`toolbar`, `enableToolBarAdaptation`, `onTitleModeChange`, `onNavBarStateChange`,
and `onNavigationModeChange`.

Navigation actions:

```ts
NavigationManager.push('detail', { id: 'A-100' })
NavigationManager.replace('result-page', { source: 'detail' })
NavigationManager.pop()
NavigationManager.pop({ confirmed: true })
NavigationManager.popTo('home')
const result = await NavigationManager.pushForResult<ResultPayload>('result-page', { source: 'home' })
```

## Example Flows

The example app provides both a Chinese demo and an English demo. The root page lets you choose `中文示例` or `English Demo`.

Each language version verifies:
- demo home -> detail
- detail -> second detail
- second detail -> `popTo()` back to that language's demo home
- demo home -> result dialog -> `pop(result)`
- detail -> `replace()` with result dialog
- route-level `NavDestination` title bar configuration
- route-level custom `NavTitle` for dialog pages
- container-level `Navigation` title and menu configuration
- route-level `NavDestination` shown/hidden lifecycle callbacks

## Build

Set `DEVECO_SDK_HOME` to your local DevEco SDK, install the local HAR dependency, then run:

```powershell
Set-Location -LiteralPath 'D:\code\EasyNavigation\example'
& 'D:\IDEA\DevEco Studio\tools\ohpm\bin\ohpm.bat' install

Set-Location -LiteralPath 'D:\code\EasyNavigation'
$env:DEVECO_SDK_HOME='D:\IDEA\DevEco Studio\sdk'
& 'D:\IDEA\DevEco Studio\tools\hvigor\bin\hvigorw.bat' assembleHap --mode module -p module=example@default -p product=default -p buildMode=debug --no-daemon
```

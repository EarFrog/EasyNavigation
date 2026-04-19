# EasyNavigation

A standalone HarmonyOS component repository that packages a lightweight, route-table-driven navigation layer as a HAR library and ships an example app to validate the main route flows.

## Repository Layout

- `library/`: reusable HAR package
- `example/`: consumer-style demo app
- `docs/superpowers/specs/2026-04-18-easy-navigation-design.md`: design record
- `docs/superpowers/plans/2026-04-18-easy-navigation.md`: implementation plan

## Library API

```ts
import { EasyNavigation, NavigationManager, RoutePayload, RouteRecord, createRoute } from '@easy/navigation'

const routes: RouteRecord[] = [
  createRoute('home', wrapBuilder(buildHomeRoute)),
  createRoute('detail', wrapBuilder(buildDetailRoute)),
  createRoute('second-detail', wrapBuilder(buildSecondDetailRoute)),
  createRoute('result-page', wrapBuilder(buildResultRoute))
]

EasyNavigation({
  routes,
  root: 'home'
})
```

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

The example app verifies:
- `Home -> Detail`
- `Detail -> SecondDetail`
- `SecondDetail -> popTo('home')`
- `Home -> ResultPage -> pop(result)`
- `Detail -> replace('result-page')`

## Build

Set `DEVECO_SDK_HOME` to your local DevEco SDK, install the local HAR dependency, then run:

```powershell
Set-Location -LiteralPath 'D:\code\EasyNavigation\example'
& 'D:\IDEA\DevEco Studio\tools\ohpm\bin\ohpm.bat' install

Set-Location -LiteralPath 'D:\code\EasyNavigation'
$env:DEVECO_SDK_HOME='D:\IDEA\DevEco Studio\sdk'
& 'D:\IDEA\DevEco Studio\tools\hvigor\bin\hvigorw.bat' assembleHap --mode module -p module=example@default -p product=default -p buildMode=debug --no-daemon
```
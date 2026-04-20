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



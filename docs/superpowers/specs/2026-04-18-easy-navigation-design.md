# EasyNavigation Design

## Summary

EasyNavigation is a standalone HarmonyOS component repository that extracts the lightweight, route-table-driven navigation layer from the current app into a reusable HAR package.

The first release includes:
- a reusable HAR library with `EasyNavigation`, `NavigationManager`, `createRoute`, and route payload types
- an `example` app that consumes the HAR package through a local file dependency
- demo flows that verify first-level navigation, second-level navigation, `replace`, `pop`, `popTo`, and `pushForResult` / `pop(result)`

The goal is not to recreate `ohrouter` as a full framework. The goal is to provide a small, stable, easy-to-adopt navigation package that keeps the API surface focused.

## Repository Structure

- `library/`
  HAR module that exports the navigation runtime and route helpers
- `example/`
  Stage model example app that integrates the HAR package the same way a consumer project would
- `docs/`
  Design and implementation records for the repository
- `README.md`
  Quick-start usage plus demo verification paths

## Library API

The HAR package exposes a small route-table API:

```ts
EasyNavigation({
  routes,
  root: 'home'
})

NavigationManager.push('detail', params)
NavigationManager.pushForResult<ResultPayload>('result-page', params)
NavigationManager.replace('result-page', params)
NavigationManager.pop()
NavigationManager.pop(result)
NavigationManager.popTo('home')
NavigationManager.canPop()
NavigationManager.getCurrentRoute()
NavigationManager.getParams<DetailParams>()
```

Route registration stays centralized and explicit:

```ts
const routes: RouteRecord[] = [
  createRoute('home', wrapBuilder(buildHomeRoute)),
  createRoute('detail', wrapBuilder(buildDetailRoute)),
  createRoute('second-detail', wrapBuilder(buildSecondDetailRoute)),
  createRoute('result-page', wrapBuilder(buildResultRoute))
]
```

## Internal Design

### EasyNavigation

`EasyNavigation` is the root ArkUI component that owns the single `NavPathStack`, binds it into `NavigationManager`, and dispatches `navDestination` lookups through the route registry.

### NavigationManager

`NavigationManager` is a singleton facade around the current root stack. It validates route names, maintains the active route payload, and manages pending promise resolvers for `pushForResult`.

### RouteRegistry

`RouteRegistry` keeps route names and wrapped builders in a focused map. It rejects empty or duplicate names during initialization.

### RoutePayload

Each pushed page receives a normalized payload:

```ts
interface RoutePayload<T = Object> {
  routeName: string
  params?: T
  requestId?: string
}
```

`requestId` is only populated for `pushForResult` flows.

## Example Validation Flows

The example app must cover these flows:

1. `Home -> Detail`
   Validate `push` with params.
2. `Detail -> SecondDetail`
   Validate a second-level page push.
3. `SecondDetail -> popTo('home')`
   Validate direct unwind to the root route.
4. `Home -> ResultPage -> pop(result)`
   Validate `pushForResult` and result delivery.
5. `Detail -> replace('result-page')`
   Validate `replace` and confirm `pop(result)` is still safe when nobody is awaiting a result.

## Error Handling

The first release enforces these rules:
- Unknown route names throw immediately and log an error.
- Duplicate route registrations throw during initialization.
- `popTo()` returns `false` when the target route is missing.
- `pop()` returns `false` on the root page instead of crashing.
- Pending `pushForResult` entries are resolved with `undefined` if the stack is torn down or the current request is invalidated by `replace`.
- Unknown destinations render a simple fallback page instead of crashing the app shell.

## Out of Scope

The first release intentionally excludes:
- multiple navigation stacks
- nested child stacks
- interceptors
- page lifecycle extension hooks
- custom transition animation APIs
- annotation scanning or code generation
- URL/deep-link parsing

## Verification

Primary verification for the repository is installing the example app's local HAR dependency, then running a successful example app build:

```bash
cd example && ohpm install
cd ..
hvigorw assembleHap --mode module -p module=example@default -p product=default -p buildMode=debug --no-daemon
```

Manual runtime verification focuses on the five example flows above.
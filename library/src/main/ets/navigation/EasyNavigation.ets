import { NavigationManager } from './NavigationManager';
import { EasyNavDestinationOptions, EasyNavigationOptions, RoutePayload, RouteRecord } from './RouteTypes';

@Component
export struct EasyNavigation {
    @Require routes: RouteRecord[];
    @Require root: string;
    options?: EasyNavigationOptions;

    private readonly pathStack: NavPathStack = new NavPathStack();

    aboutToAppear(): void {
        NavigationManager.init({
            routes: this.routes,
            root: this.root
        });
        NavigationManager.bindStack(this.pathStack);
    }

    aboutToDisappear(): void {
        NavigationManager.unbindStack(this.pathStack);
    }

    private activePayload(name: string, param?: Object): RoutePayload<Object> {
        const payload = param as RoutePayload<Object> | undefined;
        const activePayload: RoutePayload<Object> = payload ?? { routeName: name };
        NavigationManager.setCurrentRoute(activePayload);
        return activePayload;
    }

    private hasRoute(name: string): boolean {
        return NavigationManager.getRouteBuilder(name) !== undefined;
    }

    @Builder
    private registeredRoute(name: string, param?: Object, options?: EasyNavDestinationOptions) {
        NavDestination() {
            NavigationManager.getRouteBuilder(name)?.builder(this.activePayload(name, param));
        }
        .hideTitleBar(options?.hideTitleBar ?? true)
        .mode(options?.mode ?? NavDestinationMode.STANDARD)
        .title(options?.title?.value instanceof WrappedBuilder ?
            options?.title?.value.builder :
            options?.title?.value,
            options?.title?.options)
        .onWillAppear(() => {
            options?.onWillAppear?.();
        })
        .onAppear(() => {
            options?.onAppear?.();
        })
        .onWillShow(() => {
            options?.onWillShow?.();
        })
        .onShown(() => {
            options?.onShown?.();
        })
        .onWillHide(() => {
            options?.onWillHide?.();
        })
        .onHidden(() => {
            options?.onHidden?.();
        })
        .onWillDisappear(() => {
            options?.onWillDisappear?.();
        })
        .onDisAppear(() => {
            options?.onDisAppear?.();
        })
        .onReady((context: NavDestinationContext) => {
            options?.onReady?.(context);
        })
        .onBackPressed(() => {
            return options?.onBackPressed?.() ?? false;
        })
    }

    @Builder
    private unknownRoute(name: string) {
        NavDestination() {
            Column({ space: 12 }) {
                Text('Unknown Route')
                    .fontSize(24)
                    .fontWeight(FontWeight.Bold)

                Text(name)
                    .fontSize(14)
                    .fontColor('#6B7280')
            }
            .width('100%')
            .height('100%')
            .padding(24)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
        }
        .hideTitleBar(true)
    }

    @Builder
    private destinationBuilder(name: string, param?: Object) {
        if (this.hasRoute(name)) {
            this.registeredRoute(name, param, NavigationManager.getRouteDestinationOptions(name));
        } else {
            this.unknownRoute(name);
        }
    }

    build() {
        Navigation(this.pathStack) {}
            .hideNavBar(this.options?.hideNavBar ?? true)
            .title(this.options?.title?.value instanceof WrappedBuilder ?
                this.options.title.value.builder :
                this.options?.title?.value,
                this.options?.title?.options)
            .menus(this.options?.menus instanceof WrappedBuilder ?
                this.options.menus.builder :
                this.options?.menus)
            .toolbarConfiguration(this.options?.toolbar instanceof WrappedBuilder ?
                this.options.toolbar.builder :
                this.options?.toolbar)
            .navDestination(this.destinationBuilder)
            .enableToolBarAdaptation(this.options?.enableToolBarAdaptation)
            .onTitleModeChange((titleMode: NavigationTitleMode) => {
                this.options?.onTitleModeChange?.(titleMode);
            })
            .onNavBarStateChange((isVisible: boolean) => {
                this.options?.onNavBarStateChange?.(isVisible);
            })
            .onNavigationModeChange((mode: NavigationMode) => {
                this.options?.onNavigationModeChange?.(mode);
            })
            .onAttach(() => {
                NavigationManager.ensureRoot();
            })
            .width('100%')
            .height('100%')
    }
}

export interface RoutePayload<T = Object> {
    routeName: string;
    params?: T;
    requestId?: string;
}

export type RouteBuilder = WrappedBuilder<[RoutePayload<Object>]>;

export interface EasyNavTitle {
    value: ResourceStr | WrappedBuilder<[]> | NavigationCommonTitle | NavigationCustomTitle;
    options?: NavigationTitleOptions;
}

export interface EasyNavigationOptions {
    hideNavBar?: boolean;
    title?: EasyNavTitle;
    menus?: Array<NavigationMenuItem> | WrappedBuilder<[]>;
    toolbar?: Array<ToolbarItem> | WrappedBuilder<[]>;
    enableToolBarAdaptation?: boolean;
    onTitleModeChange?: (titleMode: NavigationTitleMode) => void;
    onNavBarStateChange?: (isVisible: boolean) => void;
    onNavigationModeChange?: (mode: NavigationMode) => void;
}

export interface EasyNavDestinationOptions {
    hideTitleBar?: boolean;
    mode?: NavDestinationMode;
    title?: EasyNavTitle;
    onWillAppear?: () => void;
    onAppear?: () => void;
    onWillShow?: () => void;
    onShown?: () => void;
    onWillHide?: () => void;
    onHidden?: () => void;
    onWillDisappear?: () => void;
    onDisAppear?: () => void;
    onReady?: (context: NavDestinationContext) => void;
    onBackPressed?: () => boolean;
}

export interface RouteRecord {
    name: string;
    builder: RouteBuilder;
    destination?: EasyNavDestinationOptions;
}

export interface NavigationInitOptions {
    routes: RouteRecord[];
    root: string;
}

export function createRoute(
    name: string,
    builder: RouteBuilder,
    destination?: EasyNavDestinationOptions
): RouteRecord {
    return { name, builder, destination };
}

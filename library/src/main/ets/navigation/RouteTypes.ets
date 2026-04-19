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

export interface EasyNavDestinationOptions {
    hideTitleBar?: boolean;
    mode?: NavDestinationMode;
    title?: EasyNavTitle;
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

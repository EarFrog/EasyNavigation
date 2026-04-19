export interface RoutePayload<T = Object> {
    routeName: string;
    params?: T;
    requestId?: string;
}

export type RouteBuilder = WrappedBuilder<[RoutePayload<Object>]>;

export interface RouteRecord {
    name: string;
    builder: RouteBuilder;
}

export interface NavigationInitOptions {
    routes: RouteRecord[];
    root: string;
}

export function createRoute(name: string, builder: RouteBuilder): RouteRecord {
    return { name, builder };
}

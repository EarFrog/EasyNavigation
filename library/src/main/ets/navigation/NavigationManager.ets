import {
    EasyNavDestinationOptions,
    NavigationInitOptions,
    RouteBuilder,
    RoutePayload,
    RouteRecord
} from './RouteTypes';
import { RouteRegistry } from './RouteRegistry';

const TAG = 'EasyNavigation';

interface PendingResult {
    complete: (value?: Object) => void;
}

class NavigationManagerImpl {
    private readonly registry: RouteRegistry = new RouteRegistry();
    private pathStack?: NavPathStack;
    private rootRoute: string = '';
    private currentRoute?: RoutePayload<Object>;
    private readonly pendingResults: Map<string, PendingResult> = new Map();
    private requestSeed: number = 0;

    init(options: NavigationInitOptions): void {
        this.registry.registerAll(options.routes);
        this.rootRoute = options.root;
    }

    bindStack(pathStack: NavPathStack): void {
        this.pathStack = pathStack;
    }

    unbindStack(pathStack: NavPathStack): void {
        if (this.pathStack !== pathStack) {
            return;
        }
        this.pathStack = undefined;
        this.currentRoute = undefined;
        this.clearPendingResults();
    }

    ensureRoot(): void {
        const pathStack = this.ensureReady();
        if (this.rootRoute.length === 0 || pathStack.size() > 0) {
            return;
        }

        const payload = this.createPayload(this.rootRoute);
        this.currentRoute = payload;
        pathStack.pushPath({
            name: this.rootRoute,
            param: payload
        }, false);
    }

    getRoute(routeName: string): RouteRecord | undefined {
        return this.registry.get(routeName);
    }

    getRouteBuilder(routeName: string): RouteBuilder | undefined {
        return this.getRoute(routeName)?.builder;
    }

    getRouteDestinationOptions(routeName: string): EasyNavDestinationOptions | undefined {
        return this.getRoute(routeName)?.destination;
    }

    setCurrentRoute(payload: RoutePayload<Object> | undefined): void {
        this.currentRoute = payload;
    }

    getCurrentRoute(): RoutePayload<Object> | undefined {
        return this.currentRoute;
    }

    getParams<T>(): T | undefined {
        return this.currentRoute?.params as T | undefined;
    }

    canPop(): boolean {
        return this.pathStack !== undefined && this.pathStack.size() > 1;
    }

    push(routeName: string, params?: Object): void {
        const payload = this.createPayload(routeName, params);
        this.ensureReady().pushPath({
            name: routeName,
            param: payload
        });
    }

    pushForResult<T>(routeName: string, params?: Object): Promise<T | undefined> {
        const requestId = this.nextRequestId();
        const payload = this.createPayload(routeName, params, requestId);

        return new Promise<T | undefined>((resolve: (value: T | undefined) => void) => {
            this.pendingResults.set(requestId, {
                complete: (value?: Object) => {
                    resolve(value as T | undefined);
                }
            });
            this.ensureReady().pushPath({
                name: routeName,
                param: payload
            });
        });
    }

    replace(routeName: string, params?: Object): void {
        this.invalidatePendingForCurrentRoute();
        const payload = this.createPayload(routeName, params);
        this.ensureReady().replacePath({
            name: routeName,
            param: payload
        });
    }

    pop(result?: Object): boolean {
        if (!this.canPop()) {
            return false;
        }

        const requestId = this.currentRoute?.requestId;
        if (requestId) {
            this.completePending(requestId, result);
        }

        this.ensureReady().pop(result);
        return true;
    }

    popTo(routeName: string, result?: Object): boolean {
        const pathStack = this.ensureReady();
        const indexes = pathStack.getIndexByName(routeName);
        if (indexes.length === 0) {
            console.error(`${TAG}: cannot popTo missing route ${routeName}`);
            return false;
        }

        this.invalidatePendingForCurrentRoute();
        pathStack.popToName(routeName, result);
        return true;
    }

    private ensureReady(): NavPathStack {
        if (!this.pathStack) {
            console.error(`${TAG}: navigation stack is not ready`);
            throw new Error('Navigation stack is not ready');
        }
        return this.pathStack;
    }

    private createPayload(routeName: string, params?: Object, requestId?: string): RoutePayload<Object> {
        if (!this.registry.has(routeName)) {
            console.error(`${TAG}: unknown route ${routeName}`);
            throw new Error(`Unknown route: ${routeName}`);
        }
        return {
            routeName,
            params,
            requestId
        };
    }

    private nextRequestId(): string {
        this.requestSeed += 1;
        return `nav-${this.requestSeed}`;
    }

    private completePending(requestId: string, value?: Object): void {
        const pending = this.pendingResults.get(requestId);
        if (!pending) {
            return;
        }
        pending.complete(value);
        this.pendingResults.delete(requestId);
    }

    private clearPendingResults(): void {
        Array.from(this.pendingResults.keys()).forEach((requestId: string) => {
            this.completePending(requestId);
        });
    }

    private invalidatePendingForCurrentRoute(): void {
        const requestId = this.currentRoute?.requestId;
        if (requestId) {
            this.completePending(requestId);
        }
    }
}

export const NavigationManager = new NavigationManagerImpl();

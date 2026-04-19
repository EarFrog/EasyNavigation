import { RouteRecord } from './RouteTypes';

const TAG = 'EasyNavigation';

export class RouteRegistry {
    private readonly routeMap: Map<string, RouteRecord> = new Map();

    registerAll(routes: RouteRecord[]): void {
        this.routeMap.clear();
        routes.forEach((route: RouteRecord) => this.register(route));
    }

    register(route: RouteRecord): void {
        const name = route.name.trim();
        if (name.length === 0) {
            throw new Error('Route name must not be empty');
        }
        if (this.routeMap.has(name)) {
            throw new Error(`Duplicate route name: ${name}`);
        }
        this.routeMap.set(name, {
            name,
            builder: route.builder,
            destination: route.destination
        });
        console.info(`${TAG}: register route ${name}`);
    }

    get(name: string): RouteRecord | undefined {
        return this.routeMap.get(name);
    }

    has(name: string): boolean {
        return this.routeMap.has(name);
    }
}

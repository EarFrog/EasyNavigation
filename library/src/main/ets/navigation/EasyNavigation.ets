import { NavigationManager } from './NavigationManager';
import { RoutePayload, RouteRecord } from './RouteTypes';

@Component
export struct EasyNavigation {
    @Require routes: RouteRecord[];
    @Require root: string;

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
    private registeredRoute(name: string, param?: Object) {
        NavigationManager.getRouteBuilder(name)?.builder(this.activePayload(name, param));
    }

    @Builder
    private unknownRoute(name: string) {
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

    @Builder
    private destinationBuilder(name: string, param?: Object) {
        if (this.hasRoute(name)) {
            this.registeredRoute(name, param);
        } else {
            this.unknownRoute(name);
        }
    }

    build() {
        Navigation(this.pathStack) {}
            .hideNavBar(true)
            .navDestination(this.destinationBuilder)
            .onAppear(() => {
                NavigationManager.ensureRoot();
            })
            .width('100%')
            .height('100%')
    }
}

import { EasyNavigation, RoutePayload, RouteRecord, createRoute } from '@easy/navigation';
import { Home } from './Home';
import { Detail } from './Detail';
import { SecondDetail } from './SecondDetail';
import { ResultPage } from './ResultPage';

@Builder
function buildHomeRoute(_payload: RoutePayload<Object>) {
    Home();
}

@Builder
function buildDetailRoute(payload: RoutePayload<Object>) {
    Detail({ route: payload });
}

@Builder
function buildSecondDetailRoute(payload: RoutePayload<Object>) {
    SecondDetail({ route: payload });
}

@Builder
function buildResultRoute(payload: RoutePayload<Object>) {
    ResultPage({ route: payload });
}

const APP_ROUTES: RouteRecord[] = [
    createRoute('home', wrapBuilder(buildHomeRoute)),
    createRoute('detail', wrapBuilder(buildDetailRoute)),
    createRoute('second-detail', wrapBuilder(buildSecondDetailRoute)),
    createRoute('result-page', wrapBuilder(buildResultRoute))
];

@Entry
@Component
struct Index {
    build() {
        Column() {
            EasyNavigation({
                routes: APP_ROUTES,
                root: 'home'
            });
        }
        .width('100%')
        .height('100%')
    }
}

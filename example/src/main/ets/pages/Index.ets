import {
    EasyNavDestinationOptions,
    EasyNavigation,
    NavigationManager,
    RoutePayload,
    RouteRecord,
    createRoute
} from '@easy/navigation';
import { Home } from './Home';
import { Detail } from './Detail';
import { SecondDetail } from './SecondDetail';
import { ResultPage } from './ResultPage';

interface LocaleParams {
    locale: string;
}

@Component
struct DemoSelector {
    @Builder
    private actionButton(label: string, detail: string, color: string, onPress: () => void) {
        Button() {
            Column({ space: 6 }) {
                Text(label)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#FFFFFF')

                Text(detail)
                    .fontSize(12)
                    .lineHeight(18)
                    .fontColor('#E0F2FE')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
        }
        .type(ButtonType.Normal)
        .backgroundColor(color)
        .borderRadius(16)
        .padding(18)
        .width('100%')
        .onClick(onPress)
    }

    build() {
        Column({ space: 18 }) {
            Text('EasyNavigation Demo')
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor('#172033')

            Text('请选择语言版本 / Choose a demo language')
                .fontSize(14)
                .fontColor('#5B6576')

            this.actionButton(
                '中文示例',
                '面向中国开发者，验证中文标题栏、弹窗标题和路由能力。',
                '#2563EB',
                () => {
                    const params: LocaleParams = { locale: 'zh' };
                    NavigationManager.push('zh-home', params);
                }
            )

            this.actionButton(
                'English Demo',
                'Validate English labels, system title bar, custom dialog title, and route flows.',
                '#0F766E',
                () => {
                    const params: LocaleParams = { locale: 'en' };
                    NavigationManager.push('en-home', params);
                }
            )
        }
        .width('100%')
        .height('100%')
        .padding(24)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#EEF2F8')
    }
}

@Builder
function buildSelectorRoute(_payload: RoutePayload<Object>) {
    DemoSelector();
}

@Builder
function buildHomeRoute(payload: RoutePayload<Object>) {
    Home({ route: payload });
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

@Builder
function buildZhResultTitle() {
    Row({ space: 8 }) {
        Text('结果弹窗')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0F766E')

        Text('自定义标题')
            .fontSize(12)
            .fontColor('#64748B')
    }
    .alignItems(VerticalAlign.Center)
}

@Builder
function buildEnResultTitle() {
    Row({ space: 8 }) {
        Text('Result Dialog')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#0F766E')

        Text('Custom Title')
            .fontSize(12)
            .fontColor('#64748B')
    }
    .alignItems(VerticalAlign.Center)
}

const ZH_DETAIL_DESTINATION: EasyNavDestinationOptions = {
    hideTitleBar: false,
    mode: NavDestinationMode.STANDARD,
    title: {
        value: '详情页（系统标题栏）'
    },
    onReady: (_context: NavDestinationContext) => {
        console.info('EasyNavigation Demo: zh detail NavDestination onReady');
    },
    onBackPressed: () => false
};

const EN_DETAIL_DESTINATION: EasyNavDestinationOptions = {
    hideTitleBar: false,
    mode: NavDestinationMode.STANDARD,
    title: {
        value: 'Detail (System Title Bar)'
    },
    onReady: (_context: NavDestinationContext) => {
        console.info('EasyNavigation Demo: en detail NavDestination onReady');
    },
    onBackPressed: () => false
};

const ZH_RESULT_DESTINATION: EasyNavDestinationOptions = {
    hideTitleBar: false,
    mode: NavDestinationMode.DIALOG,
    title: {
        value: wrapBuilder(buildZhResultTitle)
    },
    onReady: (_context: NavDestinationContext) => {
        console.info('EasyNavigation Demo: zh result dialog NavDestination onReady');
    },
    onBackPressed: () => false
};

const EN_RESULT_DESTINATION: EasyNavDestinationOptions = {
    hideTitleBar: false,
    mode: NavDestinationMode.DIALOG,
    title: {
        value: wrapBuilder(buildEnResultTitle)
    },
    onReady: (_context: NavDestinationContext) => {
        console.info('EasyNavigation Demo: en result dialog NavDestination onReady');
    },
    onBackPressed: () => false
};

const APP_ROUTES: RouteRecord[] = [
    createRoute('home', wrapBuilder(buildSelectorRoute)),
    createRoute('zh-home', wrapBuilder(buildHomeRoute)),
    createRoute('en-home', wrapBuilder(buildHomeRoute)),
    createRoute('zh-detail', wrapBuilder(buildDetailRoute), ZH_DETAIL_DESTINATION),
    createRoute('en-detail', wrapBuilder(buildDetailRoute), EN_DETAIL_DESTINATION),
    createRoute('zh-second-detail', wrapBuilder(buildSecondDetailRoute)),
    createRoute('en-second-detail', wrapBuilder(buildSecondDetailRoute)),
    createRoute('zh-result-page', wrapBuilder(buildResultRoute), ZH_RESULT_DESTINATION),
    createRoute('en-result-page', wrapBuilder(buildResultRoute), EN_RESULT_DESTINATION)
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

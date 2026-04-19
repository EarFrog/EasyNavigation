import { NavigationManager, RoutePayload } from '@easy/navigation';

interface DetailParams {
    id: string;
    from: string;
    locale: string;
}

interface ResultRouteParams {
    source: string;
    mode: string;
    locale: string;
}

interface ResultRouteResult {
    selection: string;
    source: string;
    confirmed: boolean;
}

@Component
export struct Home {
    @Prop route: RoutePayload<Object> | undefined = undefined;
    @State private lastResult: string = '';

    aboutToAppear(): void {
        this.lastResult = this.isZh() ? '还没有收到返回结果。' : 'No result returned yet.';
    }

    private isZh(): boolean {
        return (this.route?.params as DetailParams | undefined)?.locale !== 'en';
    }

    private routeName(name: string): string {
        return `${this.isZh() ? 'zh' : 'en'}-${name}`;
    }

    private async openResultPage(): Promise<void> {
        const params: ResultRouteParams = {
            source: this.isZh() ? '首页' : 'Home',
            mode: this.isZh() ? '等待返回' : 'await-result',
            locale: this.isZh() ? 'zh' : 'en'
        };
        const result = await NavigationManager.pushForResult<ResultRouteResult>(this.routeName('result-page'), params);
        if (this.isZh()) {
            this.lastResult = result
                ? `选择=${result.selection}，来源=${result.source}，已确认=${result.confirmed}`
                : '页面已返回，但没有携带结果。';
            return;
        }
        this.lastResult = result
            ? `selection=${result.selection}, source=${result.source}, confirmed=${result.confirmed}`
            : 'The page returned without a result.';
    }

    @Builder
    private actionButton(label: string, color: string, onPress: () => void) {
        Button(label)
            .type(ButtonType.Capsule)
            .backgroundColor(color)
            .fontColor('#FFFFFF')
            .width('100%')
            .onClick(onPress)
    }

    @Builder
    private infoCard(title: string, detail: string) {
        Column({ space: 8 }) {
            Text(title)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#172033')

            Text(detail)
                .fontSize(13)
                .lineHeight(20)
                .fontColor('#5B6576')
        }
        .width('100%')
        .padding(18)
        .backgroundColor('#FFFFFF')
        .borderRadius(24)
        .alignItems(HorizontalAlign.Start)
    }

    build() {
        Scroll() {
            Column({ space: 18 }) {
                this.infoCard(
                    this.isZh() ? 'EasyNavigation 中文示例' : 'EasyNavigation English Demo',
                    this.isZh()
                        ? '这个示例用于验证路由表、参数传递、二级页面、replace、popTo、pushForResult，以及新增的 NavDestination 和 NavTitle 配置。'
                        : 'This demo validates the route table, params, second-level navigation, replace, popTo, pushForResult, NavDestination, and NavTitle options.'
                )

                this.infoCard(
                    this.isZh() ? '当前返回结果' : 'Current Result',
                    this.lastResult
                )

                this.infoCard(
                    this.isZh() ? 'NavDestination 配置验证' : 'NavDestination Configuration Check',
                    this.isZh()
                        ? '点击“打开详情页”应看到系统标题栏显示中文标题；点击“打开结果弹窗并等待返回”应看到弹窗模式和自定义中文标题。'
                        : 'Tap "Open Detail" to verify the system title bar. Tap "Open Result Dialog For Result" to verify dialog mode and a custom title.'
                )

                Column({ space: 12 }) {
                    this.actionButton(this.isZh() ? '打开详情页' : 'Open Detail', '#2563EB', () => {
                        const params: DetailParams = {
                            id: 'detail-001',
                            from: this.isZh() ? '首页' : 'Home',
                            locale: this.isZh() ? 'zh' : 'en'
                        };
                        NavigationManager.push(this.routeName('detail'), params);
                    })

                    this.actionButton(
                        this.isZh() ? '打开结果弹窗并等待返回' : 'Open Result Dialog For Result',
                        '#0F766E',
                        () => {
                            void this.openResultPage();
                        })

                    this.actionButton(
                        this.isZh() ? '返回语言选择' : 'Back to Language Selector',
                        '#111827',
                        () => {
                            NavigationManager.pop();
                        })
                }
                .width('100%')
                .padding(18)
                .backgroundColor('#FFFFFF')
                .borderRadius(24)
            }
            .width('100%')
            .padding(20)
            .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#EEF2F8')
    }
}

import { NavigationManager, RoutePayload } from '@easy/navigation';

interface DetailParams {
    id: string;
    from: string;
    locale: string;
}

interface SecondDetailParams {
    id: string;
    parentId: string;
    locale: string;
}

interface ResultRouteParams {
    source: string;
    mode: string;
    parentId?: string;
    locale: string;
}

@Component
export struct Detail {
    @Prop route: RoutePayload<Object> | undefined = undefined;

    private detailParams(): DetailParams | undefined {
        return this.route?.params as DetailParams | undefined;
    }

    private isZh(): boolean {
        return this.detailParams()?.locale !== 'en';
    }

    private routeName(name: string): string {
        return `${this.isZh() ? 'zh' : 'en'}-${name}`;
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

    build() {
        Column({ space: 16 }) {
            Text(this.isZh() ? '详情页内容区' : 'Detail Content')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor('#172033')

            Text(this.isZh()
                ? '这个页面用于验证一级 push、系统标题栏、onReady 回调和返回拦截。顶部标题栏应显示“详情页（系统标题栏）”。'
                : 'This page validates first-level push, the system title bar, onReady, and back handling. The title bar should read "Detail (System Title Bar)".')
                .fontSize(13)
                .lineHeight(20)
                .fontColor('#5B6576')

            Text(`id=${this.detailParams()?.id ?? '-'}`)
                .fontSize(14)
                .fontColor('#172033')

            Text(`from=${this.detailParams()?.from ?? '-'}`)
                .fontSize(14)
                .fontColor('#5B6576')

            this.actionButton(this.isZh() ? '打开二级详情页' : 'Open Second Detail', '#2563EB', () => {
                const params: SecondDetailParams = {
                    id: 'detail-002',
                    parentId: this.detailParams()?.id ?? 'unknown',
                    locale: this.isZh() ? 'zh' : 'en'
                };
                NavigationManager.push(this.routeName('second-detail'), params);
            })

            this.actionButton(this.isZh() ? '替换为结果弹窗' : 'Replace With Result Dialog', '#7C3AED', () => {
                const params: ResultRouteParams = {
                    source: this.isZh() ? '详情页' : 'Detail',
                    mode: this.isZh() ? '替换' : 'replace',
                    parentId: this.detailParams()?.id,
                    locale: this.isZh() ? 'zh' : 'en'
                };
                NavigationManager.replace(this.routeName('result-page'), params);
            })

            this.actionButton(this.isZh() ? '返回' : 'Back', '#111827', () => {
                NavigationManager.pop();
            })
        }
        .width('100%')
        .height('100%')
        .padding(24)
        .backgroundColor('#EEF2F8')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
    }
}

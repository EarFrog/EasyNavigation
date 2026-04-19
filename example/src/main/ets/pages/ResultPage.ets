import { NavigationManager, RoutePayload } from '@easy/navigation';

interface ResultRouteParams {
    source: string;
    mode: string;
    parentId?: string;
    locale: string;
}

interface ResultRouteResult {
    selection: string;
    source: string;
    confirmed: boolean;
}

@Component
export struct ResultPage {
    @Prop route: RoutePayload<Object> | undefined = undefined;

    private resultParams(): ResultRouteParams | undefined {
        return this.route?.params as ResultRouteParams | undefined;
    }

    private isZh(): boolean {
        return this.resultParams()?.locale !== 'en';
    }

    private returnResult(): void {
        const result: ResultRouteResult = {
            selection: this.isZh() ? '已确认' : 'approved',
            source: this.resultParams()?.source ?? 'unknown',
            confirmed: true
        };
        NavigationManager.pop(result);
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
    private dialogHeader() {
        Row({ space: 12 }) {
            Button() {
                Text('‹')
                    .fontSize(26)
                    .fontWeight(FontWeight.Normal)
                    .fontColor('#172033')
            }
            .type(ButtonType.Circle)
            .width(40)
            .height(40)
            .backgroundColor('#E8EDF3')
            .onClick(() => {
                NavigationManager.pop();
            })

            Text(this.isZh() ? '结果弹窗' : 'Result Dialog')
                .fontSize(20)
                .fontWeight(FontWeight.Medium)
                .fontColor('#172033')
                .maxLines(1)
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .alignItems(VerticalAlign.Center)
    }

    build() {
        Column() {
            this.dialogHeader()

            Column({ space: 16 }) {
                Text(this.isZh() ? '结果弹窗内容区' : 'Result Dialog Content')
                    .fontSize(26)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#172033')

                Text(this.isZh()
                    ? '这个页面用于验证 NavDestinationMode.DIALOG、内容内标题、replace，以及 pushForResult 返回结果。'
                    : 'This page validates NavDestinationMode.DIALOG, in-content title, replace, and pushForResult results.')
                    .fontSize(13)
                    .lineHeight(20)
                    .fontColor('#5B6576')

                Text(`source=${this.resultParams()?.source ?? '-'}`)
                    .fontSize(14)
                    .fontColor('#172033')

                Text(`mode=${this.resultParams()?.mode ?? '-'}`)
                    .fontSize(14)
                    .fontColor('#5B6576')

                Text(`parentId=${this.resultParams()?.parentId ?? '-'}`)
                    .fontSize(14)
                    .fontColor('#5B6576')

                Text(`requestId=${this.route?.requestId ?? 'none'}`)
                    .fontSize(14)
                    .fontColor('#5B6576')

                this.actionButton(this.isZh() ? '返回确认结果' : 'Return Confirmed Result', '#0F766E', () => {
                    this.returnResult();
                })

                this.actionButton(this.isZh() ? '不带结果返回' : 'Back Without Result', '#111827', () => {
                    NavigationManager.pop();
                })
            }
            .width('100%')
            .padding({ left: 24, right: 24, top: 180 })
            .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#EEF2F8')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
    }
}

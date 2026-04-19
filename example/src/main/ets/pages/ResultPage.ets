import { NavigationManager, RoutePayload } from '@easy/navigation';

interface ResultRouteParams {
    source: string;
    mode: string;
    parentId?: string;
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

    private returnResult(): void {
        const result: ResultRouteResult = {
            selection: 'approved',
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

    build() {
        Column({ space: 16 }) {
            Text('Result Page')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor('#172033')

            Text('This page is shared by the replace flow and the awaited pushForResult flow.')
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

            this.actionButton('Return Confirmed Result', '#0F766E', () => {
                this.returnResult();
            })

            this.actionButton('Back Without Result', '#111827', () => {
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

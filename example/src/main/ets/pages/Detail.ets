import { NavigationManager, RoutePayload } from '@easy/navigation';

interface DetailParams {
    id: string;
    from: string;
}

interface SecondDetailParams {
    id: string;
    parentId: string;
}

interface ResultRouteParams {
    source: string;
    mode: string;
    parentId?: string;
}

@Component
export struct Detail {
    @Prop route: RoutePayload<Object> | undefined = undefined;

    private detailParams(): DetailParams | undefined {
        return this.route?.params as DetailParams | undefined;
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
            Text('Detail Route')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor('#172033')

            Text('This page validates the first-level push and offers both a second-level push and a replace flow.')
                .fontSize(13)
                .lineHeight(20)
                .fontColor('#5B6576')

            Text(`id=${this.detailParams()?.id ?? '-'}`)
                .fontSize(14)
                .fontColor('#172033')

            Text(`from=${this.detailParams()?.from ?? '-'}`)
                .fontSize(14)
                .fontColor('#5B6576')

            this.actionButton('Open Second Detail', '#2563EB', () => {
                const params: SecondDetailParams = {
                    id: 'detail-002',
                    parentId: this.detailParams()?.id ?? 'unknown'
                };
                NavigationManager.push('second-detail', params);
            })

            this.actionButton('Replace With Result Page', '#7C3AED', () => {
                const params: ResultRouteParams = {
                    source: 'detail-replace',
                    mode: 'replace',
                    parentId: this.detailParams()?.id
                };
                NavigationManager.replace('result-page', params);
            })

            this.actionButton('Back', '#111827', () => {
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

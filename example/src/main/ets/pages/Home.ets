import { NavigationManager } from '@easy/navigation';

interface DetailParams {
    id: string;
    from: string;
}

interface ResultRouteParams {
    source: string;
    mode: string;
}

interface ResultRouteResult {
    selection: string;
    source: string;
    confirmed: boolean;
}

@Component
export struct Home {
    @State private lastResult: string = 'No result returned yet.';

    private async openResultPage(): Promise<void> {
        const params: ResultRouteParams = {
            source: 'home',
            mode: 'await-result'
        };
        const result = await NavigationManager.pushForResult<ResultRouteResult>('result-page', params);
        this.lastResult = result
            ? `selection=${result.selection}, source=${result.source}, confirmed=${result.confirmed}`
            : 'No result returned.';
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
                    'EasyNavigation Demo',
                    'This example validates a route-table HAR package with first-level navigation, second-level navigation, replace, popTo, and result return.'
                )

                this.infoCard(
                    'Current Result',
                    this.lastResult
                )

                Column({ space: 12 }) {
                    this.actionButton('Open Detail', '#2563EB', () => {
                        const params: DetailParams = {
                            id: 'detail-001',
                            from: 'home'
                        };
                        NavigationManager.push('detail', params);
                    })

                    this.actionButton('Open Result Page For Result', '#0F766E', () => {
                        void this.openResultPage();
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

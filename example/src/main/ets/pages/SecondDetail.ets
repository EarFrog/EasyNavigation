import { NavigationManager, RoutePayload } from '@easy/navigation';

interface SecondDetailParams {
    id: string;
    parentId: string;
}

@Component
export struct SecondDetail {
    @Prop route: RoutePayload<Object> | undefined = undefined;

    private detailParams(): SecondDetailParams | undefined {
        return this.route?.params as SecondDetailParams | undefined;
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
            Text('Second Detail Route')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor('#172033')

            Text('This page validates the second-level push and a direct popTo back to the home route.')
                .fontSize(13)
                .lineHeight(20)
                .fontColor('#5B6576')

            Text(`id=${this.detailParams()?.id ?? '-'}`)
                .fontSize(14)
                .fontColor('#172033')

            Text(`parentId=${this.detailParams()?.parentId ?? '-'}`)
                .fontSize(14)
                .fontColor('#5B6576')

            this.actionButton('Back', '#111827', () => {
                NavigationManager.pop();
            })

            this.actionButton('Pop To Home', '#EA580C', () => {
                NavigationManager.popTo('home');
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

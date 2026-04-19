import { NavigationManager, RoutePayload } from '@easy/navigation';

interface SecondDetailParams {
    id: string;
    parentId: string;
    locale: string;
}

@Component
export struct SecondDetail {
    @Prop route: RoutePayload<Object> | undefined = undefined;

    private detailParams(): SecondDetailParams | undefined {
        return this.route?.params as SecondDetailParams | undefined;
    }

    private isZh(): boolean {
        return this.detailParams()?.locale !== 'en';
    }

    private homeRoute(): string {
        return this.isZh() ? 'zh-home' : 'en-home';
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
            Text(this.isZh() ? '二级详情页' : 'Second Detail')
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor('#172033')

            Text(this.isZh()
                ? '这个页面用于验证二级 push，以及直接 popTo 回到首页。'
                : 'This page validates second-level push and direct popTo back to the demo home.')
                .fontSize(13)
                .lineHeight(20)
                .fontColor('#5B6576')

            Text(`id=${this.detailParams()?.id ?? '-'}`)
                .fontSize(14)
                .fontColor('#172033')

            Text(`parentId=${this.detailParams()?.parentId ?? '-'}`)
                .fontSize(14)
                .fontColor('#5B6576')

            this.actionButton(this.isZh() ? '返回上一页' : 'Back', '#111827', () => {
                NavigationManager.pop();
            })

            this.actionButton(this.isZh() ? '直接返回首页' : 'Pop To Demo Home', '#EA580C', () => {
                NavigationManager.popTo(this.homeRoute());
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

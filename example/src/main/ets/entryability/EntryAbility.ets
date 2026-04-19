import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { Logger } from '@easy/navigation';

const TAG = 'EntryAbility';
export default class EntryAbility extends UIAbility {
    onCreate(_want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    }

    onWindowStageCreate(windowStage: window.WindowStage): void {
        try {
            windowStage.loadContent('pages/Index', (error) => {
                if (error.code) {
                    console.error(`EasyNavigation: loadContent failed: ${error.code}`);
                }
            });
        } catch (error) {
            console.error(`EasyNavigation: loadContent threw: ${JSON.stringify(error)}`);
        }
    }

    onDestroy(): void {
        Logger.info(TAG, 'onDestroy');
    }

    onWindowStageDestroy(): void {
        Logger.info(TAG, 'onWindowStageDestroy');
    }

    onForeground(): void {
        Logger.info(TAG, 'onForeground');
    }

    onBackground(): void {
        Logger.info(TAG, 'onBackground');
    }
}

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

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
}
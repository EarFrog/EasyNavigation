import { hilog } from '@kit.PerformanceAnalysisKit';
import { SafeJsonUtils } from './SafeJsonUtils';

type LogData = Object | string | number | boolean | null | undefined;

interface ErrorWithStack {
    message?: string;
    stack?: string;
}

export class Logger {
    private static readonly DOMAIN: number = 0x0000;
    private static readonly DEFAULT_TAG: string = 'EarFrog';
    private static debugEnabled: boolean = true;

    static setDebugEnabled(enabled: boolean): void {
        Logger.debugEnabled = enabled;
    }

    static isDebugEnabled(): boolean {
        return Logger.debugEnabled;
    }

    static debug(TAG: string = '', message: string, data?: LogData): void {
        if (!Logger.debugEnabled) {
            return;
        }
        hilog.debug(Logger.DOMAIN, Logger.DEFAULT_TAG, `[${TAG}]: %{public}s`, Logger.buildMessage(message, data));
    }

    static info(TAG: string = '', message: string, data?: LogData): void {
        hilog.info(Logger.DOMAIN, Logger.DEFAULT_TAG, `[${TAG}]: %{public}s`, Logger.buildMessage(message, data));
    }

    static warn(TAG: string = '', message: string, data?: LogData): void {
        hilog.warn(Logger.DOMAIN, Logger.DEFAULT_TAG, `[${TAG}]: %{public}s`, Logger.buildMessage(message, data));
    }

    static error(TAG: string = '', message: string, data?: LogData): void {
        hilog.error(Logger.DOMAIN, Logger.DEFAULT_TAG, `[${TAG}]: %{public}s`, Logger.buildMessage(message, data));
    }

    private static buildMessage(message: string, data?: LogData): string {
        if (data === null || data === undefined) {
            return message;
        }
        return `${message} | ${Logger.toText(data)}`;
    }

    private static toText(data: LogData): string {
        if (typeof data === 'string') {
            return data;
        }
        if (typeof data === 'number' || typeof data === 'boolean') {
            return `${data}`;
        }
        // Check if it's an Error object with stack trace
        const error = data as ErrorWithStack;
        if (error && typeof error === 'object' && error.stack) {
            const stackLines = error.stack.split('\n').slice(1).join('\n'); // Skip first line (error message)
            return stackLines || error.message || '[no stack]';
        }
        return SafeJsonUtils.stringify(data);
    }
}

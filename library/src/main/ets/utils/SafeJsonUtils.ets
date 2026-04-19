type JsonData = Object | string | number | boolean | null | undefined;

export class SafeJsonUtils {
    static stringify(value: JsonData, fallback: string = ''): string {
        try {
            const result = JSON.stringify(value);
            return result !== undefined ? result : fallback;
        } catch (_) {
            return fallback;
        }
    }

    static parse<T>(json: string, fallback: T): T {
        if (json.trim().length === 0) {
            return fallback;
        }

        try {
            return JSON.parse(json) as T;
        } catch (_) {
            return fallback;
        }
    }
}

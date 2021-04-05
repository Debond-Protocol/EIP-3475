import type { JsonRpcPayload } from 'web3-core-helpers';
import type { Provider, JsonRpcCallback } from './provider';
export default class TestProvider implements Provider {
    private queue;
    private wrappedProvider?;
    sendAsync: (payload: JsonRpcPayload, callback: JsonRpcCallback) => void;
    constructor();
    send(payload: JsonRpcPayload, callback: JsonRpcCallback): void;
}
//# sourceMappingURL=test-provider.d.ts.map
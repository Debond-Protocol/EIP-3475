"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const p_queue_1 = __importDefault(require("p-queue"));
const web3_1 = __importDefault(require("web3"));
const setup_ganache_1 = __importDefault(require("./setup-ganache"));
const config_1 = __importDefault(require("./config"));
class TestProvider {
    constructor() {
        this.sendAsync = this.send.bind(this);
        this.queue = new p_queue_1.default({ concurrency: 1 });
        this.queue.add(async () => {
            // Setup node
            const url = await setup_ganache_1.default();
            // Create base provider (connection to node)
            const baseProvider = new web3_1.default(url).eth.currentProvider;
            // Create a custom provider (e.g. GSN provider) and wrap it
            this.wrappedProvider = await config_1.default.setupProvider(baseProvider);
        });
    }
    send(payload, callback) {
        this.queue.onIdle().then(() => {
            var _a;
            // wrapped provider is always not a null due to PQueue running the provider initialization
            // before any send calls yet TypeScript can't possibly knows that
            (_a = this.wrappedProvider) === null || _a === void 0 ? void 0 : _a.send(payload, callback);
        });
    }
}
exports.default = TestProvider;
//# sourceMappingURL=test-provider.js.map
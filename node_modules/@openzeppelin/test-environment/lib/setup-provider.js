"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.provider = exports.web3 = void 0;
const web3_1 = __importDefault(require("web3"));
const test_provider_1 = __importDefault(require("./test-provider"));
const provider = new test_provider_1.default();
exports.provider = provider;
// because web3 types is a joke
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const web3 = new web3_1.default(provider);
exports.web3 = web3;
//# sourceMappingURL=setup-provider.js.map
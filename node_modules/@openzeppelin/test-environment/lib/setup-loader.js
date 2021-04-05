"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const contract_loader_1 = require("@openzeppelin/contract-loader");
const config_1 = __importDefault(require("./config"));
const accounts_1 = require("./accounts");
const setup_provider_1 = require("./setup-provider");
if (config_1.default.contracts.type !== 'truffle' && config_1.default.contracts.type !== 'web3') {
    throw new Error(`Unknown contract type: '${config_1.default.contracts.type}'`);
}
exports.default = contract_loader_1.setupLoader({
    provider: setup_provider_1.provider,
    defaultSender: accounts_1.defaultSender,
    defaultGas: config_1.default.contracts.defaultGas,
    defaultGasPrice: config_1.default.contracts.defaultGasPrice,
    artifactsDir: config_1.default.contracts.artifactsDir,
})[config_1.default.contracts.type];
//# sourceMappingURL=setup-loader.js.map
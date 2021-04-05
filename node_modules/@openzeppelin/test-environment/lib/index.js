"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.config = exports.runCoverage = exports.isHelpersConfigured = exports.contract = exports.provider = exports.web3 = exports.defaultSender = exports.privateKeys = exports.accounts = void 0;
const helpers_1 = __importDefault(require("./helpers"));
exports.isHelpersConfigured = helpers_1.default;
const setup_provider_1 = require("./setup-provider");
Object.defineProperty(exports, "web3", { enumerable: true, get: function () { return setup_provider_1.web3; } });
Object.defineProperty(exports, "provider", { enumerable: true, get: function () { return setup_provider_1.provider; } });
const accounts_1 = require("./accounts");
Object.defineProperty(exports, "accounts", { enumerable: true, get: function () { return accounts_1.accounts; } });
Object.defineProperty(exports, "privateKeys", { enumerable: true, get: function () { return accounts_1.privateKeys; } });
Object.defineProperty(exports, "defaultSender", { enumerable: true, get: function () { return accounts_1.defaultSender; } });
const setup_loader_1 = __importDefault(require("./setup-loader"));
exports.contract = setup_loader_1.default;
const coverage_1 = require("./coverage");
Object.defineProperty(exports, "runCoverage", { enumerable: true, get: function () { return coverage_1.runCoverage; } });
const config_1 = __importDefault(require("./config"));
exports.config = config_1.default;
//# sourceMappingURL=index.js.map
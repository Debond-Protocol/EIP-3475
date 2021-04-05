"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getConfig = exports.DEFAULT_BLOCK_GAS_LIMIT = void 0;
const fs_1 = __importDefault(require("fs"));
const find_up_1 = __importDefault(require("find-up"));
const lodash_merge_1 = __importDefault(require("lodash.merge"));
const log_1 = require("./log");
const CONFIG_FILE = 'test-environment.config.js';
const configHelpUrl = 'https://zpl.in/test-env-config';
exports.DEFAULT_BLOCK_GAS_LIMIT = 8e6;
const defaultConfig = {
    accounts: {
        amount: 10,
        ether: 100,
    },
    contracts: {
        type: 'truffle',
        defaultGas: exports.DEFAULT_BLOCK_GAS_LIMIT * 0.75,
        defaultGasPrice: 20e9,
        artifactsDir: 'build/contracts',
    },
    setupProvider: async (baseProvider) => baseProvider,
    coverage: false,
    node: {
        allowUnlimitedContractSize: false,
        gasLimit: exports.DEFAULT_BLOCK_GAS_LIMIT,
        gasPrice: 20e9,
    },
};
function getConfig() {
    var _a, _b;
    const location = find_up_1.default.sync(CONFIG_FILE, { type: 'file' });
    const providedConfig = location !== undefined && fs_1.default.existsSync(location) ? require(location) : {};
    if (providedConfig.blockGasLimit !== undefined) {
        log_1.warn(`blockGasLimit is deprecated. Use node.gasLimit instead. See ${configHelpUrl} for details.`);
    }
    if (providedConfig.gasPrice !== undefined) {
        log_1.warn(`Please move gasPrice option inside node option. See ${configHelpUrl} for more details.`);
    }
    if (providedConfig.gasPrice !== undefined && ((_a = providedConfig.node) === null || _a === void 0 ? void 0 : _a.gasPrice) !== undefined) {
        throw new Error(`GasPrice is specified twice in config. Please fix your config. See ${configHelpUrl} for more details.`);
    }
    if (!!providedConfig.blockGasLimit && !!((_b = providedConfig.node) === null || _b === void 0 ? void 0 : _b.gasLimit)) {
        throw new Error(`GasLimit is specified twice in config. Please fix your config. See ${configHelpUrl} for more details.`);
    }
    const config = lodash_merge_1.default(defaultConfig, providedConfig);
    if (config.gasPrice !== undefined)
        config.node.gasPrice = config.gasPrice;
    if (config.blockGasLimit)
        config.node.gasLimit = config.blockGasLimit;
    if (config.node.gasPrice !== undefined && typeof config.node.gasPrice !== 'string')
        config.node.gasPrice = `0x${config.node.gasPrice.toString(16)}`;
    if (process.env.OZ_TEST_ENV_COVERAGE !== undefined) {
        config.coverage = true;
        config.contracts.defaultGas = 0xffffffffff;
        config.contracts.defaultGasPrice = 1;
    }
    return config;
}
exports.getConfig = getConfig;
exports.default = getConfig();
//# sourceMappingURL=config.js.map
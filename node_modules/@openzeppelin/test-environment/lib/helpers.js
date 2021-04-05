"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const try_require_1 = __importDefault(require("try-require"));
const semver_1 = __importDefault(require("semver"));
const accounts_1 = require("./accounts");
const config_1 = __importDefault(require("./config"));
const setup_provider_1 = require("./setup-provider");
const log_1 = require("./log");
let configured = false;
const testHelpersPackage = try_require_1.default('@openzeppelin/test-helpers/package.json');
if (testHelpersPackage !== undefined) {
    // TODO: skip if already configured?
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const configure = require('@openzeppelin/test-helpers/configure');
    const version = testHelpersPackage.version;
    if (semver_1.default.satisfies(version, '^0.5.4')) {
        // The 'singletons' field was introduced in 0.5.4
        configure({
            provider: setup_provider_1.provider,
            singletons: {
                abstraction: config_1.default.contracts.type,
                defaultGas: config_1.default.contracts.defaultGas,
                defaultSender: accounts_1.defaultSender,
            },
        });
        configured = true;
    }
    else if (semver_1.default.satisfies(version, '^0.5.0 <0.5.4')) {
        // Whitespaces indicate intersection ('and') in semver
        // Alternatively, 'environment' was available from 0.5.0, but the gas and
        // sender could not be configured
        configure({ provider: setup_provider_1.provider, environment: config_1.default.contracts.type });
        configured = true;
    }
    else {
        log_1.warn(`Currently installed version of @openzeppelin/test-helpers (${version}) is unsupported, cannot configure.

Please upgrade to v0.5.0 or newer:
npm install --save-dev @openzeppelin/test-helpers@latest`);
    }
}
exports.default = configured;
//# sourceMappingURL=helpers.js.map
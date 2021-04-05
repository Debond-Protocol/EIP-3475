"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.runCoverage = void 0;
const events_1 = require("events");
const log_1 = require("./log");
const child_process_1 = require("child_process");
const path_1 = __importDefault(require("path"));
const fs_1 = require("fs");
const fs_extra_1 = require("fs-extra");
const exit_hook_1 = __importDefault(require("exit-hook"));
/* eslint-disable @typescript-eslint/no-var-requires */
async function runCoverage(skipFiles, compileCommand, testCommand) {
    const client = require('ganache-cli');
    const CoverageAPI = require('solidity-coverage/api');
    const utils = require('solidity-coverage/utils');
    const api = new CoverageAPI({ client });
    const config = {
        workingDir: process.cwd(),
        contractsDir: path_1.default.join(process.cwd(), 'contracts'),
        logger: {
            log: (msg) => log_1.log(msg),
        },
    };
    try {
        const { tempContractsDir, tempArtifactsDir } = utils.getTempLocations(config);
        function cleanUp() {
            if (fs_1.existsSync('./contracts-backup/')) {
                fs_extra_1.moveSync('./contracts-backup', './contracts', { overwrite: true });
            }
            fs_extra_1.removeSync('./build/contracts/');
            fs_extra_1.removeSync(tempArtifactsDir);
            fs_extra_1.removeSync(tempContractsDir);
        }
        exit_hook_1.default(cleanUp);
        utils.setupTempFolders(config, tempContractsDir, tempArtifactsDir);
        const { targets, skipped } = utils.assembleFiles(config, skipFiles);
        const instrumented = api.instrument(targets);
        utils.save(instrumented, config.contractsDir, tempContractsDir);
        utils.save(skipped, config.contractsDir, tempContractsDir);
        // backup original contracts
        fs_extra_1.moveSync('./contracts/', './contracts-backup');
        fs_extra_1.moveSync(tempContractsDir, './contracts/');
        // compile instrumented contracts
        child_process_1.execSync(compileCommand);
        // run tests
        const forked = child_process_1.fork(testCommand[0], testCommand.slice(1), {
            env: {
                ...process.env,
                cwd: __dirname,
                OZ_TEST_ENV_COVERAGE: 'TRUE',
            },
        });
        const [accounts] = await events_1.once(forked, 'message');
        api.providerOptions = { accounts: accounts };
        // run Ganache
        const address = await api.ganache();
        // start test-env tests
        forked.send(address);
        // wait for the tests to finish
        await events_1.once(forked, 'close');
        // Clean up before writing report
        cleanUp();
        // write a report
        await api.report();
    }
    catch (e) {
        log_1.log(e);
        process.exitCode = 1;
    }
    finally {
        await utils.finish(config, api);
    }
}
exports.runCoverage = runCoverage;
//# sourceMappingURL=coverage.js.map
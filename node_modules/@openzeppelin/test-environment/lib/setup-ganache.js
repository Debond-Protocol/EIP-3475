"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const path_1 = __importDefault(require("path"));
const child_process_1 = require("child_process");
const accounts_1 = require("./accounts");
const config_1 = __importDefault(require("./config"));
async function default_1() {
    if (!config_1.default.coverage) {
        const server = child_process_1.fork(path_1.default.join(__dirname, 'ganache-server'), [], {
            // Prevent the child process from also being started in inspect mode, which
            // would cause issues due to parent and child sharing the port.
            // See https://github.com/OpenZeppelin/openzeppelin-test-environment/pull/23
            execArgv: process.execArgv.filter((opt) => opt !== '--inspect'),
        });
        const options = {
            accounts: accounts_1.accountsConfig,
            coverage: false,
        };
        server.send(options);
        const messageReceived = new Promise((resolve) => {
            return server.once('message', resolve);
        });
        const message = await messageReceived;
        switch (message.type) {
            case 'ready':
                if (server.channel) {
                    server.channel.unref();
                }
                server.unref();
                return `http://localhost:${message.port}`;
            case 'error':
                server.kill();
                throw new Error('Unhandled server error');
            default:
                throw new Error(`Uknown server message: '${message}'`);
        }
    }
    else {
        if (process.send === undefined) {
            throw new Error('Module must be started through child_process.fork for solidity-coverage support.');
        }
        process.send(accounts_1.accountsConfig);
        const address = await new Promise((resolve) => {
            return process.on('message', resolve);
        });
        return address;
    }
}
exports.default = default_1;
//# sourceMappingURL=setup-ganache.js.map
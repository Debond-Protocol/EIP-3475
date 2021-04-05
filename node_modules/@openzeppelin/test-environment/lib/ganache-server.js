"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ganache_core_1 = __importDefault(require("ganache-core"));
const events_1 = __importDefault(require("events"));
const config_1 = require("./config");
function send(msg) {
    if (process.send === undefined) {
        throw new Error('Module must be started through child_process.fork');
    }
    process.send(msg, (err) => {
        if (err)
            process.exit();
    });
}
function setupServer(nodeOptions) {
    if (!nodeOptions.coverage) {
        return ganache_core_1.default.server(nodeOptions);
    }
    else {
        return require('ganache-core-coverage').server({
            ...nodeOptions,
            emitFreeLogs: true,
            allowUnlimitedContractSize: true,
        });
    }
}
process.once('message', async (options) => {
    const config = config_1.getConfig();
    const server = setupServer({ ...options, ...config.node });
    process.on('disconnect', () => {
        server.close();
    });
    // An undefined port number makes ganache-core choose a random free port,
    // which plays nicely with environments such as jest and ava, where multiple
    // processes of test-environment may be run in parallel.
    // It also means however that the port (and therefore host URL) is not
    // available until the server finishes initialization.
    server.listen(undefined);
    try {
        await events_1.default.once(server, 'listening');
        const addr = server.address();
        if (typeof addr === 'object' && addr !== null) {
            send({ type: 'ready', port: addr.port });
        }
        else {
            send({ type: 'error' });
        }
    }
    catch (err) {
        send({ type: 'error' });
    }
});
//# sourceMappingURL=ganache-server.js.map
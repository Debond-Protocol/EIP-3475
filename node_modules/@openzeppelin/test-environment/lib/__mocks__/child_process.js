"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fork = void 0;
exports.fork = jest.fn(() => {
    return {
        send: jest.fn(),
        once: jest.fn((event, listener) => {
            listener({
                type: 'ready',
                port: 42,
            });
        }),
        unref: jest.fn(),
    };
});
//# sourceMappingURL=child_process.js.map
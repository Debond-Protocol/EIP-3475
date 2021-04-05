"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.flushPromises = void 0;
function flushPromises() {
    return new Promise((resolve) => setImmediate(resolve));
}
exports.flushPromises = flushPromises;
//# sourceMappingURL=utils.js.map
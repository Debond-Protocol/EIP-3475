"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.warn = exports.log = void 0;
const ansi_colors_1 = __importDefault(require("ansi-colors"));
function log(msg) {
    console.log(`${ansi_colors_1.default.white.bgBlack('@openzeppelin/test-environment')} ${msg}`);
}
exports.log = log;
function warn(msg) {
    log(`${ansi_colors_1.default.black.bgYellow('WARN')} ${msg}`);
}
exports.warn = warn;
//# sourceMappingURL=log.js.map
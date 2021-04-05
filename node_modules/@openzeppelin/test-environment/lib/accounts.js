"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateAccounts = exports.getConfig = exports.defaultSender = exports.accountsConfig = exports.privateKeys = exports.accounts = void 0;
const ethereumjs_wallet_1 = __importDefault(require("ethereumjs-wallet"));
const web3_1 = __importDefault(require("web3"));
const config_1 = __importDefault(require("./config"));
const { utils } = web3_1.default;
function getConfig(ether) {
    return function (wallet) {
        return {
            balance: utils.toWei(ether.toString(), 'ether'),
            secretKey: wallet.getPrivateKeyString(),
        };
    };
}
exports.getConfig = getConfig;
function generateAccounts(count, ether) {
    const wallets = Array.from({ length: count }, ethereumjs_wallet_1.default.generate);
    const accounts = wallets.map((w) => w.getChecksumAddressString());
    const accountsConfig = wallets.map(getConfig(ether));
    const privateKeys = accountsConfig.map((c) => c.secretKey);
    return { accounts, privateKeys, accountsConfig };
}
exports.generateAccounts = generateAccounts;
const { accounts: allAccounts, privateKeys: allPrivateKeys, accountsConfig } = generateAccounts(config_1.default.accounts.amount + 1, // extra account for the default sender
config_1.default.accounts.ether);
exports.accountsConfig = accountsConfig;
// We use the first account as the default sender (when no sender is specified),
// which provides versatility for tests where this sender is not important
// (e.g. when calling view functions).
// We also don't expose this account so that it is not possible to explicitly
// use it, creating a scenario where the default account and an explicit account
// are the same one, which can create hard to debug failing tests.
const defaultSender = allAccounts[0];
exports.defaultSender = defaultSender;
const accounts = allAccounts.slice(1);
exports.accounts = accounts;
const privateKeys = allPrivateKeys.slice(1);
exports.privateKeys = privateKeys;
//# sourceMappingURL=accounts.js.map
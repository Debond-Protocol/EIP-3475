import { Wallet } from 'ethereumjs-wallet';
import { AccountConfig } from './setup-ganache';
declare function getConfig(ether: number): (wallet: Wallet) => AccountConfig;
declare function generateAccounts(count: number, ether: number): {
    accounts: string[];
    privateKeys: string[];
    accountsConfig: AccountConfig[];
};
declare const accountsConfig: AccountConfig[];
declare const defaultSender: string;
declare const accounts: string[];
declare const privateKeys: string[];
export { accounts, privateKeys, accountsConfig, defaultSender, getConfig, generateAccounts };
//# sourceMappingURL=accounts.d.ts.map
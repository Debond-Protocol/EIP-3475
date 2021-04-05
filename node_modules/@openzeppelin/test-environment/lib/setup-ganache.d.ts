interface ErrorMessage {
    type: 'error';
}
interface ReadyMessage {
    type: 'ready';
    port: number;
}
export declare type Message = ErrorMessage | ReadyMessage;
export declare type AccountConfig = {
    balance: string;
    secretKey: string;
};
export declare type NodeOptions = {
    accounts: AccountConfig[];
    coverage: boolean;
    gasPrice?: string;
    gasLimit?: number;
    allowUnlimitedContractSize?: boolean;
    fork?: string;
    unlocked_accounts?: string[];
};
export default function (): Promise<string>;
export {};
//# sourceMappingURL=setup-ganache.d.ts.map
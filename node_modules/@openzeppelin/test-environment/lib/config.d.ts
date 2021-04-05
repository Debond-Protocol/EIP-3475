import type { Provider } from './provider';
interface InputConfig {
    accounts: {
        amount: number;
        ether: number;
    };
    contracts: {
        type: string;
        defaultGas: number;
        defaultGasPrice: number;
        artifactsDir: string;
    };
    blockGasLimit?: number;
    gasPrice?: number;
    setupProvider: (baseProvider: Provider) => Promise<Provider>;
    coverage: boolean;
    node: {
        gasLimit?: number;
        gasPrice?: number | string;
        allowUnlimitedContractSize?: boolean;
        fork?: string;
        unlocked_accounts?: string[];
    };
}
export declare type Config = InputConfig & {
    node: {
        gasPrice?: string;
    };
};
export declare const DEFAULT_BLOCK_GAS_LIMIT = 8000000;
export declare function getConfig(): Config;
declare const _default: Config;
export default _default;
//# sourceMappingURL=config.d.ts.map
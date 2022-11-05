# Metadata  standards

This documentation consists of various JSON schemas (examples or standards) that can be referenced by the reader of this EIP for implementing EIP-3475 bonds storage.

## 1. Description metadata:

```json 
[
    {
        "title": "defining the title information",
        "_type": "explaining the type of the title information added",
        "description": "little description about the information stored in  the bond",
    }
]
```

Example: adding details in bonds describing the local jurisdiction of the bonds where it's issued:

```json
{
"title": "localisation",
"_type": "string",
"description": "jurisdiction law codes compatibility"
"values": ["fr ", "de", "ch"]
}
```
The 'values' field defined above  can also be ISO codes or other hex standard representation.
## 2. Nonce metadata:

- **Information defining the state of the bond**

```json
[	
	{	
	"title": "maturity",
	"_type": "uint",
	"description": "Lorem ipsum...",
	"values": [0, 0, 0]
	}
]
```


## 3. Class metadata:

```json

[ 
	{	
	"title": "symbol",
	"_type": "string",
	"description": "Lorem ipsum...",
	"values": ["Class symbol 1", "Class symbol 2", "Class symbol 3"],
	},

	{	
	"title": "issuer",
	"_type": "string",
	"description": "Lorem ipsum...",
	"values": ["Issuer name 1", "Issuer name 2", "Issuer name 3"],
	},

	{	
	"title": "issuer_address",
	"_type": "address",
	"description": "Lorem ipsum...",
	"values":["Address 1.", "Address 2", "Address 3"]
	},

	{	
	"title": "class_type",
	"_type": "string",
	"description": "Lorem ipsum...",
	"values": ["Class Type 1", "Class Type 2", "Class Type 3"]
	},

	{	
	"title": "token_address",
	"_type": "address",
	"description": "Lorem ipsum...",
	"values":["Address 1.", "Address 2", "Address 3"]
	},

	{	
	"title": "period",
	"_type": "uint",
	"description": "Lorem ipsum...",
	"values": [0, 0, 0]
	}
]
```
## Examples of other standards:
    - ISO-20022 standard is the recently adopted standard by banks for communicating  financial operators (Banks, trading intermediaries, underwriters) that also include bond operations. 

## Bond issuance standard for the Debond-Protocol: 

For the bond issuers that are interesed to be listed on the debond-protocol, they need to define the following protocol details: 


```json
[
{	
	"title": "Issuer",
	"_type": "string",
	"description": "formal name of the bond issuer",
	"values": "ABC"
}, 

{	
	"title": "Issuer Location",
	"_type": "string",
	"description": "Address of the esthablished office & Jurisdiction",
	"values": ["1st avenue NYK", "US"]
},
	{	
	"title": "Issuer URL",
	"_type": "string",
	"description": "URL link of the website",
	"values": "www.ABC.AI"
	}
,
	{	
	"title": "Issuer logo details",
	"_type": "string",
	"description": "URL of stored issuer logo/ media kit details",
	"values": "www.ABC.AI/media"
	}
,

	{	
	"title": "Registered Authority",
	"_type": "uint",
	"description": "authorities  that regulates  the bond issuance in the jurisdiction",
	"values": ["SEC"],
	},

	{	
	"title": "pitch URL",
	"_type": "string",
	"description": "link to the pitchdeck",
	"values": ["bit.ly/ABC_pitch.pdf"]
	},
	{	
	"title": "Industry",
	"_type": "string",
	"description": "the subcategory of the industry the company is associated",
	"values": ["web3"]
	},
	{	
	"title": "ISIN code",
	"_type": "uint",
	"description": "defining the idntifier code of the security(https://www.investopedia.com/terms/i/isin.asp)",
	"values": [" US-000402625-0"]
	},
	{	
	"title": "Manager name",
	"_type": "string",
	"description": "Person responsible for the management (consulting firm hadnling the bond issuance and entities )",
	"values": ["Mr Joe"]
	},
	
	{	
	"title": "Manager code",
	"_type": "string",
	"description": "Person responsible for the management (founder or the majority owner of shares)",
	"values": ["Mr Joe"]
	},
	
	{	
	"title": "Date position",
	"_type": "string",
	"description": "ISO-8601 representation of intended date of issuance of the bonds onchain",
	"values": ["2022-10-30T12:52:01+0000"]
	},
	{
	"title": "Manager's code",
	"_type": "integer",
	"description": " Legal Entity Identifier (LEI) for defining the responsible regarding the isuance of bond/ securities.",
	"values": [8958801496],
	},
	{
	"title": "Custodian name",
	"_type": "string",
	"description": " Registered entity name of the entity provding the custodian services of bonds",
	"values": ["Fireblocks LLC"],
	},
	{
	"title": "Custodian Code",
	"_type": "integer",
	"description": "LEI defining the custodian services of bonds",
	"values": [8958801496],
	},
	{
	"title": "Share Value",
	"_type": "integer",
	"description": "defines the USD equivalent value of bond at the time of issuance",
	"values": [8958801496],
	},
	{
	"title": "Total Balance",
	"_type": "integer",
	"description": "defines the total number of bonds being instantiated since the start . this supply constitutes available supply + redemmed supply + burned supply",
	"values": [100],
	},
	{
	"title": "Amounts Payable",
	"_type": "integer",
	"description": "this is the amount of bonds that are issued till date",
	"values": [70],
	},
	{
	"title": "Collateral",
	"_type": "string",
	"description": "code for the various asset class (crypto/fiat currencies) in which the amount is denominated",
	"values": ["USDC", "EUR"],
	},
	{
	"title": "Callable",
	"_type": "Boolean",
	"description": "boolean identifying whether the bond is of type callable",
	"values": [False],
	},
	{
	"title": "Zero-coupon",
	"_type": "Boolean",
	"description": "boolean identifying whether the bond is of type Zero-coupon",
	"values": [True],
	},	
	{
	"title": "Fixed-rate",
	"_type": "Boolean",
	"description": "boolean identifying whether the bond is of type Fixed rate",
	"values": [True],
	},
	{
	"title": "Maturity period",
	"_type": "integer",
	"description": "defines the time (in months) for the bonds to be able to redeemed(unless not a callable bond)",
	"values": [6],
	},
	{
	"title": "Maturity calculation rule",
	"_type": "string",
	"description": "defines the formula (encoded in string) that will determine the redeemed value (with interest)",
	"values": ["redeemValue=(1.06)*DateValue"],
	},

	{
	"title": "Interest period",
	"_type": "string",
	"description": "defines the time (in months) from the issuance during which holder wil be accuring interest (till redemption time)",
	"values": [6],
	},
	{
	"title": "Interest calculation formula",
	"_type": "string",
	"description": "formula (in string) being used in order to calculate the coupon rate interest (ref: ) ",
	"values": ["interstCalcRate = AnnualCoupon/(parValueOfBond)"],
	},
	{
	"title": "Accept asset",
	"_type": "string",
	"description": "defines the collateral assets currently accepted by bond issuer from lender",
	"values": ["USDT", "EUR"],
	},
	{
	"title": "Interest Payment Asset",
	"_type": "string",
	"description": "defines the  tokens (ERC20/fiat) currently accepted by bond issuer to pay interest(if different from Accept Asset/ underlying collateral) ",
	"values": ["GBP", "JNY"],
	},
	{
	"title": "Repayment Asset",
	"_type": "string",
	"description": "defines the  assets (ERC20/fiat) currently accepted by bond issuer to repay after redemption ",
	"values": ["GBP", "JNY"],
	},
	{
	"title": "ANBID code",
	"_type": "string",
	"description": "defines the identification code from the Brazillian association of investment banks (ANBID)(https://www.anbima.com.br/en_us/institucional/a-anbima/quem-somos.htm)",
	"values": ["100000"],
	},
	{
	"title": "Fund type",
	"_type": "string",
	"description": "defines the category of the investment vehicle associated with this bond",
	"values": ["corporate"],
	},
	{
	"title": "Risk Level",
	"_type": "string",
	"description": "defines the risk category assigned by the credit scoring agencies",
	"values": ["AA-"],
	},
	{
	"title": "Risk level rated by",
	"_type": "string",
	"description": "name of the company that analysed the risk rating",
	"values": ["Standard and Poor"],
	},
	{
	"title": "Preferred Creditor",
	"_type": "string",
	"description": "from investopedia: Its an individual or organization that has priority in being paid the money it is owed if the debtor declares bankruptcy.",
	"values": ["a55"],
	},

	{
	"title": "Liquidation Rule",
	"_type": "string",
	"description": "Defines the condition (metrics on debt or the collateral risk in string) under which the liquidation of bonds takes place",
	"values": ["Price-depeg >= 10%", "collateral-ratio-of-fund <= 110%"],
	},
	{
	"title": "Qualified investor requirement",
	"_type": "string",
	"description": "Defines the conditions (metrics on net holdings, lender minimum ticket etc) that lender needs to have in order to participate in buying bonds ",
	"values": ["Minimum-investment-collateral >= 10,000 USDC", "Credit-scoring >= B"],
	},
	{
	"title": "Interest rate",
	"_type": "int",
	"description": "Fixed interst rate for the bond holders (in %)",
	"values": [6],
	},
	{
	"title": "The Amount",
	"_type": "int",
	"description": "Defines the fixed total supply of the bond",
	"values": [10000],
	},
	{
	"title": "Asset Value",
	"_type": "int",
	"description": "Defines the face value of the bond ",
	"values": [10000],
	},

	{
	"title": "PL (Profit & Loss statement) of the Fund:",
	"_type": "uint",
	"description": "(From investopedia) summarizes the revenues, costs, and expenses incurred during a specified period, usually a quarter or fiscal year",
	"values": ["revenue = 1 million $", "costs = 500,000 $"],
	},

	{
	"title": "Quotas to Issue:",
	"_type": "string",
	"description": "Defines the Bonds supply (out of total supply) that are available for issuers  on the marketplace",
	"values": [50],
	},

	{
	"title": "Quotas to be redeemed",
	"_type": "int",
	"description": "Defines the bonds supply that can be redeemed by the lender after redemption condition is received",
	"values": [40],
	},
	{
	"title": "Number of shareholders",
	"_type": "int",
	"description": "number of the entities that are participating as the potential lenders",
	"values": [99],
	},

]

```





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


## 3. Comment Class metadata:

```json

[
   {
      "metadataId":"0001",
      "title":"symbol",
      "_type":"string",
      "description":"name of the token",
      "values":"D/BOND fix rate (6m) DBGT Bond"
   },
   {
      "metadataId":"0002",
      "title":"category",
      "_type":"string",
      "description":"The category of this financial token",
      "values":"security"
   },
   {
      "metadataId":"0003",
      "title":"subcategory",
      "_type":"string",
      "description":"The subcategory of this financial token",
      "values":"bond"
   },
   {
      "metadataId":"0004",
      "title":"childCategory",
      "_type":"string",
      "description":"The child category of this financial token",
      "values":"zero-coupon callable bond"
   },
   {
      "metadataId":"0005",
      "title":"description",
      "_type":"string",
      "description":"The description of this token",
      "values":"zero-coupon callable bond"
   },
   {
      "metadataId":"0100",
      "title":"issuerName",
      "_type":"string",
      "description":"formal name of the issuer",
      "values":"ABC "
   },
   {
      "metadataId":"0101",
      "title":"issuerType",
      "_type":"string",
      "description":"Organization‘s type",
      "values":"LTD"
   },
   {
      "metadataId":"0102",
      "title":"issuerJurisdiction",
      "_type":"string",
      "description":"jurisdiction of the issuer",
      "values":"US"
   },
   {
      "metadataId":"0103",
      "title":"issuerRegistrationAddress",
      "_type":"string",
      "description":"Registrated address of the entity",
      "values":"1st avenue NYK"
   },
   {
      "metadataId":"0104",
      "title":"issuerURL",
      "_type":"string",
      "description":"URL link of the website",
      "values":"https://www.ABC.AI"
   },
   {
      "metadataId":"0105",
      "title":"issuerLogo",
      "_type":"string",
      "description":"URL of stored issuer logo/ media kit details in 64*64 pix png format",
      "values":"https://www.ABC.AI/logo.png"
   },
   {
      "metadataId":"0106",
      "title":"issuerRegistrationNumber",
      "_type":"string",
      "description":"The registration number of the issuer’s entity",
      "values":"000000000000"
   },
   {
      "metadataId":"1007",
      "title":"issuerDocURL",
      "_type":"string",
      "description":"link to the issuer's documents",
      "values":[
         "https://bit.ly/ABC_pitch.pdf",
	 "https://bit.ly/ABC_pitch.pdf"
      ]
   },
   {
      "metadataId":"1008",
      "title":"issuerIndustry",
      "_type":"string[]",
      "description":"the registered industry the issuer is associated",
      "values":[
         "software development",
         "banking software development"
      ]
   },
   {
      "metadataId":"1009",
      "title":"issuerChainAddress",
      "_type":"address",
      "description":"the public key address of the issuer",
      "values":"0x9f91Cb042e4C6F4F9561d214Fd5741621027eFB4"
   },
   {
      "metadataId":"1020",
      "title":"debitorName",
      "_type":"string",
      "description":"formal name of the debitor",
      "values":"ABC "
   },
   {
      "metadataId":"1021",
      "title":"debitorType",
      "_type":"string",
      "description":"Organization‘s type",
      "values":"LTD"
   },
   {
      "metadataId":"1022",
      "title":"debitorJurisdiction",
      "_type":"string",
      "description":"jurisdiction of the debitor",
      "values":"US"
   },
   {
      "metadataId":"1023",
      "title":"debitorRegistrationAddress",
      "_type":"string",
      "description":"Address of the established office",
      "values":"1st avenue NYK"
   },
   {
      "metadataId":"1024",
      "title":"debitorURL",
      "_type":"string",
      "description":"URL link of the website",
      "values":"https://www.ABC.AI"
   },
   {
      "metadataId":"1025",
      "title":"debitorLogo",
      "_type":"string",
      "description":"URL of stored issuer logo/ media kit details in 64*64 pix png format",
      "values":"https://www.ABC.AI/logo.png"
   },
   {
      "metadataId":"1026",
      "title":"debitorRegistrationNumber",
      "_type":"string",
      "description":"The registration number of the debitor’s entity",
      "values":"000000000000"
   },
   {
      "metadataId":"1027",
      "title":"debitorDocURL",
      "_type":"string",
      "description":"link to the documents",
      "values":[
         "https://bit.ly/ABC_pitch.pdf",
	 "https://bit.ly/ABC_pitch.pdf"
      ]
   },
   {
      "metadataId":"1028",
      "title":"debitorIndustry",
      "_type":"string[]",
      "description":"the registered industry the debitor is associated",
      "values":[
         "software development",
         "banking software development"
      ]
   },
   {
      "metadataId":"1029",
      "title":"debitorChainAddress",
      "_type":"address",
      "description":"the public key address of the debitor",
      "values":"0x9f91Cb042e4C6F4F9561d214Fd5741621027eFB4"
   },
   {
      "metadataId":"1030",
      "title":"custodianName",
      "_type":"string",
      "description":"formal name of the custodian",
      "values":"ABC "
   },
   {
      "metadataId":"1031",
      "title":"custodianType",
      "_type":"string",
      "description":"Organization‘s type",
      "values":"LTD"
   },
   {
      "metadataId":"1032",
      "title":"custodianJurisdiction",
      "_type":"string",
      "description":"jurisdiction of the custodian",
      "values":"US"
   },
   {
      "metadataId":"1033",
      "title":"custodianRegistrationAddress",
      "_type":"string",
      "description":"Address of the established office",
      "values":"1st avenue NYK"
   },
   {
      "metadataId":"1034",
      "title":"custodianURL",
      "_type":"string",
      "description":"URL link of the website",
      "values":"https://www.ABC.AI"
   },
   {
      "metadataId":"1035",
      "title":"custodianLogo",
      "_type":"string",
      "description":"URL of stored custodian's logo/ media kit details in 64*64 pix png format",
      "values":"https://www.ABC.AI/logo.png"
   },
   {
      "metadataId":"1036",
      "title":"custodianRegistrationNumber",
      "_type":"string",
      "description":"The registration number of the custodian’s entity",
      "values":"000000000000"
   },
   {
      "metadataId":"1037",
      "title":"custodianDocURL",
      "_type":"string[]",
      "description":"link to the documents",
      "values":[
         "https://bit.ly/ABC_pitch.pdf",
	 "https://bit.ly/ABC_pitch.pdf"
      ]
   },
   {
      "metadataId":"1038",
      "title":"custodianIndustry",
      "_type":"string[]",
      "description":"the registered industry the custodian is associated",
      "values":[
         "software development",
         "banking software development"
      ]
   },
   {
      "metadataId":"1039",
      "title":"custodianChainAddress",
      "_type":"address",
      "description":"the public key address of the custodian",
      "values":"0x9f91Cb042e4C6F4F9561d214Fd5741621027eFB4"
   },
    {
      "metadataId":"1040",
      "title":"auditorName",
      "_type":"string",
      "description":"formal name of the auditor",
      "values":"ABC "
   },
   {
      "metadataId":"1041",
      "title":"auditorType",
      "_type":"string",
      "description":"Organization‘s type",
      "values":"LTD"
   },
   {
      "metadataId":"1042",
      "title":"auditorJurisdiction",
      "_type":"string",
      "description":"jurisdiction of the auditor",
      "values":"US"
   },
   {
      "metadataId":"1043",
      "title":"auditorRegistrationAddress",
      "_type":"string",
      "description":"Address of the established office",
      "values":"1st avenue NYK"
   },
   {
      "metadataId":"1044",
      "title":"auditorURL",
      "_type":"string",
      "description":"URL link of the website",
      "values":"https://www.ABC.AI"
   },
   {
      "metadataId":"1045",
      "title":"auditorLogo",
      "_type":"string",
      "description":"URL of stored auditor's logo/ media kit details in 64*64 pix png format",
      "values":"https://www.ABC.AI/logo.png"
   },
   {
      "metadataId":"1046",
      "title":"auditorRegistrationNumber",
      "_type":"string",
      "description":"The registration number of the auditor’s entity",
      "values":"000000000000"
   },
   {
      "metadataId":"1047",
      "title":"auditorDocURL",
      "_type":"string",
      "description":"link to the documents",
      "values":[
         "https://bit.ly/ABC_pitch.pdf"
      ]
   },
   {
      "metadataId":"1048",
      "title":"auditorIndustry",
      "_type":"string[]",
      "description":"the registered industry the auditor is associated",
      "values":[
         "software development",
         "banking software development"
      ]
   },
   {
      "metadataId":"1049",
      "title":"auditorChainAddress",
      "_type":"address",
      "description":"the public key address of the auditor",
      "values":"0x9f91Cb042e4C6F4F9561d214Fd5741621027eFB4"
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
      "metadataId":"2000",
      "title":"securityRegisteredAuthority",
      "_type":"integer",
      "description":"authorities that regulates the security issuance in the jurisdiction",
      "values":"BIS"
   },
   {
      "metadataId":"2001",
      "title":"ISIN",
      "_type":"integer",
      "description":"defining the identifier code of the security(https://www.investopedia.com/terms/i/isin.asp)",
      "values":" US-000402625-0"
   },
   {
      "metadataId":"2002",
      "title":"fundType",
      "_type":"string",
      "description":"defines the category of the investment vehicle associated with this bond",
      "values":"corporate"
   },
   {
      "metadataId":"2003",
      "title":"riskLevel",
      "_type":"string",
      "description":"defines the risk category assigned by the auditor",
      "values":"AA"
   },
   {
      "metadataId":"2004",
      "title":"intendedDate",
      "_type":"integer",
      "description":"ISO-8601 representation of intended date of issuance of the security",
      "values":"1676038570"
   },
   {
      "metadataId":"2005",
      "title":"shareValue",
      "_type":"integer",
      "description":"defines the value of bond at the time of issuance",
      "values":"900000000"
   },
   {
      "metadataId":"2006",
      "title":"totalBalance",
      "_type":"integer",
      "description":"defines the total number of securities being instantiated since the start . this supply constitutes available supply + redeemed supply + burned supply",
      "values":"100000"
   },
   {
      "metadataId":"2007",
      "title":"amountsPayable",
      "_type":"integer",
      "description":"this is the amount of securities that are issued till date",
      "values":"10000000"
   },
   {
      "metadataId":"2008",
      "title":"currency",
      "_type":"string",
      "description":"code for the asset in which the amount is denominated",
      "values":"USD"
   },
   {
      "metadataId":"2009",
      "title":"collateralAllowed",
      "_type":"address[]",
      "description":"code for the various asset class (crypto/CBDC) in which the amount is denominated",
      "values":[
         "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
         "0x55d398326f99059ff775485246999027b3197955"
      ]
   },
   {
      "metadataId":"2010",
      "title":"Callable",
      "_type":"boolean",
      "description":"boolean identifying whether the bond is of type callable",
      "values":"True"
   },
   {
      "metadataId":"2011",
      "title":"maturityPeriod",
      "_type":"integer",
      "description":"ISO 8601 seconds of the coupon period for the securities to be able to redeemed(unless not a callable bond)",
      "values":"31104000"
   },
   {
      "metadataId":"2012",
      "title":"specialMaturityRule",
      "_type":"string",
      "description":"defines the specified rules, which defines if the security is matured",
      "values":"when USD/EURO rate is lower than 0.8 for 5 business days"
   },
   {
      "metadataId":"2020",
      "title":"coupon",
      "_type":"boolean",
      "description":"If the bond is with coupons",
      "values":"True"
   },
   {
      "metadataId":"2021",
      "title":"couponRate",
      "_type":"integer",
      "description":"PPM coupon rate",
      "values":"50000"
   },
   {
      "metadataId":"2022",
      "title":"couponPeriod",
      "_type":"integer",
      "description":"ISO 8601 seconds of the coupon period",
      "values":"2592000"
   },
   {
      "metadataId":"2030",
      "title":"fixed-rate",
      "_type":"boolean",
      "description":"boolean identifying whether the bond is of type Fixed rate",
      "values":"True"
   },
   {
      "metadataId":"2031",
      "title":"interestPeriod",
      "_type":"integer",
      "description":"ISO 8601 seconds from the issuance during which holder will be accruing interest (till redemption time)",
      "values":"2592000"
   },
   {
      "metadataId":"2032",
      "title":"interestRate",
      "_type":"integer",
      "description":"PPM interest rate of the security",
      "values":"50000"
   },
   {
      "metadataId":"2033",
      "title":"interestCalculation",
      "_type":"string",
      "description":"formula (in string) being used in order to calculate the coupon rate interest (ref: ) ",
      "values":"interstCalcRate = AnnualCoupon/(parValueOfBond)"
   },
   {
      "metadataId":"2034",
      "title":"interestPaymentAsset",
      "_type":"address[]",
      "description":"defines the tokens/CBDC accepted by bond issuer to pay interest(if different from Accept Asset/ underlying collateral) ",
      "values":[
         "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
         "0x55d398326f99059ff775485246999027b3197955"
      ]
   },
   {
      "metadataId":"2035",
      "title":"repaymentAsset",
      "_type":"address[]",
      "description":"defines the assets/CBDC accepted by bond issuer to repay after redemption ",
      "values":[
         "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
         "0x55d398326f99059ff775485246999027b3197955"
      ]
   },
   {
      "metadataId":"2040",
      "title":"liquidationRule",
      "_type":"string",
      "description":"Defines the condition (metrics on debt or the collateral risk in string) under which the liquidation of securities takes place",
      "values":"Price-depeg >= 10%, collateral-ratio-of-fund <= 110%"
   },
   {
      "metadataId":"2041",
      "title":"preferredCreditor",
      "_type":"string",
      "description":"Defines the priorities of the repayment after the debtor declares bankruptcy.",
      "values":"Class 1 will always receive 100% of the repayment Class 2 the remainings"
   },
   {
      "metadataId":"2050",
      "title":"qualifiedInvestorRequirement",
      "_type":"string",
      "description":"Defines the conditions (metrics on net holdings, lender minimum ticket etc) that lender needs to have in order to participate in buying securities ",
      "values":"Earning more than 100000 USD per year"
   },
   {
      "metadataId":"2060",
      "title":"APY",
      "_type":"integer",
      "description":"Fixed PPM interest rate for the bond holders (in %)",
      "values":"60000"
   },
   {
      "metadataId":"2071",
      "title":"quotasToIssue:",
      "_type":"string",
      "description":"Defines the securities supply (out of total supply in ppm) that are available for issuers  on the marketplace",
      "values":"600000"
   },
   {
      "metadataId":"2072",
      "title":"quotasToBeRedeemed",
      "_type":"integer",
      "description":"Defines the securities supply that can be redeemed by the lender after redemption condition is received",
      "values":"100000"
   },
   {
      "metadataId":"2073",
      "title":"numberOfShareholders",
      "_type":"integer",
      "description":"number of the entities that are participating as the potential lenders",
      "values":"200"
   }
]


```





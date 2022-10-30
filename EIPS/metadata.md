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
	"title": "Manager code",
	"_type": "string",
	"description": "identifier code of the manager entity (based on the standards as defiend in (https://stockmarketmba.com/securityidentifiers.php)",
	"values": ["2022-10-30T12:52:01+0000"]
	},
	{	
	"title": "Custodian name",
	"_type": "string",
	"description": "name of the solution ^providing the custodian solution",
	"values": ["fireblocks"]
	},
]

```





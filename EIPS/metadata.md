# metadata  standards 


this documentation consist of various example  JSON schemas (examples or standards) that can be referenced by the reader of EIP for implementing EIP-3475 bonds storage.


## 1. Description metadata: 

```json 
[
    {
        "title": "defining the title information",
        "type": "explaining the type of the title information added",
        "description": "little description about the information stored in  the bond",
    }
]
```

example: adding details in bonds describing the local jurisdiction of the bonds where its valid/ is issued:

```json
{
"title": "localisation",
"type": "string",
"description": "jurisdiction law codes  compatiblity "
"value": ["fr ", "de", "ch"] // can also be ISO codes 
}
```

## 2. Nonce information:

- **Information defining the state of the bond** 

```json
[	
	{	
	"title": "symbol",
	"type": "str",
	"description": "Lorem ipsum..."
	"value": ["Class symbol 1", "Class symbol 2", "Class symbol 3"],
	},

	{	
	"title": "issuer",
	"type": "str",
	"description": "Lorem ipsum..."
	"value": ["Issuer name 1", "Issuer name 2", "Issuer name 3"],
	},

	{	
	"title": "issuer_address",
	"type": "address",
	"description": "Lorem ipsum..."
	"value":["Address 1.", "Address 2", "Address 3"]
	},

	{	
	"title": "class_type",
	"type": "str",
	"description": "Lorem ipsum..."
	"value": ["Class Type 1", "Class Type 2", "Class Type 3"]
	},

	{	
	"title": "token_address",
	"type": "address",
	"description": "Lorem ipsum..."
	"value":["Address 1.", "Address 2", "Address 3"]
	},

	{	
	"title": "period",
	"type": "int",
	"description": "Lorem ipsum..."
	"value": ["", "", ""]
	}
]

- **Nonce Metadata**
[
	{	
	"title": "maturity",
	"type": "int",
	"description": "Lorem ipsum..."
	"value": ["", "", ""]
	}
]
```


## 3. Class Information:

```json
    {
"title": "symbol",
"type": "str",
"description": "Lorem ipsum..."
"value": ["Class Name 1", "Class Name 2", "DBIT Fix 6M"],
}
```
## TODO, defining example schemas for actual fintech standards : 
- ISO-20022 standard is  the recent adopted standard by banks for communicating the financial operations =. 
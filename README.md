# DynamoDB - CLI

### Create Table

```
aws dynamodb create-table \
	--table-name StarFleet \
	--attribute-definitions \
		AttributeName=Registry,AttributeType=S \
		AttributeName=ShipClass,AttributeType=S \
	--key-schema \
		AttributeName=ShipClass,KeyType=HASH \
		AttributeName=Registry,KeyType=RANGE \
	--provisioned-throughput \
		ReadCapacityUnits=5,WriteCapacityUnits=5 \
	--region us-east-1
```

### Describe Table

`aws dynamodb describe-table --table-name StarFleet`

### Insert Items

```
aws dynamodb batch-write-item --request-items file://batches/batch-001.json
aws dynamodb batch-write-item --request-items file://batches/batch-002.json
aws dynamodb batch-write-item --request-items file://batches/batch-003.json
aws dynamodb batch-write-item --request-items file://batches/batch-004.json
aws dynamodb batch-write-item --request-items file://batches/batch-005.json
aws dynamodb batch-write-item --request-items file://batches/batch-006.json
aws dynamodb batch-write-item --request-items file://batches/batch-007.json
aws dynamodb batch-write-item --request-items file://batches/batch-008.json
aws dynamodb batch-write-item --request-items file://batches/batch-009.json
aws dynamodb batch-write-item --request-items file://batches/batch-0010.json
```

Each batch should have at most 25 items

### Get Item

`aws dynamodb get-item --table-name StartFleet --key file://key.json`

**Key.json**

```json
{
	"ShipClass": {"S": "Luna"},
	"Registry": {"S": "NCC-80102"}
}
```

### Batch Get Item

`aws dynamodb batch-get-item --request-items file://request-items.json`

```json
{
    "StarFleet":{
        "Keys":[
            {
                "ShipClass": {"S": "Luna"},
                "Registry": {"S": "NCC-80102"} 
            },
            {
                "ShipClass": {"S": "Constellation"},
                "Registry": {"S": "NCC-1974"} 
            },
            {
                "ShipClass": {"S": "Crossfield"},
                "Registry": {"S": "NCC-1029"} 
            },
            {
                "ShipClass": {"S": "Crossfield"},
                "Registry": {"S": "NCC-1031"} 
            }
        ]
    }
}
```

### Delete Item

`aws dynamodb delete-item --table-name StarFleet --key file://key.json`

### Put Item

`aws dynamodb put-item --table-name StarFleet --item file://item.json`

### Update Item

```json
aws dynamodb update-item \
    --table-name MusicCollection \
    --key file://key.json \
    --update-expression "SET #N = :N" \
    --expression-attribute-names file://expression-attribute-names.json \
    --expression-attribute-values file://expression-attribute-values.json  \
    --return-values ALL_NEW \
    --return-consumed-capacity TOTAL \
    --return-item-collection-metrics SIZE
```

expression-attribute-names.json

```json
{
    "#N":"Name"
}
```

expression-attribute-values.json

```json
{
    ":N":{"S": "Ultra Cool Ship"}
}
```

> --update-expression "SET #N = :N" \
    --expression-attribute-names file://expression-attribute-names.json \
    --expression-attribute-values file://expression-attribute-values.json  \
These three allows to temporary map or rename attributes
> 

### Scan

Get all items in the table, then apply filters to get the result you want

Not efficient and use a lot capacity

You dont have to include if you want all attribute  `--projection-expression "#ST, #AT" --expression-attribute-names`

```json
aws dynamodb scan \
    --table-name StarFleet \
    --filter-expression "ShipClass = :SC" \
    --expression-attribute-values '{":SC": {"S": "Luna"}}'
```

```json
aws dynamodb scan \
    --table-name StarFleet \
    --filter-expression "contains(Description, :d)" \
    --expression-attribute-values '{":d": {"S": "Cap"}}'
```

```json
aws dynamodb scan \
    --table-name StarFleet \
    --filter-expression "ShipClass = :SC" \
    --projection-expression "#ST, #AT" \
    --expression-attribute-names file://expression-attribute-names.json \
    --expression-attribute-values file://expression-attribute-values.json
```

expression-attribute-names.json

```json
{
    "#ST": "SongTitle",
    "#AT":"AlbumTitle"
}
```

expression-attribute-values.json

```json
{
    ":SC": {"S": "Luna"}
}
```

### Query

Use Whole Primary Key locate the item, or use only the Partition Key to locate a set of items.

Then apply filter on it

```json
aws dynamodb query \
    --table-name StarFleet \
    --key-condition-expression "ShipClass = :SC" \
    --expression-attribute-values '{":SC": {"S": "Luna"}}' \
    --return-consumed-capacity TOTAL
```
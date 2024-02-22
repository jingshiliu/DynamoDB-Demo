for (let i = 1; i <= 12; i++) {
    console.log(`aws dynamodb batch-write-item --request-items file://batches/batch-00${i}.json`)
}
require 'csv'
require 'json'

batches = []
count = 25
CSV.read("starfleet.csv","r:ISO-8859-1", headers: true).each do |line|
  if count == 25
    batches.push({"StarFleet" => []})
    count = 1 
  end
  
  batches.last["StarFleet"].push({
    "PutRequest" => {
      "Item" => {
        "Registry"    => { "S" => line['registry']},
        "Name"        => { "S" => line['name']},
        "ShipClass"   => { "S" => line['ship_class']},
        "Description" => { "S" => line['description']}
      }
    }
  })
  count = count + 1
end

batches.each_with_index do |batch,i|
  json = JSON.pretty_generate batch
  File.write "batches/batch-#{i.to_s.rjust(3,'0')}.json", json
end
# README

This Project is a challenge that envolve [GIS](https://en.wikipedia.org/wiki/Geographic_information_system)

## Supported flows
 - [x] Register a partner
 - [x] Search partner by id
 - [x] Search nearst partner by coordinates
 - [x] Healthcheck

### Technologies
- Rails
- Ruby
- PostGIS

### Development choices
Considering that this project is a POC but is an interview challenge too,
i chose some approaches that could be discutible:

- Avoid mutability
- Avoid magic gems
- Avoid some rails patterns
- Testing just API calls
- PR's without unit tests
- PR's with poor description

## Running this project
clone
```shell
git clone git@github.com:KingArtos/my-coverage.git
```

docker run
```shell
docker-compose build
docker-compose up -d
```

To register a partner
```shell
curl -d '{
  "id": 100,
  "tradingName": "Adega da Cerveja - Pinheiros",
  "ownerName": "Zé da Silva",
  "document": "1432132123891/1111",
  "coverageArea": {
    "type": "MultiPolygon",
    "coordinates": [
      [[[30, 20], [45, 40], [10, 40], [30, 20]]],
      [[[15, 5], [40, 10], [10, 20], [5, 10], [15, 5]]]
    ]
  },
  "address": {
    "type": "Point",
    "coordinates": [-46.57421, -21.785741]
  }
}' -i -H "Content-Type: application/json" -X POST http://localhost:3000/partners
```

To get
http://localhost:3000/partners/1

To nearst
http://localhost:3000/partners/nearst/-46.65285/-23.62214

### Possible improvements
- [ ] Add datadog
- [ ] Benchmark with mongoDB / Elasticsearch / PostGIS
- [ ] Analyze object creation / indexes (new indexed field with low accuracy coverage area)
- [ ] Analyze split multiPolygon in polygons
- [ ] Analyze split Coverage area in lower polygons
- [ ] Analyze geoHash
- [ ] Analyze cache possibility

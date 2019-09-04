# CzFaker API server

API to call CzFaker via REST/JSON API

## Technology

* CzFaker
* Sinatra
* Puma

##  Usage

Start puma server on server and call via HTTP, method is allways GET:

* URL: `http[s]://<server>:<port>/<class>/<method>?<params>`
* URL example: `http://localhost:4567/energy/ean?dist_code=EON`

### Run via bash

``` bash
bundle install
bundle exec puma -C puma.rb
```

### Run via docker

```bash
docker build . -t czfaker-api
docker run --rm -p 4567:4567 --name czfaker-api czfaker-api:latest
```

### Call

* call

```bash
curl "http://localhost:4567/energy/ean?dist_code=EON"
curl "http://localhost:4567/validator/energy/ean?code=859182400100564049"

```

* response

```json
{
  "call": "CzFaker::Energy.ean(nil,:EON)",
  "result": "859182400200000829"
}
```

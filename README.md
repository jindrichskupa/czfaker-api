# CzFaker API server

API to call CzFaker via REST/JSON API

##  Usage

Start puma server on server and call via HTTP, method is allways GET:

* URL: `http[s]://<server>:<port>/<class>/<method>?<params>`
* URL example: `http://localhost:4567/energy/ean?dist_code=EON`

### Run

``` bash
bundle install
bundle exec puma -C puma.rb
```

### Call

* call

```bash
curl "http://localhost:4567/energy/ean?dist_code=EON"
```

* response

```json
{
  "call": "CzFaker::Energy.ean(nil,:EON)",
  "result": "859182400200000829"
}
```

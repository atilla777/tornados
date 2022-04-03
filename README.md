# Tornados

Tornados is a library and cli tool to automate downloading tor exit nodes list and enrich this list by geo ip info.
For Tor exit nodes list [this](https://github.com/SecOps-Institute/Tor-IP-Addresses) source is used. 
For enrichment [GeoLite2 Free Geolocation Data](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data?lang=en) is used.

## Cli tool

When tornados used as cli tool it download ip addresses into memory, then download ip geolocation base and save it as GeoLite2-Country.mmdb into current directory.

Finally it create in current directory csv file tor_exit_nodes_list.csv where first column is a tor exit node ip address, second column is a country ISO code (RU for example) and third column is country name string.

To install
```bash
gem install tornados
```

To use
```bash
tornados
```
After this, tor_exit_nodes_list.csv will be created in current directory.

You can use this file in SIEM, for example, to detection malicious network traffic.

## Library

For use tornados in your ruby application:
add to Gemfile
```ruby
gem "tronados"
```
in code 
```ruby
require "tornados"
```
Now you can use tornado services (see below).

### Tornados::NodesFetcher

```ruby
Tornados::NodesFetcher.call
```
returns array of arrays whith next format
[[ip address 1], [ip address 2] ... [ip address N]]

### Tornados::MaxDbFetcher

```ruby
Tornados::MaxDbFetcher.call
```
download to disk max db file and return path to it

## Tornados::GeoEnrich

```ruby
Tornados::GeoEnrich.call(tor_exit_nodes, geobase_file_path)
```
add to ip array, two columns with geo ip info
[[ip address 1, ISO code, country name], ...]

## Tornados::CsvFormater

```ruby
Tornados::CsvFormater.call(enriched_tor_exit_nodes)
```
create csv string from ip list array

## Tornados::FileWriter

```ruby
Tornados::FileWriter.call(csv_enriched_tor_exit_nodes, result_file)
```
write csv file to disk

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tornado.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

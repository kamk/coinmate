# CoinMate

This rubygem provides an interface for API requests to [coinmate.io](https://www.coinmate.io) bitcoin exchange. The API itself is described in Apiary (link: http://docs.coinmate.apiary.io).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coinmate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coinmate

## Usage

Create a Coinmate::Client instance as following:

```ruby
cmc = Coinmate::Client.new(CLIENT_ID, PUBKEY, PRIVKEY)
```

All three parameters are optional and when not used only public requests can be made. Attempt to access private parts throws Coinmate::Error exception.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kamk/coinmate.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


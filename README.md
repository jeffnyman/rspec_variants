# RSpec Variants

RSpec Variants adds an expressive layer to RSpec by allowing for test syntax based on explicit data conditions and test conditions, including a tabular syntax for the concise specification of related data.

## Installation

To get the latest stable release, add this line to your application's Gemfile:

```ruby
gem 'rspec_variants'
```

To get the latest code:

```ruby
gem 'rspec_variants', git: 'https://github.com/jeffnyman/rspec_variants'
```

After doing one of the above, execute the following command:

    $ bundle

You can also install RSpec Variants just as you would any other gem:

    $ gem install rspec_variants

## Usage

All you have to do is require `rspec_variants` from your `spec_helper` file. Then you can use the DSL provided to structure your tests.

An example of using the data and test conditions:

    context 'Rocky Planets' do
      data_condition(:planet, :weight) do
        [
          ['mercury', '75.6'],
          ['venus', '181.4'],
          ['mars', '75.4'],
          ['pluto', '13.4']
        ]
      end

      test_condition do
        it 'data condition: 200 pound weight' do
          expect(on(Planet).send("#{planet}").value).to eq(weight)
        end
    end

Here the `planet` and the `weight` values in the expect statement in the `test_condition` are referring to those same elements specified in the `data_condition`. In this case, RSpec will execute the test condition block for each one of the elements in the data condition block.

You can also use a tabular format for the above example, which would look like this:

    context 'Rocky Planets' do
      data_condition(:planet, :weight) do
        'mercury' | '75.6'
        'venus'   | '181.4'
        'mars'    | '75.4'
        'pluto'   | '13.4'
      end

      test_condition do
        it 'test condition: 200 pound weight' do
          on(Planet).confirm_weight_on(planet).is_exactly(weight)
        end
      end
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec:all` to run the tests. The default `rake` command will run all tests as well as a RuboCop analysis. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jeffnyman/rspec_variants](https://github.com/jeffnyman/rspec_variants). The testing ecosystem of Ruby is very large and this project is intended to be a welcoming arena for collaboration on yet another test-supporting tool. As such, contributors are very much welcome but are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

The RSpec Variants gem follows [semantic versioning](http://semver.org).

To contribute to RSpec Variants:

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create your feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).

## Author

* [Jeff Nyman](http://testerstories.com)

## Credits

RSpec Variants is based off of [RSpec::Parameterized](https://github.com/tomykaira/rspec-parameterized). The reason for a new version rather than a fork is I wanted to re-situate this kind of logic based on the idea of data and test conditions, which I think is a bit more operative in the context in which it runs. I also want to be able to expand to different forms of variant expression.

## License

RSpec Variants is distributed under the [MIT](http://www.opensource.org/licenses/MIT) license.
See the [LICENSE](https://github.com/jeffnyman/rspec_variants/blob/master/LICENSE.md) file for details.

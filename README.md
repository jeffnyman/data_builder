# DataBuilder

[![Gem Version](https://badge.fury.io/rb/data_builder.svg)](http://badge.fury.io/rb/data_builder)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jeffnyman/data_builder/blob/master/LICENSE.txt)

[![Dependency Status](https://gemnasium.com/jeffnyman/data_builder.png)](https://gemnasium.com/jeffnyman/data_builder)

The goal of DataBuilder is to apply an expressive means of constructing a data set based on information stored in YAML files.

## Installation

To get the latest stable release, add this line to your application's Gemfile:

```ruby
gem 'data_builder'
```

And then include it in your bundle:

    $ bundle

You can also install DataBuilder just as you would any other gem:

    $ gem install data_builder

## Usage

DataBuilder is using my [DataReader gem](https://github.com/jeffnyman/data_reader) to provide base-level functionality. Unlike DataReader, DataBuilder will assume some defaults.

### Loading with Default Path

Consider the following file and directory setup:

```
project_dir\
  config\
    config.yml

  data\
    stars.yml

  env\
    environments.yml

  example-data-builder.rb
```

All the code shown below would go in the `example-data-builder` file.

With the above class in place and the above directory structure, you could do something as simple as this:

```ruby
require "data_builder"

data = DataBuilder.load 'stars.yml'

puts data
```

Here I'm relying on the fact that DataBuilder applies a default directory of `data`. I then use the `load` method of DataReader to call up a file in that directory.

### Loading with Specified Path

You can set a specific data path with DataBuilder as such:

```ruby
require "data_builder"

DataBuilder.data_path = 'env'
```

Here you can inform DataBuilder where it can find the data files using `data_path`. As you've seen, if you don't specify a directory then DataBuilder will default to using a directory named `data`.

After setting the directory you must load a file. This can be accomplished by calling the `load` method.

```ruby
data = DataBuilder.load 'environments.yml'

puts data
```

Here the `data` variable would contain the contents of the `environments.yml` file.

However, everything said so far is really just using DataBuilder as an overlay for DataReader.

### Data About

Where DataBuilder steps in is when you want to use the data. DataBuilder provides a `data_about` method that will return the data for a specific key from any data files that have been loaded.

The most common way to use this is to include or extend the DataBuilder module. Let's say that you have a `data` directory and in that directory you have a file called `default.yml`. The YAML file has the following contents:

```yaml
alpha centauri:
  warpFactor: 1
  velocity: 2
  distance: 4.3

epsilon eridani:
  warpFactor: 1
  velocity: 2
  distance: 10.5
```

Now let's use DataBuilder to get the information from it. You can extend or include DataBuilder as part of another class.

#### Extending DataBuilder

```ruby
class Testing
  extend DataBuilder
end

data = Testing.data_about('alpha centauri')
```

#### Including DataBuilder

```ruby
class Testing
  include DataBuilder
end

testing = Testing.new
data = testing.data_about('alpha centauri')
```

### The Data Key

In both cases of extending or including, I'm using a variable to store the results of the call. Those results will be the data pulled from the `default.yml` file. Of note, however, is all that will be pulled is the data from the "alpha centauri" key because that is what you specified in the call to `data_about`.

Those examples show `data_about` being passed a string and the reason for that is because the value "alpha centauri" has a space in it. However, if that was not the case -- if the key were, say, "alpha_centauri" -- then you could use a symbol instead, like this:

```ruby
data = testing.data_about(:alpha_centauri)
```

### Default Files

You might wonder how DataBuilder knew to look for `default.yml` since I didn't use a `load` method in these examples. If you do not specify a filename the logic will attempt to use a file named `default.yml` in the specific data path you have specified or in the default path of `data`.
 
Another option is that you can set an environment variable called `DATA_BUILDER_SOURCE`. When this variable exists and is set, the value it is set to will be used instead of the `default.yml` file. Keep in mind that the "data source" here refers to the file, not the keys within a file.

### Namespaced Data

To organize your data into a rough equivalent of namespaces, and to load that data accordingly, you can do something like this:

```ruby
class Testing
  include DataBuilder
end

testing = Testing.new

data = testing.data_about('stars/epsilon eridani')
```

When DataBuilder sees this kind of construct, it will take the first part (before the /) as a filename and the second part as the key to look up in that file. So the above command would look for a file called `stars.yml` in the data path provided (in this case, the default of `data`) and then grab the data from the key entry labeled "epislon eridani".

### Aliases

Given the examples, you can see that `data_about` was chosen as the method name to make what's occurring a bit more expressive. You can use the following aliases for `data_about`:

* `data_from`
* `data_for`
* `using_data_for`
* `using_data_from`

The reason for these aliases is, again, to make the logic expressive about its intent. This is particularly nice if you fit DataBuilder in with the context of a fluent API.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec:all` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jeffnyman/data_builder](https://github.com/jeffnyman/data_builder). The testing ecosystem of Ruby is very large and this project is intended to be a welcoming arena for collaboration on yet another testing tool. As such, contributors are very much welcome but are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

To contribute to DataBuilder:

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create your feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).

## Author

* [Jeff Nyman](http://testerstories.com)

## Credits

This code is loosely based upon the [DataMagic](https://github.com/cheezy/data_magic) gem. I created a new version largely to avoid the name "magic", which I don't think any tool should be promoting. I'm also cleaning up the code and documentation.

## License

DataBuilder is distributed under the [MIT](http://www.opensource.org/licenses/MIT) license.
See the [LICENSE](https://github.com/jeffnyman/data_builder/blob/master/LICENSE.txt) file for details.

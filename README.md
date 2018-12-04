# DbSeed

To Avoid running seeds file multiple times

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'db_seed'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install db_seed
    
1. Add a `db_seeds` table to your database:

    ```
    bundle exec rails generate db_seed:install
    ```

    This will generate ``create_active_record_seeds.rb`` file in your application

    Please run

    ```
    bundle exec rake db:migrate
     ```
## Using for existing project

This will create a record in `seeds` table.
     
       bundle exec rake db:create_md5_checksum
        

    
## Usage

To Avoid running seeds file multiple times, So that records won't create multiple times.

## How it is works

Creating ``mds checksum`` based on `db/seed.rb` content, and creating one record in `db_seeds` table.

When `db:seed` task is running, creating `md5 checksum` and matching with database if its is same `md5 checksum`, I am not executing the `db:seed` task.
 
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jenorish/db_seed.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

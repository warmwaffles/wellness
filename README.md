# Wellness

[![Build Status](https://travis-ci.org/warmwaffles/wellness.png?branch=master)](https://travis-ci.org/warmwaffles/wellness)
[![Code Climate](https://codeclimate.com/github/warmwaffles/wellness.png)](https://codeclimate.com/github/warmwaffles/wellness)

A rack middleware library that adds a health check to your service. It comes
with pre made services and has the option and flexibility for you to make your
own.

## Usage - Rails

There are some pre configured services that are provided with this gem.
However, you must require them when you need them. This is because they have
external dependencies that need to be loaded, that your application may not
necessarily have.

```rb
# Within the configuration block

system = Wellness::System.new('my-uber-duber-app')
system.use(Wellness::Services::PostgresService, 'database', {
  host:     ENV['POSTGRESQL_HOST'],
  port:     ENV['POSTGRESQL_PORT'],
  database: ENV['POSTGRESQL_DATABASE'],
  user:     ENV['POSTGRESQL_USERNAME'],
  password: ENV['POSTGRESQL_PASSWORD']
})
system.use(Wellness::Services::RedisService, 'redis', {
  host: ENV['REDIS_HOST']
})

config.middleware.insert_before('::ActiveRecord::QueryCache', 'Wellness::Middleware', system)
```

## Usage - Sinatra

```ruby
require 'wellness'

system = Wellness::System.new('my-uber-duber-app')
system.use(Wellness::Services::PostgresService, 'database', {
  host:     ENV['POSTGRESQL_HOST'],
  port:     ENV['POSTGRESQL_PORT'],
  database: ENV['POSTGRESQL_DATABASE'],
  user:     ENV['POSTGRESQL_USERNAME'],
  password: ENV['POSTGRESQL_PASSWORD']
})
system.use(Wellness::Services::RedisService, 'redis', {
  host: ENV['REDIS_HOST']
})

use(Wellness::Middleware, system)
```

## Example Response

```json
{
  "status":"UNHEALTHY",
  "details":{

  },
  "dependencies":{
    "database":{
      "status":"UNHEALTHY",
      "details":{
        "error":"no response from ping"
      }
    },
    "sidekiq":{
      "status":"HEALTHY",
      "details":{
        "processed":0,
        "failed":0,
        "busy":0,
        "enqueued":0,
        "scheduled":0,
        "retries":0,
        "default_latency":0,
        "redis":{
          "uptime_in_days":"0",
          "connected_clients":"1",
          "used_memory_human":"979.22K",
          "used_memory_peak_human":"1.02M"
        }
      }
    }
  }
}
```

## Custom Services

Creating custom services is really easy. Always extend
`Wellness::Services::Base`.

Once that is done, you must implement the `#check` method.

The parameters passed into the service at creation are stored under `#params`.
Under no circumstances, should you ever modify the original parameters list at
run time. It can lead to unintended consequences, and weird bugs.

```ruby
# Your custom service
class MyCustomService < Wellness::Services::Base
  def check
    if params[:foo]
      {
        'status': 'HEALTHY'
      }
    else
      {
        'status': 'UNHEALTHY'
      }
    end
  end
end

# Initialize the wellness system
system = Wellness::System.new('my-app')
system.use(MyCustomService, 'some service', {foo: 'bar'})

# Load it into your rack
use(Wellness::Middleware, system)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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

```ruby
module MySuperCoolApplication
  class Application < Rails::Application
    system  = Wellness::System.new('my-super-cool-app')
    service = Wellness::Services::PostgresService.new({
      host:     ENV['POSTGRESQL_HOST'],
      port:     ENV['POSTGRESQL_PORT'],
      database: ENV['POSTGRESQL_DATABASE'],
      user:     ENV['POSTGRESQL_USERNAME'],
      password: ENV['POSTGRESQL_PASSWORD']
    })
    system.add_service('database', service, { critical: true })
    service = Wellness::Services::RedisService.new({
      host: ENV['REDIS_HOST']
    })
    system.add_service('redis', service, { critical: false})

    config.middleware.insert_before('::ActiveRecord::QueryCache', 'Wellness::Middleware', system)
  end
end
```

## Usage - Sinatra

```ruby
require 'wellness'

system  = Wellness::System.new('my-super-cool-app')
service = Wellness::Services::PostgresService.new({
  host:     ENV['POSTGRESQL_HOST'],
  port:     ENV['POSTGRESQL_PORT'],
  database: ENV['POSTGRESQL_DATABASE'],
  user:     ENV['POSTGRESQL_USERNAME'],
  password: ENV['POSTGRESQL_PASSWORD']
})
system.add_service('database', service, { critical: true })
service = Wellness::Services::RedisService.new({
  host: ENV['REDIS_HOST']
})
system.add_service('redis', service, { critical: false})

use(Wellness::Middleware, system)
```

## Example Responses

```json
{
  "status": "UNHEALTHY",
  "details": {
    "git" : {
      "revision" : "1234567"
    }
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

```json
{
    "status": "HEALTHY",
    "services": {
        "postgresql": {
            "status": "HEALTHY",
            "details": { }
        },
        "mysql": {
            "status": "HEALTHY",
            "details": { }
        }
    },
    "details": {
        "git": {
            "revision": "1234567"
        }
    }
}
```

## Custom Services

Creating a custom service is super easy. As long as the service responds to
`#call`, you are just fine. Passing a `lambda` or `Proc` is perfectly
acceptable.

### Requirements

This interface has a few requirements.

  1. A service **MUST** respond to `#call`
  2. A hash **MUST** be returned
  3. The hash returned **MUST** contain a `status` key at the root level.
  4. Status can **ONLY** be `HEALTHY`, `UNHEALTHY`, and `DEGRADED`
  5. All hash keys **MUST** be strings

### Example

```ruby
module MyServices
  class MySQLService
    def initialize(args={})
      @connection_options = {
        host: args[:host],
        port: args[:port],
        database: args[:database],
        username: args[:username],
        password: args[:password]
      }
    end

    def healthy(details={})
      {
        'status' => 'HEALTHY',
        'details' => details
      }
    end

    def unhealthy(details={})
      {
        'status' => 'UNHEALTHY',
        'details' => details
      }
    end

    def call
      connection = Mysql2::Client.new(@connection_options)
      connection.ping ? healthy : unhealthy
    rescue Mysql2::Error => error
      unhealthy('error' => error.message)
    end
  end
end

system = Wellness::System.new('my-app')
system.use('mysql', MyServices::MySQLService.new({
  # ... configuration ...
}))
```

## Custom Details

Details are useful if you want to display information on an application like the
current git revision, or how many requests have been serviced by the application.

### Requirements

  1. A detail **MUST** respond to `#call`
  2. A hash **MUST** be returned
  3. All hash keys **MUST** be strings

### Example

```ruby
# Your custom detail component
module MyDetails
  class GitRevisionDetail
    def call
      {
        'revision' => revision
      }
    end

    def revision
      `git rev-parse --short HEAD`.chomp
    end
  end
end
# Initialize the wellness system
system = Wellness::System.new('my-app')
system.use('git', MyDetails::GitRevisionDetail.new)

# Load it into your rack
use(Wellness::Middleware, system)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

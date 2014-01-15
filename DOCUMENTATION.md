# HTTP Applications

Services **MUST** supply an endpoint for determining their health. Health and
status information **MUST** be supplied under the `/health` path. Responses for
health and status information **MUST** be valid json by default. Services
**MAY** be provided in other formats by supplying a `format` parameter with
appropriate values such as `xml`.

## Status

A summarized status for a given application **MUST** be available from the
route `/health/status`. The response **MUST** be one of the following:

- `{ "status": "HEALTHY" }` with HTTP status code `200`
- `{ "status": "UNHEALTHY" }` with HTTP status code `500`

## Details

Detailed status for a given application **MUST** be available from the route
`/health/details`. The response **MUST** be returned with in the following
format:

```json
{
  "status": "HEALTHY",
  "details": {
    "requests": {
      "last_hour": 512,
      "last_day": 12288
    },
    "top_consumers": {
      "last_hour": {
        "foo": 128,
        "bar": 64,
        "baz": 32
      },
      "last_day": {
        "foo": 3072,
        "bar": 1536,
        "baz": 768
      }
    }
  },
  "dependencies": {
    "cache": {
      "status": "HEALTHY"
    },
    "database": {
      "status": "HEALTHY",
      "details": {
        "connection": "read_write",
        "reads": {
          "last_hour": 1234,
          "last_day": 29616
        }
      }
    }
  }
}
```

## Requirements

Top level keys, `status` and `dependencies` are **REQUIRED**.

* The `status` key **MUST** have one of the values listed in the specification
  for the `/health/status` response
* A `details` key is **RECOMMENDED** to be included which contains a dictionary
  of any metrics the service has.
* The `dependencies` key **MUST** contain a dictionary of all services on which
  your service depends on.
  * Keys **MUST** be unique for each service.
  * Values **MUST** be a dictionary containing at least the key `status`
    * Valid values for `status`:
      * `HEALTHY`
      *`UNHEALTHY`
  * A `details` key **MAY** be added with any additional information to report
    on the service.

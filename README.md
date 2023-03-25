# Simple Drive

Simple Drive is a Ruby on Rails application that provides APIs to store and retrieve objects or files.

## Requirements
Ruby >= 3.1.2

## Supported storage backends

- Amazon S3
- PostgreSQL table
- Local file system

## Setup the project
First you have to:

    bundle install
Then

    rails db:create && rails db:migrate && rails db:seed

### Storage backends configuration

All the configurations are stored in `storage.yml` file.

#### Local storage

You can specify your own path for storing files in `root` key. By default it is Rails' app `storage/` directory.

```yaml
# config/storage.yml
local:
  service: Disk
  root: <%= Rails.root.join("storage") %>
```

#### Amazon S3

```yaml
# config/storage.yml
amazon:
  service: S3
  access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
  secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
  region: eu-central-1
  bucket: <bucket name>
```

#### PostgreSQL
No need passing any credentials, data will be stored in Rails app's database.
Under the hood, gem `active_storage-postgresql` is used.
```yaml
# config/storage.yml
db:
  service: PostgreSQL
```

## Storing a Blob

A user can store a blob of data using the service by making a `POST` request to the endpoint `/v1/blobs`.

Storage backend provides as query parameter like that:
`/v1/blobs?storage=db`, `/v1/blobs?storage=local`,

where the value of `storage=` is the key of service specified in `config/storage.yml`

The endpoint expects the following JSON object:

```json
{
    "id": "any_valid_identifier",
    "data": "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh"
}
```

By author, a decision was made to use the `bigserial` ids for simplicity purposes which is also commonly used in relational databases.

## Retrieving a Blob
Retrieving data is available through the following endpoint `/v1/blobs/<id>`.

```json
{
  "id": "any_valid_string_or_identifier",
  "data": "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh",
  "size": "27",
  "created_at": "2023-01-22T21:37:55Z"
}
```
A user can retrieve a blob using the same id used when saving the data to the storage server.

## Authentication

Authentication is implemented via `Bearer` token authentication with `jwt` gem.

Retrieving access token by the following endpoint `/authenticate` with making `POST` request.

The endpoint expects the following JSON object:

```json
{
  "email": "...",
  "password": "..."
}
```

If provided credentials are valid, the server responses with:

```json
{
  "token": "..."
}
```

Otherwise:

```json
{
  "error": "invalid email or password"
}
```

Accessing blob endpoints allowed **only for authenticated users**.

Otherwise the server will respond with 401 status code and message HTTP Token: Access denied (comes from `ActionController::HttpAuthentication::Token`).

## Testing

    rails spec

Tests are covered only for main parts of the app, I didn't chase 100% test coverage:

- Unit tests for `Blob services`
- Integration tests for `BlobsControllers`.

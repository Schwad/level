use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :level, LevelWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: System.get_env("LEVEL_HOST"), port: 443, scheme: "https"],
  static_url: [scheme: "https", host: System.get_env("LEVEL_CDN_HOST"), port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("LEVEL_SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :level, Level.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("LEVEL_DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("LEVEL_POOL_SIZE") || "10"),
  ssl: true

# Configure the mailer
config :level, Level.Mailer,
  adapter: Bamboo.PostmarkAdapter,
  api_key: System.get_env("POSTMARK_API_KEY")

# Configure asset storage
config :level, :asset_store,
  bucket: System.get_env("LEVEL_ASSET_STORE_BUCKET"),
  adapter: Level.AssetStore.S3Adapter

# Web push
config :level, Level.WebPush,
  adapter: Level.WebPush.HttpAdapter,
  retry_timeout: 1000,
  max_attempts: 5

# Configure browser push notifications
config :web_push_encryption, :vapid_details,
  subject: "https://level.app",
  public_key: System.get_env("LEVEL_WEB_PUSH_PUBLIC_KEY"),
  private_key: System.get_env("LEVEL_WEB_PUSH_PRIVATE_KEY")

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :level, Level.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :level, Level.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :level, Level.Endpoint, server: true
#

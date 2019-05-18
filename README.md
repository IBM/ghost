# 👻Ghost

[Available in Hex](https://hexdocs.pm/ghost)

The package can be installed
by adding `ghost` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ghost, "~> 0.1.0"},
    {:brod, "~> 3.7"} # Only add if you want to use brod for your Kafka client
  ]
end
```

## Introduction

At IBM many of our internal cloud services connect via a kafka based service bus. While this allows our developers to easily exchange information, it makes testing these services extremely difficult as Kafka is neither transactional nor synchronous in many common usage patterns. Your service may publish a message to kafka, but it can take an indeterminate amount of time to read that message back making unit testing in elixir near impossible. Which is why we developed Ghost.

Ghost aims to offer the same kind testing experience as Ecto provides for databases via the `Ecto.Adapter.Sandbox`.

## How to use it?

### Production and Dev Usage

Out of the box `Ghost` provides a default module (`Ghost`) that changes it's implementation based on configuration options. These configuration options are as follows

```elixir
config :ghost, Ghost,
  client: :brod_client,
  adapter: Ghost.VirtualQueue
```

At IBM we have both our `dev.exs` and `prod.exs` file configured somewhat like this, the host name for Kafka obviously changes between deploys, but in general that's what it looks like for both files. You configure brod to make sure you can connect to kafka in a prod environment, and specify that the implementation of Ghost you would like to use is the Kafka backend.

```elixir
config :brod,
  clients: [
    brod_client: [ # notice this key is equal to client in ghost
      endpoints: [
        {'kafka.dev', 9_095}
      ],
      reconnect_cool_down_seconds: 10,
      auto_start_producers: true
    ]
  ]

config :ghost, Ghost,
  queue_adapter: Ghost.Kafka,
  client: :brod_client # notice this value is equal to the brod config
```

This configuration uses `brod` for the `Ghost` implementation and you would use it like this

```elixir
iex(1)> Ghost.produce_sync("kafka_topic_name", "key", "payload")
{:ok, 0}
```

Which will place the __message__  `"payload"` on the `"kafka_topic_name"`️ __topic__ with __key__ set to `"key"`. This a production and dev configuration where we actually want to produce messages to Kafka.

### Testing Usage

## How does it work?

Every adapter must implement the `Ghost.Queue` behavior which includes 2 synchronous produce APIs, 2 async produce APIs, and one fetch API. Any new adapters simply implement the API and the implementation can be provided in the configuration.

```elixir
defmodule Ghost.Queue do
  @doc """
  The `produce_sync/5` function will add a value to the topic and partition synchronously.
  """
  @callback produce_sync(
              atom() | pid(),
              String.t(),
              (String.t(), integer(), binary(), binary() -> {:ok, integer()}),
              binary(),
              binary()
            ) :: {:ok, integer()} | {:error, any()}

  @doc """
  Same as `produce_sync/4`, but uses a predefined partition selection function.
  """
  @callback produce_sync(atom() | pid(), String.t(), binary(), binary()) :: {:ok, integer()} | {:error, any()}

  @doc """
  This is an asynchronous produce to the queue. This function will send a message to the caller
  of a format specified by the specific implementation of `Queue`.
  """
  @callback produce(
              atom() | pid(),
              String.t(),
              (String.t(), integer(), binary(), binary() -> {:ok, integer()}),
              binary(),
              binary()
            ) :: {:ok, any()} | {:error, any()}

  @doc """
  Same as `produce/5`, but uses a predefined partition selection function.
  """
  @callback produce(
              atom() | pid(),
              String.t(),
              binary(),
              binary()
            ) :: {:ok, any()} | {:error, any()}

  @doc """
  Returns a list of messages produced by a pid to a topic in the order that they were produced in.
  """
  @callback fetch(pid(), String.t()) :: [binary()]
end
```

## Limitations

Currently `ghost` only supports only provides a one kafka adapter out of the box for the [brod](https://github.com/klarna/brod) client provided by Klarna. Internally brod is the prefered client for both Elixir and Erlang code as it is the most up to date and complete Kafka client. An adapter could be provided for [kafka_ex](https://github.com/kafkaex/kafka_ex) by implementing the behavior defined in `Ghost.Queue`.


# 👻Ghost

## Installation

If [available in Hex](https://hexdocs.pm/ghost), the package can be installed
by adding `ghost` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ghost, "~> 0.1.0"},
    {:brod, "~> 3.7"}
  ]
end
```

## Introduction

At IBM many of our internal cloud services connect via a kafka based service bus. While this allows our developers to easily exchange information, it makes testing these services extremely difficult as Kafka is neither transactional nor synchronous in many common usage patterns. Your service may publish a message to kafka, but it can take an indeterminate amount of time to read that message back making unit testing in elixir near impossible. Which is why we developed Ghost.

Ghost aims to offer the same kind testing experience as Ecto provides for databases via the `Ecto.Adapter.Sandbox`.

## How does it work?

```elixir
defmodule Ghost.Queue do
  @doc """
  The `produce_sync/5` function will add a value to the topic and partition syncronously.
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
  This is an asyncrounous produce to the queue. This function will send a message to the caller
  of a format specified by the specific implenation of `Queue`.
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


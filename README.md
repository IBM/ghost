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

Ghost aims to offer the same kind testing as Ecto provides for databases via the `Ecto.Adapter.Sandbox`.

## How does it work?

## Limitations

Currently `ghost` only supports only provides a one kafka adapter out of the box for the [brod](https://github.com/klarna/brod) client provided by Klarna. Internally brod is the prefered client for both Elixir and Erlang code as it is the most up to date and complete Kafka client. An adapter could be provided for [kafka_ex](https://github.com/kafkaex/kafka_ex) by implementing the behavior defined in `Ghost.Queue`.


![IBM](https://www.ibm.com/design/language/2285fa814297ab5eb0ffa21d2ee009db.svg)
